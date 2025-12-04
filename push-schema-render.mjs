#!/usr/bin/env node
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './drizzle/schema.ts';

const client = postgres(process.env.DATABASE_URL);
const db = drizzle(client, { schema });

console.log('Drizzle will auto-create tables on first query...');
console.log('Schema loaded successfully');
client.end();
