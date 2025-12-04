import axios from 'axios';
import * as cheerio from 'cheerio';
import { OpenAI } from 'openai';
import { getDb } from '../server/db';
import { websiteChunks, scrapingLog } from '../drizzle/schema';
import { nanoid } from 'nanoid';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

interface ScrapeConfig {
  tenantId: string;
  baseUrl: string;
  maxPages: number;
  chunkSize: number; // characters per chunk
  chunkOverlap: number; // overlap between chunks
}

/**
 * Extract clean text from HTML
 */
function extractTextFromHtml(html: string): string {
  const $ = cheerio.load(html);
  
  // Remove script, style, nav, footer
  $('script, style, nav, footer, .cookie-banner, .navigation, .menu').remove();
  
  // Get main content
  const mainContent = $('main, article, .content, #content').text() || $('body').text();
  
  // Clean up whitespace
  return mainContent
    .replace(/\s+/g, ' ')
    .replace(/\n+/g, '\n')
    .trim();
}

/**
 * Split text into overlapping chunks
 */
function chunkText(text: string, chunkSize: number, overlap: number): string[] {
  const chunks: string[] = [];
  let start = 0;
  
  while (start < text.length) {
    const end = Math.min(start + chunkSize, text.length);
    chunks.push(text.slice(start, end));
    start += chunkSize - overlap;
  }
  
  return chunks;
}

/**
 * Generate embedding for text using OpenAI
 */
async function generateEmbedding(text: string): Promise<number[]> {
  try {
    // Use gpt-4.1-mini for embeddings (Manus proxy)
    const response = await openai.embeddings.create({
      model: 'text-embedding-ada-002',
      input: text,
    });
    return response.data[0].embedding;
  } catch (error) {
    console.error('Error generating embedding:', error);
    throw error;
  }
}

/**
 * Scrape a single URL
 */
async function scrapePage(url: string, config: ScrapeConfig): Promise<number> {
  try {
    console.log(`Scraping: ${url}`);
    
    const response = await axios.get(url, {
      timeout: 10000,
      headers: {
        'User-Agent': 'Mozilla/5.0 (compatible; BuergerApp-Scraper/1.0)',
      },
    });
    
    const html = response.data;
    const $ = cheerio.load(html);
    const title = $('title').text() || $('h1').first().text() || 'Untitled';
    const text = extractTextFromHtml(html);
    
    if (text.length < 100) {
      console.log(`Skipping ${url} - too little content`);
      return 0;
    }
    
    // Split into chunks
    const chunks = chunkText(text, config.chunkSize, config.chunkOverlap);
    console.log(`  → ${chunks.length} chunks created`);
    
    // Generate embeddings and store
    let storedCount = 0;
    for (let i = 0; i < chunks.length; i++) {
      const chunk = chunks[i];
      console.log(`  → Generating embedding for chunk ${i + 1}/${chunks.length}`);
      
      const embedding = await generateEmbedding(chunk);
      
      const db = await getDb();
      await db.insert(websiteChunks).values({
        id: nanoid(),
        tenantId: config.tenantId,
        url,
        title,
        content: chunk,
        chunkIndex: i,
        embedding: JSON.stringify(embedding),
        metadata: JSON.stringify({
          scrapedAt: new Date().toISOString(),
          chunkLength: chunk.length,
        }),
      });
      
      storedCount++;
    }
    
    return storedCount;
  } catch (error: any) {
    console.error(`Error scraping ${url}:`, error.message);
    throw error;
  }
}

/**
 * Discover URLs from a base URL
 */
async function discoverUrls(baseUrl: string, maxPages: number): Promise<string[]> {
  const visited = new Set<string>();
  const toVisit = [baseUrl];
  const discovered: string[] = [];
  
  while (toVisit.length > 0 && discovered.length < maxPages) {
    const url = toVisit.shift()!;
    
    if (visited.has(url)) continue;
    visited.add(url);
    
    try {
      const response = await axios.get(url, {
        timeout: 10000,
        headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; BuergerApp-Scraper/1.0)',
        },
      });
      
      const $ = cheerio.load(response.data);
      discovered.push(url);
      
      // Find internal links
      $('a[href]').each((_, el) => {
        const href = $(el).attr('href');
        if (!href) return;
        
        let absoluteUrl: string;
        try {
          absoluteUrl = new URL(href, baseUrl).toString();
        } catch {
          return;
        }
        
        // Only internal links
        if (absoluteUrl.startsWith(baseUrl) && !visited.has(absoluteUrl)) {
          toVisit.push(absoluteUrl);
        }
      });
    } catch (error) {
      console.error(`Error discovering URLs from ${url}:`, error);
    }
  }
  
  return discovered;
}

/**
 * Main scraping function
 */
async function scrapeWebsite(config: ScrapeConfig) {
  console.log('=== Starting website scraping ===');
  console.log(`Tenant: ${config.tenantId}`);
  console.log(`Base URL: ${config.baseUrl}`);
  console.log(`Max pages: ${config.maxPages}`);
  console.log('');
  
  // Discover URLs
  console.log('Discovering URLs...');
  const urls = await discoverUrls(config.baseUrl, config.maxPages);
  console.log(`Found ${urls.length} URLs to scrape`);
  console.log('');
  
  // Scrape each URL
  let totalChunks = 0;
  for (const url of urls) {
    try {
      const chunksCreated = await scrapePage(url, config);
      totalChunks += chunksCreated;
      
      // Log success
      const db = await getDb();
      await db.insert(scrapingLog).values({
        id: nanoid(),
        tenantId: config.tenantId,
        url,
        status: 'success',
        chunksCreated,
      });
      
      // Rate limiting
      await new Promise(resolve => setTimeout(resolve, 1000));
    } catch (error: any) {
      // Log error
      const db = await getDb();
      await db.insert(scrapingLog).values({
        id: nanoid(),
        tenantId: config.tenantId,
        url,
        status: 'error',
        chunksCreated: 0,
        errorMessage: error.message,
      });
    }
  }
  
  console.log('');
  console.log('=== Scraping complete ===');
  console.log(`Total URLs: ${urls.length}`);
  console.log(`Total chunks: ${totalChunks}`);
}

// Run scraper
const config: ScrapeConfig = {
  tenantId: 'hornbadmeinberg',
  baseUrl: 'https://www.horn-badmeinberg.de/',
  maxPages: 50,
  chunkSize: 1000,
  chunkOverlap: 200,
};

scrapeWebsite(config)
  .then(() => {
    console.log('Done!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
