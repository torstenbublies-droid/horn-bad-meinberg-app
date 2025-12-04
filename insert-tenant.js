#!/usr/bin/env node
import pg from 'pg';
const { Client } = pg;

const client = new Client({
  connectionString: process.env.DATABASE_URL
});

async function insertTenant() {
  try {
    await client.connect();
    console.log('✅ Connected to database');

    // Check if tenant exists
    const checkResult = await client.query(
      "SELECT id FROM tenants WHERE id = 'hornbadmeinberg'"
    );

    if (checkResult.rows.length > 0) {
      console.log('✅ Tenant already exists');
      await client.end();
      return;
    }

    // Insert tenant
    await client.query(`
      INSERT INTO tenants (
        id, name, subdomain, primary_color, secondary_color,
        logo_url, favicon_url, hero_image_url,
        contact_email, contact_phone, address, website,
        description, mayor, population, area, postal_code,
        latitude, longitude, timezone, locale, currency,
        features, opening_hours, social_media,
        created_at, updated_at
      ) VALUES (
        'hornbadmeinberg',
        'Horn-Bad Meinberg',
        'hornbadmeinberg',
        '#4A7C7E',
        '#2C5456',
        '/assets/hornbadmeinberg/logo.jpg',
        '/assets/hornbadmeinberg/favicon.jpg',
        '/assets/hornbadmeinberg/hero.png',
        'info@horn-badmeinberg.de',
        '+49 5234 9710',
        'Mittelstraße 16, 32805 Horn-Bad Meinberg',
        'https://www.horn-badmeinberg.de',
        'Staatlich anerkannter Heilbadeort im Kreis Lippe',
        'Michael Ruttner',
        17000,
        120.5,
        '32805',
        51.8833,
        8.9667,
        'Europe/Berlin',
        'de-DE',
        'EUR',
        '{"news":true,"events":true,"waste":true,"chat":true,"forms":true,"clubs":true,"education":true,"attractions":true}',
        '{"Montag":"08:00-12:00, 14:00-16:00","Dienstag":"08:00-12:00, 14:00-18:00","Mittwoch":"08:00-12:00","Donnerstag":"08:00-12:00, 14:00-16:00","Freitag":"08:00-12:00"}',
        '{"facebook":"https://www.facebook.com/HornBadMeinberg","instagram":"https://www.instagram.com/hornbadmeinberg"}',
        NOW(),
        NOW()
      )
    `);

    console.log('✅ Tenant created successfully');
    await client.end();
  } catch (error) {
    console.error('❌ Error:', error);
    await client.end();
    process.exit(1);
  }
}

insertTenant();
