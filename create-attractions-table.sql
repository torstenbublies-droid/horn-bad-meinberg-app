-- Create attractions table for tourism/sightseeing data
CREATE TABLE IF NOT EXISTS attractions (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(255) NOT NULL,
  name VARCHAR(500) NOT NULL,
  description TEXT,
  category VARCHAR(255), -- e.g., "Sehenswürdigkeiten", "Parks", "Museen", etc.
  image_url TEXT,
  address TEXT,
  more_info_url TEXT, -- Link to "Mehr Infos" page
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_attractions_tenant ON attractions(tenant_id);
CREATE INDEX IF NOT EXISTS idx_attractions_category ON attractions(category);
CREATE INDEX IF NOT EXISTS idx_attractions_display_order ON attractions(display_order);

-- Add foreign key constraint to tenants table
ALTER TABLE attractions 
ADD CONSTRAINT fk_attractions_tenant 
FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE;

-- Verify table creation
SELECT 
  table_name, 
  column_name, 
  data_type, 
  character_maximum_length
FROM information_schema.columns
WHERE table_name = 'attractions'
ORDER BY ordinal_position;
