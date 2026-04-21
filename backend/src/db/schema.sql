-- Veritabanı Şeması: bank-server
-- Çalıştırmak için: psql -U postgres -d bankdb -f src/db/schema.sql

-- Kullanıcılar
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name VARCHAR(150) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Hesaplar
CREATE TABLE IF NOT EXISTS accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(150) NOT NULL,
  iban VARCHAR(34) UNIQUE NOT NULL,
  balance NUMERIC(18, 2) NOT NULL DEFAULT 0,
  currency VARCHAR(10) NOT NULL DEFAULT 'TRY',
  account_type VARCHAR(50) NOT NULL DEFAULT 'checking', -- checking | savings | gold
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Para Transferleri
CREATE TABLE IF NOT EXISTS transfers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_account_id UUID NOT NULL REFERENCES accounts(id),
  receiver_iban VARCHAR(34) NOT NULL,
  receiver_name VARCHAR(150),
  amount NUMERIC(18, 2) NOT NULL CHECK (amount > 0),
  currency VARCHAR(10) NOT NULL DEFAULT 'TRY',
  description TEXT,
  status VARCHAR(20) NOT NULL DEFAULT 'completed', -- completed | pending | failed
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Güncellenme zamanını otomatik tutan trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_accounts_updated
  BEFORE UPDATE ON accounts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- İndeksler
CREATE INDEX IF NOT EXISTS idx_accounts_user_id ON accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_transfers_sender ON transfers(sender_account_id);
CREATE INDEX IF NOT EXISTS idx_transfers_created_at ON transfers(created_at DESC);
