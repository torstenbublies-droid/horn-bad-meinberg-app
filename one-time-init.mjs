#!/usr/bin/env node
import pg from 'pg';
const { Client } = pg;

const client = new Client({ connectionString: process.env.DATABASE_URL });

async function init() {
  try {
    await client.connect();
    console.log('✅ Connected to database');

    // Create tenants table with CORRECT schema (matching drizzle/schema.ts)
    await client.query(`
      CREATE TABLE IF NOT EXISTS tenants (
        id VARCHAR(64) PRIMARY KEY,
        name VARCHAR(200) NOT NULL,
        slug VARCHAR(100) NOT NULL UNIQUE,
        "primaryColor" VARCHAR(20) DEFAULT '#0066CC',
        "secondaryColor" VARCHAR(20) DEFAULT '#00A86B',
        "logoUrl" VARCHAR(1000),
        "heroImageUrl" VARCHAR(1000),
        "contactEmail" VARCHAR(320),
        "contactPhone" VARCHAR(50),
        "contactAddress" TEXT,
        "weatherLat" VARCHAR(50),
        "weatherLon" VARCHAR(50),
        "weatherCity" VARCHAR(200),
        "chatbotName" VARCHAR(100) DEFAULT 'Chatbot',
        "chatbotSystemPrompt" TEXT,
        "enabledFeatures" TEXT,
        "isActive" BOOLEAN DEFAULT true NOT NULL,
        "createdAt" TIMESTAMP DEFAULT NOW(),
        "updatedAt" TIMESTAMP DEFAULT NOW()
      )
    `);
    console.log('✅ Tenants table created');

    // Insert schieder tenant
    await client.query(`
      INSERT INTO tenants (id, name, slug, "primaryColor", "secondaryColor", "contactEmail", "contactPhone", "contactAddress", "weatherCity", "isActive", "createdAt", "updatedAt")
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, true, NOW(), NOW())
      ON CONFLICT (id) DO NOTHING
    `, ['schieder', 'Schieder-Schwalenberg', 'schieder', '#3b82f6', '#1e40af', 'info@schieder-schwalenberg.de', '+49 5282 6010', 'Domäne 3, 32816 Schieder-Schwalenberg', 'Schieder-Schwalenberg']);
    console.log('✅ Schieder tenant inserted');

    // Insert hornbadmeinberg tenant
    await client.query(`
      INSERT INTO tenants (id, name, slug, "primaryColor", "secondaryColor", "logoUrl", "heroImageUrl", "contactEmail", "contactPhone", "contactAddress", "weatherLat", "weatherLon", "weatherCity", "chatbotName", "enabledFeatures", "isActive", "createdAt", "updatedAt")
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, true, NOW(), NOW())
      ON CONFLICT (id) DO NOTHING
    `, [
      'hornbadmeinberg',
      'Horn-Bad Meinberg',
      'hornbadmeinberg',
      '#4A7C7E',
      '#2C5456',
      '/assets/hornbadmeinberg/logo.jpg',
      '/assets/hornbadmeinberg/hero.png',
      'info@horn-badmeinberg.de',
      '+49 5234 9710',
      'Mittelstraße 16, 32805 Horn-Bad Meinberg',
      '51.8833',
      '8.9667',
      'Horn-Bad Meinberg',
      'Meinberg Bot',
      JSON.stringify(["news","events","waste","chat","forms","clubs","education","attractions"])
    ]);
    console.log('✅ HornBadMeinberg tenant inserted');

    await client.end();
    console.log('✅ SUCCESS - Database initialized!');
    process.exit(0);
  } catch (error) {
    console.error('❌ ERROR:', error.message);
    try { await client.end(); } catch (e) {}
    process.exit(1);
  }
}

init();
