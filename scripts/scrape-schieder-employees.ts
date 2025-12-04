#!/usr/bin/env tsx

/**
 * Scrape employees and departments from Schieder-Schwalenberg website
 * Run: npx tsx scripts/scrape-schieder-employees.ts
 */

import { chromium } from 'playwright';
import pkg from 'pg';
const { Pool } = pkg;
import * as fs from 'fs';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://buergerapp_user:buergerapp_dev_2025@localhost:5432/buergerapp'
});

interface Employee {
  name: string;
  department: string;
  title?: string;
  responsibilities?: string;
  phone?: string;
  fax?: string;
  email?: string;
  room?: string;
  address?: string;
  officeHours?: string;
}

// Map department names to icons (lucide-react icon names)
const DEPARTMENT_ICONS: Record<string, string> = {
  'Bürgermeister': 'Crown',
  'Fachbereich Finanzen und Organisation': 'Calculator',
  'Fachbereich Ordnung und Soziales': 'Users',
  'Fachbereich Stadtentwicklung': 'Building',
  'Bauhof': 'Wrench',
  'Bürger-und Gästeinformation': 'Info',
  'Touristinfo': 'MapPin',
  'Auszubildende': 'GraduationCap',
  'Betreuung': 'Heart'
};

function getDepartmentIcon(departmentName: string): string {
  // Try exact match first
  if (DEPARTMENT_ICONS[departmentName]) {
    return DEPARTMENT_ICONS[departmentName];
  }
  
  // Try partial match
  for (const [key, icon] of Object.entries(DEPARTMENT_ICONS)) {
    if (departmentName.includes(key) || key.includes(departmentName)) {
      return icon;
    }
  }
  
  // Default icon
  return 'Briefcase';
}

function normalizeDepartmentName(name: string): string {
  // Normalize department names for consistency
  name = name.trim();
  
  if (name.includes('Finanzen')) return 'Fachbereich Finanzen und Organisation';
  if (name.includes('Ordnung') || name.includes('Soziales')) return 'Fachbereich Ordnung und Soziales';
  if (name.includes('Stadtentwicklung')) return 'Fachbereich Stadtentwicklung';
  if (name.includes('Bauhof')) return 'Bauhof';
  if (name.includes('Bürgermeister')) return 'Bürgermeister';
  if (name.includes('Bürger-und Gästeinformation') || name.includes('Gästeinformation')) return 'Bürger-und Gästeinformation';
  if (name.includes('Touristinfo') || name.includes('Tourist')) return 'Touristinfo';
  if (name.includes('Auszubildende')) return 'Auszubildende';
  if (name.includes('Betreuung')) return 'Betreuung';
  
  return name;
}

async function parseEmployeesFromMarkdown(): Promise<Employee[]> {
  const markdownPath = '/home/ubuntu/page_texts/www.schieder-schwalenberg.de_Bürger-und-Service_Rathaus_Mitarbeiter.md';
  
  if (!fs.existsSync(markdownPath)) {
    console.log('Markdown file not found, scraping...');
    await scrapeEmployeesPage();
    
    if (!fs.existsSync(markdownPath)) {
      throw new Error('Failed to create markdown file');
    }
  }
  
  const markdown = fs.readFileSync(markdownPath, 'utf-8');
  const employees: Employee[] = [];
  
  // Split by employee entries
  const lines = markdown.split('\n');
  let currentEmployee: Partial<Employee> | null = null;
  
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();
    
    // Check if this is a name line (starts with Frau/Herr)
    if (line.match(/^(Frau|Herr)\s+[A-ZÄÖÜ]/)) {
      // Save previous employee
      if (currentEmployee && currentEmployee.name && currentEmployee.department) {
        employees.push(currentEmployee as Employee);
      }
      
      // Start new employee
      currentEmployee = {
        name: line,
        department: '',
        address: ''
      };
      continue;
    }
    
    if (!currentEmployee) continue;
    
    // Check for department (usually next line after name)
    if (!currentEmployee.department && line && 
        (line.includes('Fachbereich') || line.includes('Bauhof') || 
         line.includes('Bürgermeister') || line.includes('Information') || 
         line.includes('Touristinfo') || line.includes('Auszubildende') ||
         line.includes('Betreuung'))) {
      currentEmployee.department = normalizeDepartmentName(line);
      continue;
    }
    
    // Check for responsibilities/title (line after department, before address)
    if (currentEmployee.department && !currentEmployee.title && line && 
        !line.match(/^\d/) && !line.includes('Domäne') && !line.includes('Kurpark') &&
        !line.includes('Marktstraße') && line.length > 5 && line.length < 200) {
      currentEmployee.title = line;
      continue;
    }
    
    // Check for address
    if (line.includes('Domäne') || line.includes('Kurpark') || line.includes('Marktstraße')) {
      if (!currentEmployee.address) {
        currentEmployee.address = line;
      } else {
        currentEmployee.address += ', ' + line;
      }
      continue;
    }
    
    // Check for phone (starts with 05282 or similar)
    if (line.match(/^0\d{4,5}\s*[\/\-]?\s*\d{3,}/)) {
      if (!currentEmployee.phone) {
        currentEmployee.phone = line.replace(/\s+/g, '');
      } else if (!currentEmployee.fax) {
        currentEmployee.fax = line.replace(/\s+/g, '');
      }
      continue;
    }
    
    // Check for room
    if (line.startsWith('Raum:')) {
      currentEmployee.room = line.replace('Raum:', '').trim();
      continue;
    }
    
    // Check for office hours
    if (line.includes('Sprechzeiten')) {
      currentEmployee.officeHours = line.replace('Sprechzeiten.', '').trim();
      continue;
    }
  }
  
  // Save last employee
  if (currentEmployee && currentEmployee.name && currentEmployee.department) {
    employees.push(currentEmployee as Employee);
  }
  
  console.log(`Parsed ${employees.length} employees from markdown`);
  return employees;
}

async function scrapeEmployeesPage() {
  console.log('Scraping employees page...');
  
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  
  try {
    const url = 'https://www.schieder-schwalenberg.de/Bürger-und-Service/Rathaus/Mitarbeiter';
    console.log(`Loading ${url}...`);
    
    await page.goto(url, { 
      waitUntil: 'networkidle',
      timeout: 60000 
    });
    
    console.log('Page loaded successfully');
    await browser.close();
    
  } catch (error) {
    console.error('Scraping error:', error);
    await browser.close();
    throw error;
  }
}

async function saveDepartmentsAndEmployees(employees: Employee[], tenantId: string) {
  console.log(`Saving departments and employees to database...`);
  
  // Extract unique departments
  const departmentNames = new Set<string>();
  employees.forEach(emp => {
    if (emp.department) {
      departmentNames.add(emp.department);
    }
  });
  
  console.log(`Found ${departmentNames.size} departments`);
  
  // Define display order for departments
  const departmentOrder: Record<string, number> = {
    'Bürgermeister': 1,
    'Fachbereich Finanzen und Organisation': 2,
    'Fachbereich Ordnung und Soziales': 3,
    'Fachbereich Stadtentwicklung': 4,
    'Bauhof': 5,
    'Bürger-und Gästeinformation': 6,
    'Touristinfo': 7,
    'Auszubildende': 8,
    'Betreuung': 9
  };
  
  // Save departments
  const departmentMap = new Map<string, number>();
  
  for (const deptName of departmentNames) {
    const icon = getDepartmentIcon(deptName);
    const displayOrder = departmentOrder[deptName] || 99;
    
    try {
      const result = await pool.query(
        `INSERT INTO departments (tenant_id, name, icon, display_order)
         VALUES ($1, $2, $3, $4)
         ON CONFLICT (tenant_id, name) DO UPDATE
         SET icon = EXCLUDED.icon,
             display_order = EXCLUDED.display_order,
             updated_at = CURRENT_TIMESTAMP
         RETURNING id`,
        [tenantId, deptName, icon, displayOrder]
      );
      
      departmentMap.set(deptName, result.rows[0].id);
      console.log(`  ✓ ${deptName} (${icon})`);
      
    } catch (error: any) {
      console.error(`  ✗ Error saving department ${deptName}:`, error.message);
    }
  }
  
  // Save employees
  let saved = 0;
  let updated = 0;
  
  for (const emp of employees) {
    const departmentId = departmentMap.get(emp.department);
    
    if (!departmentId) {
      console.log(`  ⚠ Skipping ${emp.name} - department not found`);
      continue;
    }
    
    try {
      const result = await pool.query(
        `INSERT INTO employees (tenant_id, department_id, name, title, responsibilities, phone, fax, email, room, address, office_hours, source_url)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
         ON CONFLICT (tenant_id, name, phone) DO UPDATE
         SET department_id = EXCLUDED.department_id,
             title = EXCLUDED.title,
             responsibilities = EXCLUDED.responsibilities,
             fax = EXCLUDED.fax,
             email = EXCLUDED.email,
             room = EXCLUDED.room,
             address = EXCLUDED.address,
             office_hours = EXCLUDED.office_hours,
             updated_at = CURRENT_TIMESTAMP
         RETURNING (xmax = 0) AS inserted`,
        [
          tenantId,
          departmentId,
          emp.name,
          emp.title || null,
          emp.responsibilities || null,
          emp.phone || null,
          emp.fax || null,
          emp.email || null,
          emp.room || null,
          emp.address || null,
          emp.officeHours || null,
          'https://www.schieder-schwalenberg.de/Bürger-und-Service/Rathaus/Mitarbeiter'
        ]
      );
      
      if (result.rows[0].inserted) {
        saved++;
      } else {
        updated++;
      }
      
    } catch (error: any) {
      console.error(`  ✗ Error saving ${emp.name}:`, error.message);
    }
  }
  
  console.log(`✅ Employees: ${saved} new, ${updated} updated`);
}

async function main() {
  try {
    const tenantResult = await pool.query(
      `SELECT id FROM tenants WHERE slug = 'schieder' LIMIT 1`
    );
    
    if (tenantResult.rows.length === 0) {
      throw new Error('Schieder tenant not found');
    }
    
    const tenantId = tenantResult.rows[0].id;
    console.log(`Tenant: ${tenantId}`);
    
    const employees = await parseEmployeesFromMarkdown();
    
    if (employees.length === 0) {
      console.log('No employees found');
      return;
    }
    
    await saveDepartmentsAndEmployees(employees, tenantId);
    console.log('Done!');
    
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

main();
