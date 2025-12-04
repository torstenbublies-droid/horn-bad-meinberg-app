-- Migration: Create waste collection tables
-- Created: 2025-11-23

-- Waste collection areas (Ortsteile/Straßen)
CREATE TABLE IF NOT EXISTS waste_areas (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(64) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, name)
);

-- Waste types
CREATE TABLE IF NOT EXISTS waste_types (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  color VARCHAR(50) NOT NULL,
  icon VARCHAR(50),
  description TEXT,
  UNIQUE(name)
);

-- Waste collection schedule
CREATE TABLE IF NOT EXISTS waste_collections (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(64) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  area_id INTEGER NOT NULL REFERENCES waste_areas(id) ON DELETE CASCADE,
  waste_type_id INTEGER NOT NULL REFERENCES waste_types(id) ON DELETE CASCADE,
  collection_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, area_id, waste_type_id, collection_date)
);

-- User waste preferences (stored per user/device)
CREATE TABLE IF NOT EXISTS user_waste_preferences (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(64) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  user_id VARCHAR(255) NOT NULL, -- Can be device ID or user email
  area_id INTEGER NOT NULL REFERENCES waste_areas(id) ON DELETE CASCADE,
  notification_enabled BOOLEAN DEFAULT false,
  notification_time TIME DEFAULT '18:00:00',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, user_id)
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_waste_collections_tenant ON waste_collections(tenant_id);
CREATE INDEX IF NOT EXISTS idx_waste_collections_area ON waste_collections(area_id, collection_date);
CREATE INDEX IF NOT EXISTS idx_waste_collections_date ON waste_collections(collection_date);
CREATE INDEX IF NOT EXISTS idx_user_waste_prefs_tenant ON user_waste_preferences(tenant_id, user_id);

COMMENT ON TABLE waste_areas IS 'Stores waste collection areas (streets/districts) for each tenant';
COMMENT ON TABLE waste_types IS 'Stores types of waste bins (Bio, Restmüll, Papier, Gelbe Tonne)';
COMMENT ON TABLE waste_collections IS 'Stores waste collection schedule for each area';
COMMENT ON TABLE user_waste_preferences IS 'Stores user preferences for waste collection notifications';

-- Insert default waste types
INSERT INTO waste_types (name, color, icon, description) VALUES
  ('Biotonne', 'green', 'Leaf', 'Grüne Biotonne für organische Abfälle'),
  ('Saisonbiotonne', 'green', 'Flower', 'Grüne Saisontonne für Gartenabfälle'),
  ('Restmülltonne', 'gray', 'Trash2', 'Graue Restmülltonne'),
  ('Altpapiertonne', 'blue', 'FileText', 'Blaue Altpapiertonne'),
  ('Gelbe Tonne', 'yellow', 'Package', 'Gelbe Tonne für Verpackungen')
ON CONFLICT (name) DO NOTHING;
