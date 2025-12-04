#!/usr/bin/env node
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import { tenants } from './drizzle/schema.ts';

const client = postgres(process.env.DATABASE_URL);
const db = drizzle(client, { schema: { tenants } });

async function init() {
  try {
    console.log('🔄 Initializing database with Drizzle...');

    // Insert schieder tenant
    await db.insert(tenants).values({
      id: 'schieder',
      name: 'Schieder-Schwalenberg',
      slug: 'schieder',
      primaryColor: '#3b82f6',
      secondaryColor: '#1e40af',
      contactEmail: 'info@schieder-schwalenberg.de',
      contactPhone: '+49 5282 6010',
      contactAddress: 'Domäne 3, 32816 Schieder-Schwalenberg',
      weatherCity: 'Schieder-Schwalenberg',
      isActive: true
    }).onConflictDoNothing();
    console.log('✅ Schieder tenant created');

    // Insert hornbadmeinberg tenant
    await db.insert(tenants).values({
      id: 'hornbadmeinberg',
      name: 'Horn-Bad Meinberg',
      slug: 'hornbadmeinberg',
      primaryColor: '#4A7C7E',
      secondaryColor: '#2C5456',
      logoUrl: '/assets/hornbadmeinberg/logo.jpg',
      heroImageUrl: '/assets/hornbadmeinberg/hero.png',
      contactEmail: 'info@horn-badmeinberg.de',
      contactPhone: '+49 5234 9710',
      contactAddress: 'Mittelstraße 16, 32805 Horn-Bad Meinberg',
      weatherLat: '51.8833',
      weatherLon: '8.9667',
      weatherCity: 'Horn-Bad Meinberg',
      chatbotName: 'Meinberg Bot',
      enabledFeatures: JSON.stringify(["news","events","waste","chat","forms","clubs","education","attractions"]),
      isActive: true
    }).onConflictDoNothing();
    console.log('✅ HornBadMeinberg tenant created');

    await client.end();
    console.log('✅ SUCCESS - Database initialized!');
    process.exit(0);
  } catch (error) {
    console.error('❌ ERROR:', error.message);
    console.error(error);
    try { await client.end(); } catch (e) {}
    process.exit(1);
  }
}

init();
