import 'dotenv/config';
import { OpenAI } from 'openai';
import { getDb } from '../server/db';
import { websiteChunks, tenants } from '../drizzle/schema';
import { nanoid } from 'nanoid';
import { eq } from 'drizzle-orm';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

/**
 * Generate embedding for text using OpenAI
 */
async function generateEmbedding(text: string): Promise<number[]> {
  try {
    const response = await openai.embeddings.create({
      model: 'text-embedding-ada-002',
      input: text,
    });
    return response.data[0].embedding;
  } catch (error) {
    console.error('Error generating embedding:', error);
    throw error;
  }
}

/**
 * Store content chunk with embedding
 */
async function storeChunk(
  tenantId: string,
  url: string,
  title: string,
  content: string,
  chunkIndex: number
) {
  const db = await getDb();
  
  console.log(`  → Generating embedding for: ${title}`);
  const embedding = await generateEmbedding(content);
  
  await db.insert(websiteChunks).values({
    id: nanoid(),
    tenantId,
    url,
    title,
    content,
    chunkIndex,
    embedding: JSON.stringify(embedding),
    metadata: JSON.stringify({
      indexedAt: new Date().toISOString(),
      source: 'database',
    }),
  });
}

/**
 * Index all database content for a tenant
 */
async function indexDatabaseContent(tenantId: string) {
  console.log('=== Indexing Database Content ===');
  console.log(`Tenant: ${tenantId}`);
  console.log('');
  
  const db = await getDb();
  
  // Get tenant info
  const tenant = await db.query.tenants.findFirst({
    where: eq(tenants.id, tenantId),
  });
  
  if (!tenant) {
    throw new Error(`Tenant ${tenantId} not found`);
  }
  
  console.log(`Tenant: ${tenant.name}`);
  console.log('');
  
  let chunkIndex = 0;
  
  // 1. Index tenant basic information
  console.log('Indexing tenant information...');
  const tenantInfo = `
Stadt: ${tenant.name}
Kontakt:
- E-Mail: ${tenant.contactEmail || 'Nicht verfügbar'}
- Telefon: ${tenant.contactPhone || 'Nicht verfügbar'}
- Adresse: ${tenant.contactAddress || 'Nicht verfügbar'}

Bürgermeister: ${(tenant as any).mayor_name || 'Michael Ruttner'}

Öffnungszeiten Rathaus:
${(tenant as any).opening_hours || `Montag: 08:00 - 12:00 Uhr, 14:00 - 16:00 Uhr
Dienstag: 08:00 - 12:00 Uhr, 14:00 - 18:00 Uhr
Mittwoch: 08:00 - 12:00 Uhr
Donnerstag: 08:00 - 12:00 Uhr, 14:00 - 16:00 Uhr
Freitag: 08:00 - 12:00 Uhr`}
  `.trim();
  
  await storeChunk(
    tenantId,
    'database://tenant/info',
    'Allgemeine Informationen',
    tenantInfo,
    chunkIndex++
  );
  
  // 2. Index news articles
  console.log('Indexing news articles...');
  const newsArticles = await db.query.news.findMany({
    where: eq((await import('../drizzle/schema')).news.tenantId, tenantId),
    limit: 50,
  });
  
  for (const article of newsArticles) {
    const content = `
Nachricht: ${article.title}
${article.teaser || ''}
${article.bodyMD || ''}
Veröffentlicht: ${article.publishedAt?.toLocaleDateString('de-DE')}
Kategorie: ${article.category || 'Allgemein'}
    `.trim();
    
    await storeChunk(
      tenantId,
      `database://news/${article.id}`,
      article.title,
      content,
      chunkIndex++
    );
  }
  
  // 3. Index education institutions
  console.log('Indexing education institutions...');
  const institutions = await db.query.institutions.findMany({
    where: eq((await import('../drizzle/schema')).institutions.tenantId, tenantId),
  });
  
  for (const inst of institutions) {
    const content = `
Bildungseinrichtung: ${inst.name}
Typ: ${inst.category || 'Bildungseinrichtung'}
Adresse: ${inst.address || 'Nicht verfügbar'}
Telefon: ${inst.phone || 'Nicht verfügbar'}
E-Mail: ${inst.email || 'Nicht verfügbar'}
Website: ${inst.website || 'Nicht verfügbar'}
Beschreibung: ${inst.description || ''}
    `.trim();
    
    await storeChunk(
      tenantId,
      `database://institutions/${inst.id}`,
      inst.name,
      content,
      chunkIndex++
    );
  }
  
  // 4. Index attractions/tourism
  console.log('Indexing attractions...');
  const attractions = await db.query.pois.findMany({
    where: eq((await import('../drizzle/schema')).pois.tenantId, tenantId),
    limit: 50,
  });
  
  for (const poi of attractions) {
    const content = `
Sehenswürdigkeit: ${poi.name}
Kategorie: ${poi.category || 'Sehenswürdigkeit'}
Adresse: ${poi.address || 'Nicht verfügbar'}
Beschreibung: ${poi.description || ''}
${poi.openingHours ? `Öffnungszeiten: ${poi.openingHours}` : ''}
${poi.phone ? `Telefon: ${poi.phone}` : ''}
${poi.website ? `Website: ${poi.website}` : ''}
    `.trim();
    
    await storeChunk(
      tenantId,
      `database://pois/${poi.id}`,
      poi.name,
      content,
      chunkIndex++
    );
  }
  
  // 5. Index employees
  console.log('Indexing employees...');
  const employees = await db.query.departments.findMany({
    where: eq((await import('../drizzle/schema')).departments.tenantId, tenantId),
  });
  
  for (const emp of employees) {
    const content = `
Mitarbeiter: ${emp.name}
Abteilung: ${emp.description || 'Stadtverwaltung'}
Telefon: ${emp.phone || 'Nicht verfügbar'}
E-Mail: ${emp.email || 'Nicht verfügbar'}
    `.trim();
    
    await storeChunk(
      tenantId,
      `database://employees/${emp.id}`,
      emp.name,
      content,
      chunkIndex++
    );
  }
  
  console.log('');
  console.log('=== Indexing Complete ===');
  console.log(`Total chunks indexed: ${chunkIndex}`);
}

// Run indexer
indexDatabaseContent('tenant_hornbadmeinberg_001')
  .then(() => {
    console.log('Done!');
    process.exit(0);
  })
  .catch((error) => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
