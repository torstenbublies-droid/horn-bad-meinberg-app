import { chromium } from 'playwright';
import * as cheerio from 'cheerio';
import pg from 'pg';

const { Pool } = pg;

const pool = new Pool({
  host: '127.0.0.1',
  port: 5432,
  database: 'buergerapp',
  user: 'buergerapp_user',
  password: 'buergerapp_dev_2025',
});

interface EducationFacility {
  name: string;
  category: string;
  address: string;
  phone: string;
  fax: string;
  email: string;
  website: string;
  openingHours: string;
  description: string;
}

// Category icon and color mapping
const categoryMapping: Record<string, { icon: string; color: string }> = {
  'Kindergärten': { icon: 'Baby', color: 'pink' },
  'Schulen': { icon: 'GraduationCap', color: 'indigo' },
  'Stadtbücherei': { icon: 'BookOpen', color: 'emerald' },
};

// Pages to scrape
const pages = [
  {
    url: 'https://www.schieder-schwalenberg.de/Familie-und-Soziales/Bildung/Kindergärten',
    category: 'Kindergärten',
  },
  {
    url: 'https://www.schieder-schwalenberg.de/Familie-und-Soziales/Bildung/Schulen',
    category: 'Schulen',
  },
  {
    url: 'https://www.schieder-schwalenberg.de/Familie-und-Soziales/Bildung/Stadtbücherei',
    category: 'Stadtbücherei',
  },
];

function parseTextContent(text: string, category: string): EducationFacility[] {
  const facilities: EducationFacility[] = [];
  
  // Split by "KONTAKT" section
  const kontaktSection = text.split('KONTAKT')[1];
  if (!kontaktSection) {
    console.log('No KONTAKT section found');
    return facilities;
  }
  
  // Split by "DOKUMENTE" or "LINKS" to get only contact data
  const contactData = kontaktSection.split(/DOKUMENTE|LINKS|nach oben/)[0];
  
  // Split into blocks (each facility is separated by double newlines)
  const blocks = contactData.split(/\n\s*\n/).filter(b => b.trim());
  
  for (const block of blocks) {
    const lines = block.split('\n').map(l => l.trim()).filter(l => l);
    
    if (lines.length < 2) continue;
    
    // First line is the name
    const name = lines[0];
    
    // Skip if it's not a facility name
    if (!name || name.length < 5 || name.includes('©') || name.includes('Öffnungszeiten')) {
      continue;
    }
    
    let address = '';
    let phone = '';
    let fax = '';
    let email = '';
    let website = '';
    let openingHours = '';
    
    const addressParts: string[] = [];
    let isOpeningHours = false;
    
    for (let i = 1; i < lines.length; i++) {
      const line = lines[i];
      
      // Opening hours detection
      if (line.match(/öffnungszeit|dienstag|montag|mittwoch|donnerstag|freitag|samstag|sonntag/i)) {
        isOpeningHours = true;
      }
      
      if (isOpeningHours) {
        openingHours += line + '\n';
        continue;
      }
      
      // Phone (format: Telefon: 05282 / 6160)
      if (line.match(/^Telefon:/i)) {
        phone = line.replace(/^Telefon:\s*/i, '').trim();
        continue;
      }
      
      // Fax
      if (line.match(/^Fax:/i)) {
        fax = line.replace(/^Fax:\s*/i, '').trim();
        continue;
      }
      
      // Skip "E-Mail oder Kontaktformular" lines
      if (line.match(/E-Mail oder Kontaktformular/i)) {
        continue;
      }
      
      // Address: street or PLZ + city
      if (line.match(/straße|weg|platz|allee|ring|pfad|gasse|damm|berg|feld|born|tal|postfach|^\d{5}\s+/i)) {
        addressParts.push(line);
        continue;
      }
      
      // Additional description lines (like "des Deutschen Roten Kreuzes")
      if (i === 1 && !line.match(/straße|weg|^\d{5}|Telefon|Fax/i)) {
        // This is a subtitle/description
        continue;
      }
    }
    
    address = addressParts.join(', ');
    
    // Only add if we have at least a name and address or phone
    if (name && (address || phone)) {
      facilities.push({
        name,
        category,
        address,
        phone,
        fax,
        email,
        website,
        openingHours: openingHours.trim(),
        description: '',
      });
    }
  }
  
  return facilities;
}

async function scrapePage(url: string, category: string): Promise<EducationFacility[]> {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  
  console.log(`\n=== Scraping ${category} ===`);
  console.log(`URL: ${url}`);
  
  await page.goto(url, { waitUntil: 'networkidle', timeout: 60000 });
  
  // Accept cookies if present
  try {
    await page.click('#cookie-note-accept', { timeout: 2000 });
    await page.waitForTimeout(1000);
  } catch (err) {
    // Cookie banner not found
  }
  
  // Get all text content
  const textContent = await page.evaluate(() => document.body.innerText);
  
  await browser.close();
  
  const facilities = parseTextContent(textContent, category);
  
  console.log(`Found ${facilities.length} facilities`);
  facilities.forEach(f => console.log(`  - ${f.name}`));
  
  return facilities;
}

async function scrapeAllPages(): Promise<EducationFacility[]> {
  const allFacilities: EducationFacility[] = [];
  
  for (const pageInfo of pages) {
    try {
      const facilities = await scrapePage(pageInfo.url, pageInfo.category);
      allFacilities.push(...facilities);
    } catch (err) {
      console.error(`Error scraping ${pageInfo.category}:`, err);
    }
  }
  
  console.log(`\n=== Total scraped: ${allFacilities.length} facilities ===`);
  return allFacilities;
}

async function saveToDatabase(facilities: EducationFacility[]) {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Get tenant_id for Schieder
    const tenantResult = await client.query(
      'SELECT id FROM tenants WHERE slug = $1',
      ['schieder']
    );
    
    if (tenantResult.rows.length === 0) {
      throw new Error('Tenant "schieder" not found');
    }
    
    const tenantId = tenantResult.rows[0].id;
    
    // Delete existing facilities
    await client.query('DELETE FROM education_facilities WHERE tenant_id = $1', [tenantId]);
    console.log('\nDeleted existing facilities');
    
    // Create categories
    const categories = new Set(facilities.map(f => f.category));
    const categoryIds: Record<string, number> = {};
    
    let displayOrder = 0;
    for (const categoryName of categories) {
      const mapping = categoryMapping[categoryName] || { icon: 'Building', color: 'gray' };
      
      const result = await client.query(
        `INSERT INTO education_categories (tenant_id, name, icon, color, display_order)
         VALUES ($1, $2, $3, $4, $5)
         ON CONFLICT (tenant_id, name) DO UPDATE
         SET icon = EXCLUDED.icon, color = EXCLUDED.color, display_order = EXCLUDED.display_order
         RETURNING id`,
        [tenantId, categoryName, mapping.icon, mapping.color, displayOrder++]
      );
      
      categoryIds[categoryName] = result.rows[0].id;
    }
    
    console.log(`Created ${categories.size} categories`);
    
    // Insert facilities
    let insertedCount = 0;
    let skippedCount = 0;
    
    for (const facility of facilities) {
      const categoryId = categoryIds[facility.category];
      
      try {
        await client.query(
          `INSERT INTO education_facilities (tenant_id, category_id, name, address, phone, fax, email, website, opening_hours, description)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
           ON CONFLICT (tenant_id, name) DO UPDATE
           SET category_id = EXCLUDED.category_id,
               address = EXCLUDED.address,
               phone = EXCLUDED.phone,
               fax = EXCLUDED.fax,
               email = EXCLUDED.email,
               website = EXCLUDED.website,
               opening_hours = EXCLUDED.opening_hours,
               description = EXCLUDED.description,
               updated_at = CURRENT_TIMESTAMP`,
          [tenantId, categoryId, facility.name, facility.address, facility.phone, facility.fax, facility.email, facility.website, facility.openingHours, facility.description]
        );
        insertedCount++;
        console.log(`✓ ${facility.name} (${facility.category})`);
      } catch (err) {
        console.log(`✗ Skipped ${facility.name}: ${err}`);
        skippedCount++;
      }
    }
    
    await client.query('COMMIT');
    console.log(`\nImported ${insertedCount} facilities, skipped ${skippedCount}`);
    
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error saving to database:', err);
    throw err;
  } finally {
    client.release();
  }
}

async function main() {
  try {
    const facilities = await scrapeAllPages();
    await saveToDatabase(facilities);
    console.log('Done!');
  } catch (err) {
    console.error('Error:', err);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

main();
