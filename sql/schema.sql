CREATE DATABASE IF NOT EXISTS qi_app;
USE qi_app;

-- 🧑 USERS (Admin, Staff, Clients)
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('admin', 'staff', 'client') DEFAULT 'client',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP NULL
);

-- 👤 CLIENT INFO
CREATE TABLE IF NOT EXISTS clients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  name VARCHAR(255),
  phone VARCHAR(20),
  tax_id VARCHAR(50),
  address VARCHAR(255),
  entity_type ENUM('individual', 'llc', 'trust', 'corporation') DEFAULT 'individual',
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 🔁 EXCHANGES
CREATE TABLE IF NOT EXISTS exchanges (
  id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT,
  exchange_type ENUM('delayed','reverse','build-to-suit') DEFAULT 'delayed',
  start_date DATE,
  end_date DATE,
  status ENUM('open','completed','cancelled') DEFAULT 'open',
  irs_form_type VARCHAR(50),
  intermediary_fee DECIMAL(10,2),
  notes TEXT,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE SET NULL
);

-- 🏘️ PROPERTIES
CREATE TABLE IF NOT EXISTS properties (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exchange_id INT,
  address VARCHAR(255),
  type ENUM('relinquished','replacement'),
  closing_date DATE,
  price DECIMAL(15,2),
  escrow_info VARCHAR(255),
  parcel_id VARCHAR(100),
  title_company VARCHAR(255),
  ownership_share DECIMAL(5,2),
  FOREIGN KEY (exchange_id) REFERENCES exchanges(id) ON DELETE CASCADE
);

-- 💵 FUNDS TRACKING
CREATE TABLE IF NOT EXISTS funds (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exchange_id INT,
  amount DECIMAL(15,2),
  direction ENUM('incoming','outgoing'),
  method ENUM('wire','check'),
  transaction_date DATE,
  reference_number VARCHAR(100),
  bank_name VARCHAR(100),
  memo TEXT,
  FOREIGN KEY (exchange_id) REFERENCES exchanges(id) ON DELETE CASCADE
);

-- 📄 DOCUMENT STORAGE
CREATE TABLE IF NOT EXISTS documents (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exchange_id INT,
  filename VARCHAR(255),
  url TEXT,
  document_type VARCHAR(100),
  uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (exchange_id) REFERENCES exchanges(id) ON DELETE CASCADE
);

-- 📬 NOTIFICATIONS
CREATE TABLE IF NOT EXISTS notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 📑 IRS QUESTIONNAIRE RESPONSES
CREATE TABLE IF NOT EXISTS questionnaire_responses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exchange_id INT NOT NULL,
  questionnaire_data JSON NOT NULL,
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (exchange_id) REFERENCES exchanges(id) ON DELETE CASCADE
);

-- 💳 PAYMENTS
CREATE TABLE IF NOT EXISTS payments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT NOT NULL,
  exchange_id INT,
  amount DECIMAL(15,2),
  status ENUM('pending','completed','failed') DEFAULT 'pending',
  method ENUM('credit_card','wire_transfer','check'),
  payment_date DATE,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  FOREIGN KEY (exchange_id) REFERENCES exchanges(id) ON DELETE SET NULL
);

-- 🧾 AUDIT LOG (Optional, but smart)
CREATE TABLE IF NOT EXISTS audit_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  action VARCHAR(255),
  target_table VARCHAR(255),
  target_id INT,
  details TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);
