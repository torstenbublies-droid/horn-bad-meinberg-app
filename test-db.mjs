import pg from 'pg';
const { Client } = pg;

const client = new Client({
  connectionString: 'postgresql://buergerapp_user:BGAGVsLbQhib8wlHN3fqTq0qncuLqwMs@dpg-d4o3tpvdiees7382n100-a.oregon-postgres.render.com/buergerapp'
});

await client.connect();
const result = await client.query('SELECT * FROM tenants');
console.log('Tenants found:', result.rows.length);
console.log('Columns:', Object.keys(result.rows[0] || {}));
if (result.rows[0]) {
  console.log('First tenant:', result.rows[0]);
}
await client.end();
