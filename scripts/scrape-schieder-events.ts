#!/usr/bin/env tsx

/**
 * Scrape events from Schieder-Schwalenberg website
 * Run: npx tsx scripts/scrape-schieder-events.ts
 */

import { chromium } from 'playwright';
import pkg from 'pg';
const { Pool } = pkg;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://buergerapp_user:buergerapp_dev_2025@localhost:5432/buergerapp'
});

interface Event {
  title: string;
  description: string;
  startDate: string;
  endDate?: string;
  location?: string;
  imageUrl?: string;
  sourceUrl: string;
  category?: string;
}

function parseGermanDateTime(dateStr: string, timeStr?: string): string {
  // Parse German date format: "DD.MM.YYYY" or "DD.MM.YYYY / HH:MM"
  const dateParts = dateStr.split('.');
  if (dateParts.length !== 3) {
    throw new Error(`Invalid date format: ${dateStr}`);
  }
  
  const day = dateParts[0].trim();
  const month = dateParts[1].trim();
  const year = dateParts[2].trim();
  
  let hours = '00';
  let minutes = '00';
  
  if (timeStr) {
    const timeParts = timeStr.split(':');
    if (timeParts.length >= 2) {
      hours = timeParts[0].trim().padStart(2, '0');
      minutes = timeParts[1].trim().padStart(2, '0');
    }
  }
  
  // Return ISO format: YYYY-MM-DD HH:MM:SS
  return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')} ${hours}:${minutes}:00`;
}

async function scrapeEvents(): Promise<Event[]> {
  console.log('Starting Schieder events scraper...');
  
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  
  try {
    const url = 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender';
    console.log(`Loading ${url}...`);
    
    await page.goto(url, { 
      waitUntil: 'networkidle',
      timeout: 60000 
    });
    
    console.log('Page loaded successfully');
    
    // Wait for events to load
    await page.waitForSelector('text=Veranstaltungen gefunden', { timeout: 10000 }).catch(() => {
      console.log('Could not find "Veranstaltungen gefunden" text');
    });
    
    // Extract events from the page
    const events = await page.evaluate(() => {
      const eventElements = document.querySelectorAll('.veranstaltung, .event-item, [class*="veranst"]');
      const results: any[] = [];
      
      // If no specific class found, try to find all event containers
      if (eventElements.length === 0) {
        // Look for date patterns in the page
        const allText = document.body.innerText;
        const datePattern = /(\d{2}\.\d{2}\.\d{4})\s*(?:BIS\s*(\d{2}\.\d{2}\.\d{4}))?\s*\/\s*(\d{2}:\d{2})\s*(?:BIS\s*(\d{2}:\d{2}))?\s*UHR\s*([^\n]+)/g;
        
        let match;
        while ((match = datePattern.exec(allText)) && results.length < 10) {
          results.push({
            dateStr: match[1],
            endDateStr: match[2] || null,
            startTime: match[3],
            endTime: match[4] || null,
            title: match[5].trim()
          });
        }
      }
      
      return results;
    });
    
    await browser.close();
    
    if (events.length === 0) {
      console.log('No events found with JavaScript extraction, trying markdown...');
      // Fallback to markdown parsing
      return await parseEventsFromMarkdown();
    }
    
    console.log(`Found ${events.length} events via JavaScript`);
    
    // Convert to Event objects
    const parsedEvents: Event[] = events.slice(0, 10).map((e: any) => {
      const startDate = parseGermanDateTime(e.dateStr, e.startTime);
      const endDate = e.endDateStr ? parseGermanDateTime(e.endDateStr, e.endTime) : undefined;
      
      return {
        title: e.title,
        description: e.title,
        startDate,
        endDate,
        location: '',
        sourceUrl: url,
        category: 'Veranstaltung'
      };
    });
    
    return parsedEvents;
    
  } catch (error) {
    console.error('Scraping error:', error);
    await browser.close();
    
    // Fallback to markdown parsing
    return await parseEventsFromMarkdown();
  }
}

async function parseEventsFromMarkdown(): Promise<Event[]> {
  const fs = await import('fs');
  const markdownPath = '/home/ubuntu/page_texts/www.schieder-schwalenberg.de_Tourismus_Tourismus-und-Freizeit_Service_Veranstaltungskalender.md';
  
  if (!fs.existsSync(markdownPath)) {
    console.log('Markdown file not found');
    return [];
  }
  
  const markdown = fs.readFileSync(markdownPath, 'utf-8');
  const events: Event[] = [];
  
  // Parse events from markdown
  // Pattern: DD.MM.YYYY [BIS DD.MM.YYYY] / HH:MM BIS HH:MM UHR Title
  const eventPattern = /(\d{2}\.\d{2}\.\d{4})\s*(?:BIS\s*(\d{2}\.\d{2}\.\d{4}))?\s*\/\s*(\d{2}:\d{2})\s*(?:BIS\s*(\d{2}:\d{2}))?\s*UHR\s*([^\n]+)/g;
  
  let match;
  while ((match = eventPattern.exec(markdown)) && events.length < 10) {
    const startDateStr = match[1];
    const endDateStr = match[2];
    const startTime = match[3];
    const endTime = match[4];
    const title = match[5].trim();
    
    try {
      const startDate = parseGermanDateTime(startDateStr, startTime);
      const endDate = endDateStr ? parseGermanDateTime(endDateStr, endTime || startTime) : undefined;
      
      // Try to find location in the next lines
      const titleIndex = markdown.indexOf(match[0]);
      const nextLines = markdown.substring(titleIndex, titleIndex + 200);
      const locationMatch = nextLines.match(/📍\s*([^\n]+)/);
      const location = locationMatch ? locationMatch[1].trim() : undefined;
      
      events.push({
        title,
        description: title,
        startDate,
        endDate,
        location,
        sourceUrl: 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender',
        category: 'Veranstaltung'
      });
    } catch (error) {
      console.error(`Error parsing event: ${title}`, error);
    }
  }
  
  console.log(`Parsed ${events.length} events from markdown`);
  return events;
}

async function saveEvents(events: Event[], tenantId: string) {
  console.log(`Saving ${events.length} events to database...`);
  
  let saved = 0;
  let updated = 0;
  
  for (const event of events) {
    try {
      // Generate unique source URL
      const slug = event.title.toLowerCase()
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/^-|-$/g, '')
        .substring(0, 50);
      const uniqueUrl = `${event.sourceUrl}#${event.startDate}-${slug}`;
      
      const result = await pool.query(
        `INSERT INTO events (tenant_id, title, description, start_date, end_date, location, source_url, category)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
         ON CONFLICT (tenant_id, source_url) DO UPDATE
         SET title = EXCLUDED.title,
             description = EXCLUDED.description,
             start_date = EXCLUDED.start_date,
             end_date = EXCLUDED.end_date,
             location = EXCLUDED.location,
             category = EXCLUDED.category,
             updated_at = CURRENT_TIMESTAMP
         RETURNING (xmax = 0) AS inserted`,
        [tenantId, event.title, event.description, event.startDate, event.endDate, event.location, uniqueUrl, event.category]
      );
      
      if (result.rows[0].inserted) {
        saved++;
        console.log(`  ✓ ${event.title.substring(0, 60)}...`);
      } else {
        updated++;
      }
    } catch (error: any) {
      console.error(`  ✗ Error: ${error.message}`);
    }
  }
  
  console.log(`✅ Saved: ${saved} new, ${updated} updated`);
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
    
    const events = await scrapeEvents();
    
    if (events.length === 0) {
      console.log('No events found');
      return;
    }
    
    await saveEvents(events, tenantId);
    console.log('Done!');
    
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

main();
