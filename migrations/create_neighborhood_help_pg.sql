-- Create help_requests table
CREATE TABLE IF NOT EXISTS help_requests (
  id VARCHAR(21) PRIMARY KEY,
  tenant_id INTEGER NOT NULL,
  created_by VARCHAR(255) NOT NULL,
  created_by_name VARCHAR(255) NOT NULL,
  category VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  district VARCHAR(100) NOT NULL,
  meeting_point VARCHAR(255),
  timeframe VARCHAR(255) NOT NULL,
  urgency VARCHAR(10) DEFAULT 'medium' CHECK (urgency IN ('low', 'medium', 'high')),
  contact_method VARCHAR(10) DEFAULT 'app' CHECK (contact_method IN ('app', 'phone')),
  phone_number VARCHAR(50),
  status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'completed', 'cancelled')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_help_requests_tenant ON help_requests(tenant_id);
CREATE INDEX IF NOT EXISTS idx_help_requests_status ON help_requests(status);
CREATE INDEX IF NOT EXISTS idx_help_requests_category ON help_requests(category);
CREATE INDEX IF NOT EXISTS idx_help_requests_district ON help_requests(district);

-- Create help_offers table
CREATE TABLE IF NOT EXISTS help_offers (
  id VARCHAR(21) PRIMARY KEY,
  tenant_id INTEGER NOT NULL,
  created_by VARCHAR(255) NOT NULL,
  created_by_name VARCHAR(255) NOT NULL,
  categories JSONB NOT NULL,
  description TEXT NOT NULL,
  district VARCHAR(100) NOT NULL,
  radius INTEGER DEFAULT 3,
  availability TEXT NOT NULL,
  contact_method VARCHAR(10) DEFAULT 'app' CHECK (contact_method IN ('app', 'phone')),
  phone_number VARCHAR(50),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'paused', 'inactive')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_help_offers_tenant ON help_offers(tenant_id);
CREATE INDEX IF NOT EXISTS idx_help_offers_status ON help_offers(status);
CREATE INDEX IF NOT EXISTS idx_help_offers_district ON help_offers(district);

-- Create help_messages table
CREATE TABLE IF NOT EXISTS help_messages (
  id VARCHAR(21) PRIMARY KEY,
  request_id VARCHAR(21) REFERENCES help_requests(id) ON DELETE CASCADE,
  offer_id VARCHAR(21) REFERENCES help_offers(id) ON DELETE CASCADE,
  from_user VARCHAR(255) NOT NULL,
  to_user VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  read_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_help_messages_request ON help_messages(request_id);
CREATE INDEX IF NOT EXISTS idx_help_messages_offer ON help_messages(offer_id);

-- Create help_ratings table  
CREATE TABLE IF NOT EXISTS help_ratings (
  id VARCHAR(21) PRIMARY KEY,
  request_id VARCHAR(21) REFERENCES help_requests(id) ON DELETE CASCADE,
  offer_id VARCHAR(21) REFERENCES help_offers(id) ON DELETE CASCADE,
  rated_by VARCHAR(255) NOT NULL,
  rated_user VARCHAR(255) NOT NULL,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_help_ratings_request ON help_ratings(request_id);
CREATE INDEX IF NOT EXISTS idx_help_ratings_offer ON help_ratings(offer_id);
