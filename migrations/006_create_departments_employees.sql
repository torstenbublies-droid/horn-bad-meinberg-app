-- Migration: Create departments and employees tables
-- Created: 2025-11-23

-- Departments table
CREATE TABLE IF NOT EXISTS departments (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(64) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  icon VARCHAR(100),
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, name)
);

-- Employees table
CREATE TABLE IF NOT EXISTS employees (
  id SERIAL PRIMARY KEY,
  tenant_id VARCHAR(64) NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
  name VARCHAR(255) NOT NULL,
  title VARCHAR(255),
  responsibilities TEXT,
  phone VARCHAR(50),
  fax VARCHAR(50),
  email VARCHAR(255),
  room VARCHAR(50),
  address VARCHAR(500),
  office_hours TEXT,
  source_url TEXT,
  scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, name, phone)
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_departments_tenant ON departments(tenant_id, display_order);
CREATE INDEX IF NOT EXISTS idx_employees_tenant ON employees(tenant_id);
CREATE INDEX IF NOT EXISTS idx_employees_department ON employees(department_id);
CREATE INDEX IF NOT EXISTS idx_employees_name ON employees(tenant_id, name);

COMMENT ON TABLE departments IS 'Stores department information for each tenant';
COMMENT ON TABLE employees IS 'Stores employee contact information organized by department';
COMMENT ON COLUMN departments.icon IS 'Icon name for the department (e.g., "Building", "Users", "Briefcase")';
COMMENT ON COLUMN departments.display_order IS 'Order in which departments should be displayed';
COMMENT ON COLUMN employees.responsibilities IS 'Description of employee responsibilities and tasks';
