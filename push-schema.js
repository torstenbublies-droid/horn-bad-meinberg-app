#!/usr/bin/env node
import { drizzle } from 'drizzle-orm/postgres-js';
import { migrate } from 'drizzle-orm/postgres-js/migrator';
import postgres from 'postgres';

const DATABASE_URL = process.env.DATABASE_URL;

if (!DATABASE_URL) {
  console.error('❌ DATABASE_URL not set');
  process.exit(1);
}

console.log('🔄 Pushing schema to database...');

const client = postgres(DATABASE_URL, { max: 1 });
const db = drizzle(client);

async function pushSchema() {
  try {
    // Drizzle Kit push will be done via CLI
    console.log('✅ Use: drizzle-kit push');
    await client.end();
  } catch (error) {
    console.error('❌ Error:', error);
    await client.end();
    process.exit(1);
  }
}

pushSchema();
