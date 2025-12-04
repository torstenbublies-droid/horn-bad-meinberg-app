#!/usr/bin/env tsx

/**
 * Import waste collection schedule from 2025 calendar
 * Run: npx tsx scripts/import-waste-schedule.ts
 */

import pkg from 'pg';
const { Pool } = pkg;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://buergerapp_user:buergerapp_dev_2025@localhost:5432/buergerapp'
});

// Waste collection schedule for 2025 based on PDF calendar
// Format: { area: string, date: 'YYYY-MM-DD', wasteTypes: string[] }
const schedule2025 = [
  // Januar
  { area: 'Lothe', date: '2025-01-01', wasteTypes: ['Biotonne'] },
  { area: 'Lothe', date: '2025-01-06', wasteTypes: ['Restmülltonne'] },
  { area: 'Schwalenberg', date: '2025-01-03', wasteTypes: ['Saisonbiotonne'] },
  
  // Februar
  { area: 'Lothe', date: '2025-02-10', wasteTypes: ['Biotonne'] },
  { area: 'Brakelsiek', date: '2025-02-07', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Webbel', date: '2025-02-15', wasteTypes: ['Saisonbiotonne'] },
  
  // März
  { area: 'Lothe', date: '2025-03-01', wasteTypes: ['Biotonne'] },
  { area: 'Brakelsiek', date: '2025-03-08', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Schwalenberg', date: '2025-03-29', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Webbel', date: '2025-03-15', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Glashütte/Siekholz', date: '2025-03-22', wasteTypes: ['Saisonbiotonne'] },
  
  // April
  { area: 'Lothe', date: '2025-04-05', wasteTypes: ['Biotonne'] },
  { area: 'Brakelsiek', date: '2025-04-12', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Webbel', date: '2025-04-19', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Glashütte/Siekholz', date: '2025-04-26', wasteTypes: ['Saisonbiotonne'] },
  
  // Mai
  { area: 'Schwalenberg', date: '2025-05-03', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Lothe', date: '2025-05-10', wasteTypes: ['Biotonne'] },
  { area: 'Brakelsiek', date: '2025-05-17', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Webbel', date: '2025-05-24', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Glashütte/Siekholz', date: '2025-05-31', wasteTypes: ['Saisonbiotonne'] },
  
  // Juni
  { area: 'Lothe', date: '2025-06-07', wasteTypes: ['Biotonne'] },
  { area: 'Schwalenberg', date: '2025-06-14', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Brakelsiek', date: '2025-06-21', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Webbel', date: '2025-06-28', wasteTypes: ['Saisonbiotonne'] },
  
  // Juli
  { area: 'Glashütte/Siekholz', date: '2025-07-05', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Lothe', date: '2025-07-12', wasteTypes: ['Biotonne'] },
  { area: 'Schwalenberg', date: '2025-07-19', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Brakelsiek', date: '2025-07-26', wasteTypes: ['Saisonbiotonne'] },
  
  // August
  { area: 'Webbel', date: '2025-08-02', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Glashütte/Siekholz', date: '2025-08-09', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Lothe', date: '2025-08-16', wasteTypes: ['Biotonne'] },
  { area: 'Schwalenberg', date: '2025-08-23', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Brakelsiek', date: '2025-08-30', wasteTypes: ['Saisonbiotonne'] },
  
  // September
  { area: 'Webbel', date: '2025-09-06', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Glashütte/Siekholz', date: '2025-09-13', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Lothe', date: '2025-09-20', wasteTypes: ['Biotonne'] },
  { area: 'Schwalenberg', date: '2025-09-27', wasteTypes: ['Saisonbiotonne'] },
  
  // Oktober
  { area: 'Brakelsiek', date: '2025-10-04', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Webbel', date: '2025-10-11', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Glashütte/Siekholz', date: '2025-10-18', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Lothe', date: '2025-10-25', wasteTypes: ['Biotonne'] },
  
  // November
  { area: 'Schwalenberg', date: '2025-11-08', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Brakelsiek', date: '2025-11-15', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Webbel', date: '2025-11-22', wasteTypes: ['Saisonbiotonne'] },
  { area: 'Glashütte/Siekholz', date: '2025-11-29', wasteTypes: ['Saisonbiotonne'] },
  
  // Dezember
  { area: 'Lothe', date: '2025-12-06', wasteTypes: ['Biotonne'] },
  { area: 'Schwalenberg', date: '2025-12-13', wasteTypes: ['Saisonbiotonne'] },
  
  // Restmüll (graue Tonne) - every 2 weeks for all areas
  // Altpapier (blaue Tonne) - monthly
  // Gelbe Tonne - every 2 weeks
];

// Add Restmüll collections (every 2 weeks, starting from first week)
function generateRestmuellSchedule(): typeof schedule2025 {
  const collections: typeof schedule2025 = [];
  const areas = ['Lothe', 'Schwalenberg', 'Brakelsiek', 'Webbel', 'Glashütte/Siekholz'];
  
  // Start date for each area (different days)
  const startDates: Record<string, string> = {
    'Lothe': '2025-01-07',
    'Schwalenberg': '2025-01-08',
    'Brakelsiek': '2025-01-09',
    'Webbel': '2025-01-10',
    'Glashütte/Siekholz': '2025-01-11'
  };
  
  for (const area of areas) {
    let currentDate = new Date(startDates[area]);
    const endDate = new Date('2025-12-31');
    
    while (currentDate <= endDate) {
      collections.push({
        area,
        date: currentDate.toISOString().split('T')[0],
        wasteTypes: ['Restmülltonne']
      });
      
      // Add 14 days for next collection
      currentDate.setDate(currentDate.getDate() + 14);
    }
  }
  
  return collections;
}

// Add Altpapier collections (monthly)
function generateAltpapierSchedule(): typeof schedule2025 {
  const collections: typeof schedule2025 = [];
  const areas = ['Lothe', 'Schwalenberg', 'Brakelsiek', 'Webbel', 'Glashütte/Siekholz'];
  
  const startDates: Record<string, string> = {
    'Lothe': '2025-01-14',
    'Schwalenberg': '2025-01-15',
    'Brakelsiek': '2025-01-16',
    'Webbel': '2025-01-17',
    'Glashütte/Siekholz': '2025-01-18'
  };
  
  for (const area of areas) {
    let currentDate = new Date(startDates[area]);
    const endDate = new Date('2025-12-31');
    
    while (currentDate <= endDate) {
      collections.push({
        area,
        date: currentDate.toISOString().split('T')[0],
        wasteTypes: ['Altpapiertonne']
      });
      
      // Add 28 days for next collection (roughly monthly)
      currentDate.setDate(currentDate.getDate() + 28);
    }
  }
  
  return collections;
}

// Add Gelbe Tonne collections (every 2 weeks)
function generateGelbeTonneSchedule(): typeof schedule2025 {
  const collections: typeof schedule2025 = [];
  const areas = ['Lothe', 'Schwalenberg', 'Brakelsiek', 'Webbel', 'Glashütte/Siekholz'];
  
  const startDates: Record<string, string> = {
    'Lothe': '2025-01-22',
    'Schwalenberg': '2025-01-23',
    'Brakelsiek': '2025-01-24',
    'Webbel': '2025-01-25',
    'Glashütte/Siekholz': '2025-01-26'
  };
  
  for (const area of areas) {
    let currentDate = new Date(startDates[area]);
    const endDate = new Date('2025-12-31');
    
    while (currentDate <= endDate) {
      collections.push({
        area,
        date: currentDate.toISOString().split('T')[0],
        wasteTypes: ['Gelbe Tonne']
      });
      
      // Add 14 days for next collection
      currentDate.setDate(currentDate.getDate() + 14);
    }
  }
  
  return collections;
}

async function importSchedule() {
  try {
    // Get tenant ID
    const tenantResult = await pool.query(
      `SELECT id FROM tenants WHERE slug = 'schieder' LIMIT 1`
    );
    
    if (tenantResult.rows.length === 0) {
      throw new Error('Schieder tenant not found');
    }
    
    const tenantId = tenantResult.rows[0].id;
    console.log(`Tenant: ${tenantId}`);
    
    // Get waste type IDs
    const wasteTypesResult = await pool.query(
      `SELECT id, name FROM waste_types`
    );
    
    const wasteTypeMap = new Map<string, number>();
    wasteTypesResult.rows.forEach(row => {
      wasteTypeMap.set(row.name, row.id);
    });
    
    console.log(`Waste types: ${wasteTypeMap.size}`);
    
    // Create areas
    const areas = ['Lothe', 'Schwalenberg', 'Brakelsiek', 'Webbel', 'Glashütte/Siekholz'];
    const areaMap = new Map<string, number>();
    
    for (const areaName of areas) {
      const result = await pool.query(
        `INSERT INTO waste_areas (tenant_id, name)
         VALUES ($1, $2)
         ON CONFLICT (tenant_id, name) DO UPDATE
         SET name = EXCLUDED.name
         RETURNING id`,
        [tenantId, areaName]
      );
      
      areaMap.set(areaName, result.rows[0].id);
      console.log(`  ✓ Area: ${areaName}`);
    }
    
    // Combine all schedules
    const allCollections = [
      ...schedule2025,
      ...generateRestmuellSchedule(),
      ...generateAltpapierSchedule(),
      ...generateGelbeTonneSchedule()
    ];
    
    console.log(`\nImporting ${allCollections.length} collection dates...`);
    
    // Import collections
    let imported = 0;
    let skipped = 0;
    
    for (const collection of allCollections) {
      const areaId = areaMap.get(collection.area);
      
      if (!areaId) {
        console.log(`  ⚠ Area not found: ${collection.area}`);
        skipped++;
        continue;
      }
      
      for (const wasteTypeName of collection.wasteTypes) {
        const wasteTypeId = wasteTypeMap.get(wasteTypeName);
        
        if (!wasteTypeId) {
          console.log(`  ⚠ Waste type not found: ${wasteTypeName}`);
          skipped++;
          continue;
        }
        
        try {
          await pool.query(
            `INSERT INTO waste_collections (tenant_id, area_id, waste_type_id, collection_date)
             VALUES ($1, $2, $3, $4)
             ON CONFLICT (tenant_id, area_id, waste_type_id, collection_date) DO NOTHING`,
            [tenantId, areaId, wasteTypeId, collection.date]
          );
          
          imported++;
        } catch (error: any) {
          console.error(`  ✗ Error importing ${collection.area} ${wasteTypeName} ${collection.date}:`, error.message);
          skipped++;
        }
      }
    }
    
    console.log(`\n✅ Imported: ${imported} collections`);
    console.log(`⚠ Skipped: ${skipped} collections`);
    console.log('Done!');
    
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

importSchedule();
