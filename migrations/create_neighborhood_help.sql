-- Create help_requests table
CREATE TABLE IF NOT EXISTS help_requests (
  id VARCHAR(21) PRIMARY KEY,
  tenant_id INT NOT NULL,
  created_by VARCHAR(255) NOT NULL,
  created_by_name VARCHAR(255) NOT NULL,
  category VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  district VARCHAR(100) NOT NULL,
  meeting_point VARCHAR(255),
  timeframe VARCHAR(255) NOT NULL,
  urgency ENUM('low', 'medium', 'high') DEFAULT 'medium',
  contact_method ENUM('app', 'phone') DEFAULT 'app',
  phone_number VARCHAR(50),
  status ENUM('open', 'in_progress', 'completed', 'cancelled') DEFAULT 'open',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_tenant (tenant_id),
  INDEX idx_status (status),
  INDEX idx_category (category),
  INDEX idx_district (district)
);

-- Create help_offers table
CREATE TABLE IF NOT EXISTS help_offers (
  id VARCHAR(21) PRIMARY KEY,
  tenant_id INT NOT NULL,
  created_by VARCHAR(255) NOT NULL,
  created_by_name VARCHAR(255) NOT NULL,
  categories JSON NOT NULL,
  description TEXT NOT NULL,
  district VARCHAR(100) NOT NULL,
  radius INT DEFAULT 3,
  availability TEXT NOT NULL,
  contact_method ENUM('app', 'phone') DEFAULT 'app',
  phone_number VARCHAR(50),
  status ENUM('active', 'paused', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_tenant (tenant_id),
  INDEX idx_status (status),
  INDEX idx_district (district)
);

-- Create help_messages table
CREATE TABLE IF NOT EXISTS help_messages (
  id VARCHAR(21) PRIMARY KEY,
  request_id VARCHAR(21),
  offer_id VARCHAR(21),
  from_user VARCHAR(255) NOT NULL,
  to_user VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  read_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_request (request_id),
  INDEX idx_offer (offer_id),
  FOREIGN KEY (request_id) REFERENCES help_requests(id) ON DELETE CASCADE,
  FOREIGN KEY (offer_id) REFERENCES help_offers(id) ON DELETE CASCADE
);

-- Create help_ratings table  
CREATE TABLE IF NOT EXISTS help_ratings (
  id VARCHAR(21) PRIMARY KEY,
  request_id VARCHAR(21),
  offer_id VARCHAR(21),
  rated_by VARCHAR(255) NOT NULL,
  rated_user VARCHAR(255) NOT NULL,
  rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_request (request_id),
  INDEX idx_offer (offer_id),
  FOREIGN KEY (request_id) REFERENCES help_requests(id) ON DELETE CASCADE,
  FOREIGN KEY (offer_id) REFERENCES help_offers(id) ON DELETE CASCADE
);
