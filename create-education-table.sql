CREATE TABLE IF NOT EXISTS education_institutions (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(255) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL, -- Grundschulen, Sekundarschule, Gymnasium, Kindergärten, VHS
  description TEXT,
  address TEXT,
  phone VARCHAR(50),
  fax VARCHAR(50),
  email VARCHAR(255),
  website VARCHAR(500),
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_education_tenant ON education_institutions(tenant_id);
CREATE INDEX IF NOT EXISTS idx_education_category ON education_institutions(category);
