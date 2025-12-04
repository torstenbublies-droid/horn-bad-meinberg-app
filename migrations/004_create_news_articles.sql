-- Migration: Create news_articles table for scraped articles
-- Created: 2025-11-23

CREATE TABLE IF NOT EXISTS news_articles (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(64) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  title VARCHAR(500) NOT NULL,
  description TEXT,
  content TEXT,
  published_date DATE NOT NULL,
  source_url VARCHAR(1000),
  image_url VARCHAR(1000),
  category VARCHAR(100),
  scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, source_url)
);

-- Index for faster queries
CREATE INDEX idx_news_articles_tenant_id ON news_articles(tenant_id);
CREATE INDEX idx_news_articles_published_date ON news_articles(published_date DESC);
CREATE INDEX idx_news_articles_tenant_date ON news_articles(tenant_id, published_date DESC);

-- Comments
COMMENT ON TABLE news_articles IS 'Scraped news articles from tenant websites';
COMMENT ON COLUMN news_articles.tenant_id IS 'Reference to tenant';
COMMENT ON COLUMN news_articles.title IS 'Article title';
COMMENT ON COLUMN news_articles.description IS 'Short description/excerpt';
COMMENT ON COLUMN news_articles.content IS 'Full article content (if available)';
COMMENT ON COLUMN news_articles.published_date IS 'Original publication date from source';
COMMENT ON COLUMN news_articles.source_url IS 'URL to original article';
COMMENT ON COLUMN news_articles.image_url IS 'URL to article image (if available)';
COMMENT ON COLUMN news_articles.category IS 'Article category (e.g., Bekanntmachung, Ausschreibung)';
COMMENT ON COLUMN news_articles.scraped_at IS 'When the article was first scraped';
COMMENT ON COLUMN news_articles.updated_at IS 'Last update timestamp';
