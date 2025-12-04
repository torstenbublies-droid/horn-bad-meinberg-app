import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import { eq } from 'drizzle-orm';
import { tenants } from './drizzle/schema.ts';

const client = postgres('postgresql://buergerapp_user:BGAGVsLbQhib8wlHN3fqTq0qncuLqwMs@dpg-d4o3tpvdiees7382n100-a.oregon-postgres.render.com/buergerapp?sslmode=require');
const db = drizzle(client, { schema: { tenants } });

try {
  console.log('Testing Drizzle query...');
  const result = await db.select().from(tenants).where(eq(tenants.slug, 'hornbadmeinberg')).limit(1);
  console.log('Result:', result);
  await client.end();
} catch (error) {
  console.error('Error:', error.message);
  try { await client.end(); } catch (e) {}
}
