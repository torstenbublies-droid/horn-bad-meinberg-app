-- Migration: Create events table for storing scraped event data
-- Created: 2025-11-23

CREATE TABLE IF NOT EXISTS events (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(64) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  title VARCHAR(500) NOT NULL,
  description TEXT,
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP,
  location VARCHAR(255),
  image_url TEXT,
  source_url TEXT NOT NULL,
  category VARCHAR(100),
  scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, source_url)
);

-- Index for faster queries by tenant and date
CREATE INDEX IF NOT EXISTS idx_events_tenant_date ON events(tenant_id, start_date DESC);

-- Index for filtering by location
CREATE INDEX IF NOT EXISTS idx_events_location ON events(tenant_id, location);

-- Index for date range queries
CREATE INDEX IF NOT EXISTS idx_events_date_range ON events(start_date, end_date);

COMMENT ON TABLE events IS 'Stores event data scraped from tenant websites';
COMMENT ON COLUMN events.tenant_id IS 'Reference to the tenant this event belongs to';
COMMENT ON COLUMN events.start_date IS 'Event start date and time';
COMMENT ON COLUMN events.end_date IS 'Event end date and time (optional for single-day events)';
COMMENT ON COLUMN events.source_url IS 'Original URL of the event (used for deduplication)';
