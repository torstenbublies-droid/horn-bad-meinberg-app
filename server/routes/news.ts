import { Router } from 'express';
import { getDb } from '../db';
import { sql } from 'drizzle-orm';

const router = Router();

/**
 * GET /api/news?tenant=hornbadmeinberg
 * Get news articles for a specific tenant
 */
router.get('/', async (req, res) => {
  try {
    const tenantSlug = req.query.tenant as string;
    
    if (!tenantSlug) {
      return res.status(400).json({ error: 'Tenant parameter is required' });
    }
    
    const db = await getDb();
    if (!db) {
      return res.status(500).json({ error: 'Database not available' });
    }
    
    // Get news articles for this tenant using raw SQL
    const result = await db.execute(sql`
      SELECT id, title, teaser as description, published_at as published_date, 
             source_url, category, created_at as scraped_at, image_url
      FROM news
      WHERE tenant_id = ${tenantSlug}
      ORDER BY published_at DESC
      LIMIT 20
    `);
    
    res.json({
      articles: result.rows
    });
    
  } catch (error) {
    console.error('Error fetching news:', error);
    res.status(500).json({ error: 'Failed to fetch news articles' });
  }
});

export default router;
