#!/usr/bin/env node
/**
 * Initialize Render.com database with Horn-Bad Meinberg data
 * This script runs on Render during deployment
 */

import postgres from 'postgres';
import { drizzle } from 'drizzle-orm/postgres-js';
import * as schema from './drizzle/schema.js';

const DATABASE_URL = process.env.DATABASE_URL;

if (!DATABASE_URL) {
  console.error('❌ DATABASE_URL not set');
  process.exit(1);
}

console.log('🔄 Initializing Render database...');

const client = postgres(DATABASE_URL);
const db = drizzle(client, { schema });

async function initDatabase() {
  try {
    // Check if tenants table exists and has data
    const tenants = await db.select().from(schema.tenants).limit(1);
    
    if (tenants.length > 0) {
      console.log('✅ Database already initialized');
      await client.end();
      process.exit(0);
    }

    console.log('📝 Creating tenant: Horn-Bad Meinberg...');
    
    // Insert Horn-Bad Meinberg tenant
    await db.insert(schema.tenants).values({
      id: 'hornbadmeinberg',
      name: 'Horn-Bad Meinberg',
      subdomain: 'hornbadmeinberg',
      primaryColor: '#4A7C7E',
      secondaryColor: '#2C5456',
      logoUrl: '/assets/hornbadmeinberg/logo.jpg',
      faviconUrl: '/assets/hornbadmeinberg/favicon.jpg',
      heroImageUrl: '/assets/hornbadmeinberg/hero.png',
      contactEmail: 'info@horn-badmeinberg.de',
      contactPhone: '+49 5234 9710',
      address: 'Mittelstraße 16, 32805 Horn-Bad Meinberg',
      website: 'https://www.horn-badmeinberg.de',
      description: 'Staatlich anerkannter Heilbadeort im Kreis Lippe',
      mayor: 'Michael Ruttner',
      population: 17000,
      area: 120.5,
      postalCode: '32805',
      latitude: 51.8833,
      longitude: 8.9667,
      timezone: 'Europe/Berlin',
      locale: 'de-DE',
      currency: 'EUR',
      features: JSON.stringify({
        news: true,
        events: true,
        waste: true,
        chat: true,
        forms: true,
        clubs: true,
        education: true,
        attractions: true
      }),
      openingHours: JSON.stringify({
        'Montag': '08:00-12:00, 14:00-16:00',
        'Dienstag': '08:00-12:00, 14:00-18:00',
        'Mittwoch': '08:00-12:00',
        'Donnerstag': '08:00-12:00, 14:00-16:00',
        'Freitag': '08:00-12:00'
      }),
      socialMedia: JSON.stringify({
        facebook: 'https://www.facebook.com/HornBadMeinberg',
        instagram: 'https://www.instagram.com/hornbadmeinberg'
      }),
      createdAt: new Date(),
      updatedAt: new Date()
    });

    console.log('✅ Tenant created successfully');
    console.log('ℹ️  Note: News, events, and other data will be populated by scrapers');
    
    await client.end();
    console.log('✅ Database initialization complete');
    process.exit(0);
    
  } catch (error) {
    console.error('❌ Database initialization failed:', error);
    await client.end();
    process.exit(1);
  }
}

initDatabase();
