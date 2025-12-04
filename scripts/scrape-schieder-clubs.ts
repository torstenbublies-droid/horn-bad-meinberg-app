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

interface Club {
  name: string;
  category: string;
  contactPerson: string;
  address: string;
  phone: string;
  fax: string;
  email: string;
  website: string;
}

// Category icon and color mapping
const categoryMapping: Record<string, { icon: string; color: string }> = {
  'Sportvereine': { icon: 'Trophy', color: 'blue' },
  'Chöre und Musikvereine': { icon: 'Music', color: 'purple' },
  'Schützenvereine und -gesellschaften': { icon: 'Shield', color: 'red' },
  'Heimat- und Verkehrsvereine': { icon: 'Home', color: 'green' },
  'Fördervereine - allgemein; Bürgerstiftung': { icon: 'Heart', color: 'pink' },
  'Angelclubs / Angelsportvereine': { icon: 'Fish', color: 'cyan' },
  'Auto-Club / Sonstige Vereine': { icon: 'Car', color: 'gray' },
  'Brauchtumspflege, Kunst und Kultur': { icon: 'Palette', color: 'violet' },
  'Kirchengemeinden / Pfadfinderschaft': { icon: 'Church', color: 'slate' },
  'Allgemein': { icon: 'Users', color: 'gray' },
};

// Only scrape the most important categories for the frontend
const websiteCategories: Record<string, string> = {
  '1882.3': 'Sportvereine',
  '1882.17': 'Angelclubs / Angelsportvereine',
  '1882.14': 'Kirchengemeinden / Pfadfinderschaft',
  '1882.18': 'Auto-Club / Sonstige Vereine',
  '1882.11': 'Brauchtumspflege, Kunst und Kultur',
  '1882.2': 'Chöre und Musikvereine',
  '1882.4': 'Schützenvereine und -gesellschaften',
  '1882.5': 'Heimat- und Verkehrsvereine',
};

function parseClubsFromPage($: cheerio.CheerioAPI, category: string): Club[] {
  const clubs: Club[] = [];
  
  $('.liste_text').each((i, elem) => {
    try {
      const $elem = $(elem);
      
      const $parent = $elem.parent();
      const nameLink = $parent.find('.liste_titel a').first();
      const name = nameLink.text().trim();
      
      if (!name) return;
      
      const leftText = $elem.find('.adressen_links').text().trim();
      const rightText = $elem.find('.adressen_rechts').text().trim();
      
      const allText = leftText + '\n' + rightText;
      const lines = allText.split('\n').map(l => l.trim()).filter(l => l);
      
      let contactPerson = '';
      let address = '';
      let phone = '';
      let fax = '';
      let email = '';
      let website = '';
      
      const addressParts: string[] = [];
      
      for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        
        if (!line || line.includes('Karte anzeigen') || line.includes('exportieren')) {
          continue;
        }
        
        if (!contactPerson && !line.match(/\d{5}/) && !line.match(/straße|weg|platz|postfach/i) && !line.match(/^\d{4,5}\s*\//) && line.length > 2) {
          contactPerson = line;
          continue;
        }
        
        if (line.match(/straße|weg|platz|allee|ring|pfad|gasse|damm|berg|feld|born|tal|postfach/i)) {
          addressParts.push(line);
          continue;
        }
        
        if (line.match(/^\d{5}\s+/)) {
          addressParts.push(line);
          continue;
        }
        
        if (line.match(/^\d{4,5}\s*\/\s*\d+/)) {
          if (!phone) {
            phone = line;
          } else if (!fax) {
            fax = line;
          }
        }
      }
      
      address = addressParts.join(', ');
      
      $elem.find('a').each((j, link) => {
        const href = $(link).attr('href') || '';
        const text = $(link).text().trim();
        
        if (href.includes('mailto:')) {
          email = href.replace('mailto:', '').split('?')[0];
        } else if (text.startsWith('www.') || (text.includes('.') && !text.includes(' '))) {
          website = text;
        }
      });
      
      clubs.push({
        name,
        category,
        contactPerson,
        address,
        phone,
        fax,
        email,
        website
      });
      
    } catch (err) {
      console.error('Error parsing club:', err);
    }
  });
  
  return clubs;
}

async function scrapeClubs() {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  
  const allClubs: Club[] = [];
  
  console.log('Loading Vereine page...');
  await page.goto('https://www.schieder-schwalenberg.de/Familie-und-Soziales/Sport-und-Freizeitstätten/Vereine', {
    waitUntil: 'networkidle',
    timeout: 60000
  });
  
  try {
    await page.click('#cookie-note-accept', { timeout: 2000 });
    await page.waitForTimeout(1000);
  } catch (err) {
    // Cookie banner not found
  }
  
  for (const [categoryKey, categoryName] of Object.entries(websiteCategories)) {
    console.log(`\n=== Scraping category: ${categoryName} ===`);
    
    try {
      await page.selectOption('#kategorie', categoryKey);
      await page.waitForTimeout(1500);
      
      await page.click('input[type="submit"][value="Anzeigen"]');
      await page.waitForTimeout(3000);
      
      let currentPage = 1;
      let hasMorePages = true;
      
      while (hasMorePages && currentPage <= 5) {
        console.log(`  Page ${currentPage}...`);
        
        const content = await page.content();
        const $ = cheerio.load(content);
        
        const clubs = parseClubsFromPage($, categoryName);
        console.log(`  Found ${clubs.length} clubs`);
        
        allClubs.push(...clubs);
        
        try {
          const nextPageLink = await page.$(`a:has-text("${currentPage + 1}")`);
          if (nextPageLink) {
            await page.click(`a:has-text("${currentPage + 1}")`);
            await page.waitForTimeout(3000);
            currentPage++;
          } else {
            hasMorePages = false;
          }
        } catch (err) {
          hasMorePages = false;
        }
      }
    } catch (err) {
      console.error(`Error scraping category ${categoryName}:`, err);
    }
  }
  
  await browser.close();
  
  console.log(`\n=== Total scraped: ${allClubs.length} clubs ===`);
  return allClubs;
}

async function saveToDatabase(clubs: Club[]) {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    const tenantResult = await client.query(
      'SELECT id FROM tenants WHERE slug = $1',
      ['schieder']
    );
    
    if (tenantResult.rows.length === 0) {
      throw new Error('Tenant "schieder" not found');
    }
    
    const tenantId = tenantResult.rows[0].id;
    
    await client.query('DELETE FROM clubs WHERE tenant_id = $1', [tenantId]);
    console.log('\nDeleted existing clubs');
    
    const categories = new Set(clubs.map(c => c.category));
    const categoryIds: Record<string, number> = {};
    
    let displayOrder = 0;
    for (const categoryName of categories) {
      const mapping = categoryMapping[categoryName] || { icon: 'Users', color: 'gray' };
      
      const result = await client.query(
        `INSERT INTO club_categories (tenant_id, name, icon, color, display_order)
         VALUES ($1, $2, $3, $4, $5)
         ON CONFLICT (tenant_id, name) DO UPDATE
         SET icon = EXCLUDED.icon, color = EXCLUDED.color, display_order = EXCLUDED.display_order
         RETURNING id`,
        [tenantId, categoryName, mapping.icon, mapping.color, displayOrder++]
      );
      
      categoryIds[categoryName] = result.rows[0].id;
    }
    
    console.log(`Created ${categories.size} categories`);
    
    let insertedCount = 0;
    let skippedCount = 0;
    
    for (const club of clubs) {
      const categoryId = categoryIds[club.category];
      
      try {
        await client.query(
          `INSERT INTO clubs (tenant_id, category_id, name, contact_person, address, phone, fax, email, website)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
           ON CONFLICT (tenant_id, name) DO UPDATE
           SET category_id = EXCLUDED.category_id,
               contact_person = EXCLUDED.contact_person,
               address = EXCLUDED.address,
               phone = EXCLUDED.phone,
               fax = EXCLUDED.fax,
               email = EXCLUDED.email,
               website = EXCLUDED.website,
               updated_at = CURRENT_TIMESTAMP`,
          [tenantId, categoryId, club.name, club.contactPerson, club.address, club.phone, club.fax, club.email, club.website]
        );
        insertedCount++;
        console.log(`✓ ${club.name} (${club.category})`);
      } catch (err) {
        console.log(`✗ Skipped ${club.name}: ${err}`);
        skippedCount++;
      }
    }
    
    await client.query('COMMIT');
    console.log(`\nImported ${insertedCount} clubs, skipped ${skippedCount}`);
    
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
    const clubs = await scrapeClubs();
    await saveToDatabase(clubs);
    console.log('Done!');
  } catch (err) {
    console.error('Error:', err);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

main();
