import pkg from 'pg';
const { Pool } = pkg;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://buergerapp_user:buergerapp_dev_2025@localhost:5432/buergerapp'
});

async function importNovemberDecember() {
  try {
    // Get tenant ID
    const tenantResult = await pool.query(`SELECT id FROM tenants WHERE slug = 'schieder' LIMIT 1`);
    const tenantId = tenantResult.rows[0].id;
    
    // Get area IDs
    const areasResult = await pool.query(`SELECT id, name FROM waste_areas WHERE tenant_id = $1`, [tenantId]);
    const areas: Record<string, number> = {};
    areasResult.rows.forEach((row: any) => {
      areas[row.name] = row.id;
    });
    
    // Get waste type IDs
    const typesResult = await pool.query(`SELECT id, name FROM waste_types`);
    const types: Record<string, number> = {};
    typesResult.rows.forEach((row: any) => {
      types[row.name] = row.id;
    });
    
    // November 2025 data (from PDF calendar)
    const novemberData = [
      // Week 1
      { date: '2025-11-04', area: 'Lothe', type: 'Restmüll' },
      { date: '2025-11-07', area: 'Schwalenberg', type: 'Biotonne' },
      { date: '2025-11-11', area: 'Lothe', type: 'Biotonne' },
      { date: '2025-11-11', area: 'Webbel', type: 'Biotonne' },
      { date: '2025-11-15', area: 'Brakelsiek', type: 'Biotonne' },
      { date: '2025-11-18', area: 'Lothe', type: 'Restmüll' },
      { date: '2025-11-18', area: 'Glashütte/Siekholz', type: 'Biotonne' },
      { date: '2025-11-22', area: 'Webbel', type: 'Biotonne' },
      { date: '2025-11-25', area: 'Lothe', type: 'Biotonne' },
      { date: '2025-11-25', area: 'Brakelsiek', type: 'Biotonne' },
      { date: '2025-11-29', area: 'Glashütte/Siekholz', type: 'Biotonne' },
      
      // Papier (Altpapier) - November
      { date: '2025-11-04', area: 'Lothe', type: 'Papier' },
      { date: '2025-11-18', area: 'Lothe', type: 'Papier' },
      
      // Gelbe Tonne - November
      { date: '2025-11-03', area: 'Lothe', type: 'Gelbe Tonne' },
      { date: '2025-11-10', area: 'Lothe', type: 'Gelbe Tonne' },
      { date: '2025-11-17', area: 'Lothe', type: 'Gelbe Tonne' },
      { date: '2025-11-24', area: 'Lothe', type: 'Gelbe Tonne' },
    ];
    
    // December 2025 data
    const decemberData = [
      { date: '2025-12-02', area: 'Lothe', type: 'Restmüll' },
      { date: '2025-12-09', area: 'Lothe', type: 'Biotonne' },
      { date: '2025-12-16', area: 'Lothe', type: 'Restmüll' },
      { date: '2025-12-22', area: 'Webbel', type: 'Biotonne' },
      { date: '2025-12-22', area: 'Lothe', type: 'Biotonne' },
      { date: '2025-12-30', area: 'Lothe', type: 'Restmüll' },
      
      // Other areas
      { date: '2025-12-07', area: 'Schwalenberg', type: 'Biotonne' },
      { date: '2025-12-15', area: 'Brakelsiek', type: 'Biotonne' },
      { date: '2025-12-18', area: 'Glashütte/Siekholz', type: 'Biotonne' },
      
      // Gelbe Tonne - December
      { date: '2025-12-01', area: 'Lothe', type: 'Gelbe Tonne' },
      { date: '2025-12-08', area: 'Lothe', type: 'Gelbe Tonne' },
      { date: '2025-12-15', area: 'Lothe', type: 'Gelbe Tonne' },
      { date: '2025-12-22', area: 'Lothe', type: 'Gelbe Tonne' },
      { date: '2025-12-29', area: 'Lothe', type: 'Gelbe Tonne' },
    ];
    
    const allData = [...novemberData, ...decemberData];
    
    let inserted = 0;
    let skipped = 0;
    
    for (const entry of allData) {
      const areaId = areas[entry.area];
      const typeId = types[entry.type];
      
      if (!areaId || !typeId) {
        console.log(`Skipping ${entry.date} ${entry.area} ${entry.type} - area or type not found`);
        skipped++;
        continue;
      }
      
      try {
        await pool.query(
          `INSERT INTO waste_collections (tenant_id, area_id, waste_type_id, collection_date)
           VALUES ($1, $2, $3, $4)
           ON CONFLICT (tenant_id, area_id, waste_type_id, collection_date) DO NOTHING`,
          [tenantId, areaId, typeId, entry.date]
        );
        inserted++;
      } catch (err) {
        console.error(`Error inserting ${entry.date} ${entry.area} ${entry.type}:`, err);
        skipped++;
      }
    }
    
    console.log(`✅ Import complete: ${inserted} inserted, ${skipped} skipped`);
    
  } catch (error) {
    console.error('Error importing November/December data:', error);
  } finally {
    await pool.end();
  }
}

importNovemberDecember();
