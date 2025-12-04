#!/usr/bin/env tsx

/**
 * Scrape news articles from Schieder-Schwalenberg website
 * Run: npx tsx scripts/scrape-schieder-news.ts
 */

import { chromium } from 'playwright';
import pkg from 'pg';
import * as fs from 'fs';
import * as path from 'path';
const { Pool } = pkg;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://buergerapp_user:buergerapp_dev_2025@localhost:5432/buergerapp'
});

interface Article {
  title: string;
  description: string;
  publishedDate: string;
  sourceUrl: string;
  category?: string;
}

async function scrapeNews(): Promise<Article[]> {
  console.log('Starting Schieder news scraper...');
  
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  
  try {
    const url = 'https://www.schieder-schwalenberg.de/Bürger-und-Service/Rathaus/Bekanntmachungen';
    console.log(`Loading ${url}...`);
    
    await page.goto(url, { 
      waitUntil: 'networkidle',
      timeout: 60000 
    });
    
    console.log('Page loaded successfully');
    
    // The browser tool automatically saves markdown, let's use that
    const markdownPath = '/home/ubuntu/page_texts/www.schieder-schwalenberg.de_Bürger-und-Service_Rathaus_Bekanntmachungen.md';
    
    let markdown = '';
    if (fs.existsSync(markdownPath)) {
      console.log('Using existing markdown file...');
      markdown = fs.readFileSync(markdownPath, 'utf-8');
    } else {
      console.log('Markdown file not found, extracting from page...');
      markdown = await page.content();
    }
    
    await browser.close();
    
    // Parse articles from markdown
    const articles: Article[] = [];
    const lines = markdown.split('\n');
    
    let currentDate = '';
    let currentTitle = '';
    let currentDescription = '';
    let inArticlesSection = false;
    
    for (let i = 0; i < lines.length && articles.length < 10; i++) {
      const line = lines[i].trim();
      
      // Skip empty lines
      if (!line) continue;
      
      // Start parsing after "Es wurden X Mitteilungen gefunden"
      if (line.includes('Mitteilungen gefunden')) {
        inArticlesSection = true;
        continue;
      }
      
      if (!inArticlesSection) continue;
      
      // Stop at pagination
      if (line.includes('Seite:')) break;
      
      // Check if line is a date (DD.MM.YYYY)
      if (/^\d{2}\.\d{2}\.\d{4}$/.test(line)) {
        // Save previous article
        if (currentDate && currentTitle) {
          articles.push({
            title: currentTitle,
            description: currentDescription || currentTitle,
            publishedDate: currentDate,
            sourceUrl: url,
            category: 'Bekanntmachung'
          });
        }
        
        currentDate = line;
        currentTitle = '';
        currentDescription = '';
      }
      // Title (usually after #### or just plain text)
      else if (currentDate && !currentTitle) {
        // Remove markdown formatting
        const cleanLine = line.replace(/^#+\s*/, '').replace(/\[Mehr\]\(\)/, '').trim();
        if (cleanLine.length > 10 && !cleanLine.includes('[mehr]')) {
          currentTitle = cleanLine;
        }
      }
      // Description
      else if (currentDate && currentTitle && !currentDescription) {
        const cleanLine = line.replace(/\[Mehr\]\(\)/, '').replace(/\[mehr\]\(\)/, '').trim();
        // Skip "Textanriss überspringen" and similar
        if (cleanLine.length > 20 && 
            !cleanLine.startsWith('**') && 
            !cleanLine.includes('Textanriss') &&
            !cleanLine.includes('überspringen')) {
          currentDescription = cleanLine;
        }
      }
    }
    
    // Add last article
    if (currentDate && currentTitle && articles.length < 10) {
      articles.push({
        title: currentTitle,
        description: currentDescription || currentTitle,
        publishedDate: currentDate,
        sourceUrl: url,
        category: 'Bekanntmachung'
      });
    }
    
    console.log(`Scraped ${articles.length} articles`);
    
    if (articles.length > 0) {
      console.log('Sample article:', articles[0]);
    }
    
    return articles;
    
  } catch (error) {
    console.error('Scraping error:', error);
    await browser.close();
    throw error;
  }
}

async function saveArticles(articles: Article[], tenantId: string) {
  console.log(`Saving ${articles.length} articles to database...`);
  
  let saved = 0;
  let updated = 0;
  
  for (const article of articles) {
    try {
      // Convert German date format (DD.MM.YYYY) to ISO format (YYYY-MM-DD)
      const [day, month, year] = article.publishedDate.split('.');
      const isoDate = `${year}-${month}-${day}`;
      
      // Generate unique source URL
      const slug = article.title.toLowerCase()
        .replace(/[^a-z0-9]+/g, '-')
        .replace(/^-|-$/g, '')
        .substring(0, 50);
      const uniqueUrl = `${article.sourceUrl}#${article.publishedDate}-${slug}`;
      
      const result = await pool.query(
        `INSERT INTO news_articles (tenant_id, title, description, published_date, source_url, category)
         VALUES ($1, $2, $3, $4, $5, $6)
         ON CONFLICT (tenant_id, source_url) DO UPDATE
         SET title = EXCLUDED.title,
             description = EXCLUDED.description,
             published_date = EXCLUDED.published_date,
             category = EXCLUDED.category,
             updated_at = CURRENT_TIMESTAMP
         RETURNING (xmax = 0) AS inserted`,
        [tenantId, article.title, article.description, isoDate, uniqueUrl, article.category]
      );
      
      if (result.rows[0].inserted) {
        saved++;
        console.log(`  ✓ ${article.title.substring(0, 60)}...`);
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
    
    const articles = await scrapeNews();
    
    if (articles.length === 0) {
      console.log('No articles found');
      return;
    }
    
    await saveArticles(articles, tenantId);
    console.log('Done!');
    
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

main();
