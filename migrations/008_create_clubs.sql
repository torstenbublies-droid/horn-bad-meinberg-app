-- Create club_categories table
CREATE TABLE IF NOT EXISTS club_categories (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(64) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  icon VARCHAR(50) NOT NULL DEFAULT 'Users',
  color VARCHAR(50) NOT NULL DEFAULT 'blue',
  display_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, name)
);

-- Create clubs table
CREATE TABLE IF NOT EXISTS clubs (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(64) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  category_id INTEGER NOT NULL REFERENCES club_categories(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  contact_person VARCHAR(255),
  address VARCHAR(500),
  phone VARCHAR(50),
  fax VARCHAR(50),
  email VARCHAR(255),
  website VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, name)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_clubs_tenant ON clubs(tenant_id);
CREATE INDEX IF NOT EXISTS idx_clubs_category ON clubs(category_id);
CREATE INDEX IF NOT EXISTS idx_club_categories_tenant ON club_categories(tenant_id);
