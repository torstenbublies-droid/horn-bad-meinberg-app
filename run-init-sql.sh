#!/bin/bash
set -e

echo "🔄 Running database initialization..."

if [ -z "$DATABASE_URL" ]; then
  echo "❌ DATABASE_URL not set"
  exit 1
fi

# Install psql if not available
if ! command -v psql &> /dev/null; then
  echo "📦 Installing postgresql-client..."
  apt-get update -qq && apt-get install -y -qq postgresql-client > /dev/null 2>&1
fi

# Run SQL script
echo "📝 Creating tables and inserting tenant..."
psql "$DATABASE_URL" -f init-db.sql

echo "✅ Database initialization complete"
