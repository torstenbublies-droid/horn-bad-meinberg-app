import { Pool } from 'pg';
import * as fs from 'fs';
import * as path from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://buergerapp_user:buergerapp_dev_2025@localhost:5432/buergerapp'
});

interface WasteSchedule {
  gemeinsame_tonnen: {
    restmuell_grau: string[];
    altpapier_blau: string[];
    gelber_sack: string[];
    biotonne_gruen: string[];
  };
  gruenschnitt_ortsteile: {
    [ortsteil: string]: string[];
  };
}

async function importWasteSchedule() {
  try {
    console.log('🗑️ Importing waste schedule for November-December 2025...');
    
    // Load JSON file
    const jsonPath = path.join(__dirname, '..', 'waste_schedule_nov_dec_2025.json');
    const jsonData = fs.readFileSync(jsonPath, 'utf-8');
    const schedule: WasteSchedule = JSON.parse(jsonData);
    
    // Get tenant ID
    const tenantResult = await pool.query(
      `SELECT id FROM tenants WHERE slug = $1 LIMIT 1`,
      ['schieder']
    );
    
    if (tenantResult.rows.length === 0) {
      throw new Error('Tenant "schieder" not found');
    }
    
    const tenantId = tenantResult.rows[0].id;
    console.log(`✅ Found tenant: ${tenantId}`);
    
    // Get all areas
    const areasResult = await pool.query(
      `SELECT id, name FROM waste_areas WHERE tenant_id = $1`,
      [tenantId]
    );
    
    const areas = areasResult.rows;
    console.log(`✅ Found ${areas.length} areas`);
    
    // Get waste types
    const wasteTypesResult = await pool.query(
      `SELECT id, name FROM waste_types`
    );
    
    const wasteTypes: { [name: string]: number } = {};
    for (const row of wasteTypesResult.rows) {
      wasteTypes[row.name] = row.id;
    }
    
    console.log(`✅ Found waste types:`, Object.keys(wasteTypes));
    
    let insertCount = 0;
    
    // Import gemeinsame Tonnen (for ALL areas)
    console.log('\n📦 Importing gemeinsame Tonnen (for all areas)...');
    
    for (const area of areas) {
      // Restmüll (grau)
      for (const date of schedule.gemeinsame_tonnen.restmuell_grau) {
        await pool.query(
          `INSERT INTO waste_collections (tenant_id, area_id, waste_type_id, collection_date)
           VALUES ($1, $2, $3, $4)`,
          [tenantId, area.id, wasteTypes['Restmülltonne'], date]
        );
        insertCount++;
      }
      
      // Altpapier (blau)
      for (const date of schedule.gemeinsame_tonnen.altpapier_blau) {
        await pool.query(
          `INSERT INTO waste_collections (tenant_id, area_id, waste_type_id, collection_date)
           VALUES ($1, $2, $3, $4)`,
          [tenantId, area.id, wasteTypes['Altpapiertonne'], date]
        );
        insertCount++;
      }
      
      // Gelber Sack
      for (const date of schedule.gemeinsame_tonnen.gelber_sack) {
        await pool.query(
          `INSERT INTO waste_collections (tenant_id, area_id, waste_type_id, collection_date)
           VALUES ($1, $2, $3, $4)`,
          [tenantId, area.id, wasteTypes['Gelbe Tonne'], date]
        );
        insertCount++;
      }
      
      // Biotonne (grün)
      for (const date of schedule.gemeinsame_tonnen.biotonne_gruen) {
        await pool.query(
          `INSERT INTO waste_collections (tenant_id, area_id, waste_type_id, collection_date)
           VALUES ($1, $2, $3, $4)`,
          [tenantId, area.id, wasteTypes['Biotonne'], date]
        );
        insertCount++;
      }
    }
    
    console.log(`✅ Imported ${insertCount} gemeinsame Tonnen entries`);
    
    // Import Grünschnitt (area-specific)
    console.log('\n🌿 Importing Grünschnitt (area-specific)...');
    
    let gruenschnittCount = 0;
    for (const [ortsteilName, dates] of Object.entries(schedule.gruenschnitt_ortsteile)) {
      const area = areas.find(a => a.name === ortsteilName);
      if (!area) {
        console.warn(`⚠️  Area "${ortsteilName}" not found, skipping...`);
        continue;
      }
      
      if (dates.length === 0) {
        console.log(`  ℹ️  ${ortsteilName}: No Grünschnitt dates`);
        continue;
      }
      
      for (const date of dates) {
        await pool.query(
          `INSERT INTO waste_collections (tenant_id, area_id, waste_type_id, collection_date)
           VALUES ($1, $2, $3, $4)`,
          [tenantId, area.id, wasteTypes['Saisonbiotonne'], date]
        );
        gruenschnittCount++;
      }
      
      console.log(`  ✅ ${ortsteilName}: ${dates.length} Grünschnitt dates`);
    }
    
    console.log(`✅ Imported ${gruenschnittCount} Grünschnitt entries`);
    console.log(`\n🎉 Total: ${insertCount + gruenschnittCount} waste collection entries imported!`);
    
  } catch (error) {
    console.error('❌ Error importing waste schedule:', error);
    throw error;
  } finally {
    await pool.end();
  }
}

importWasteSchedule();
