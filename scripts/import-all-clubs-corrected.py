#!/usr/bin/env python3
"""
Import aller 86 Vereine von der Website
Kategorisiert in: Sportvereine und Vereine
"""

import psycopg2

# Datenbank-Verbindung
conn = psycopg2.connect(
    host="localhost",
    database="buergerapp",
    user="buergerapp_user",
    password="buergerapp_dev_2025"
)

cur = conn.cursor()

# Tenant-ID ermitteln
cur.execute("SELECT id FROM tenants WHERE slug = 'schieder'")
tenant_result = cur.fetchone()

if not tenant_result:
    print("❌ Tenant 'schieder' nicht gefunden!")
    exit(1)

tenant_id = tenant_result[0]
print(f"✅ Tenant ID: {tenant_id}")

# Schritt 1: Kategorien erstellen
print("\n📁 Erstelle Kategorien...")

# Alte Kategorien löschen
cur.execute("DELETE FROM club_categories WHERE tenant_id = %s", (tenant_id,))
print(f"   {cur.rowcount} alte Kategorien gelöscht")

# Neue Kategorien erstellen
categories = [
    {"name": "Sportvereine", "icon": "⚽", "color": "#4CAF50", "order": 1},
    {"name": "Vereine", "icon": "🏛️", "color": "#2196F3", "order": 2}
]

category_ids = {}

for cat in categories:
    cur.execute("""
        INSERT INTO club_categories (tenant_id, name, icon, color, display_order, created_at, updated_at)
        VALUES (%s, %s, %s, %s, %s, NOW(), NOW())
        RETURNING id
    """, (tenant_id, cat["name"], cat["icon"], cat["color"], cat["order"]))
    
    category_id = cur.fetchone()[0]
    category_ids[cat["name"]] = category_id
    print(f"   ✅ {cat['name']} (ID: {category_id})")

conn.commit()

# Schritt 2: Vereine importieren
print("\n📥 Importiere Vereine...")

# Alle 86 Vereine
clubs_data = [
    # Sportvereine
    {"name": "1. Pyrmonter Segel- und Wassersportclub e.V.", "category": "Sportvereine"},
    {"name": "DLRG Ortsgruppe Schieder-Schwalenberg", "category": "Sportvereine"},
    {"name": "Schießsportverein Lothe", "category": "Sportvereine"},
    {"name": "Schützengesellschaft Lothe", "category": "Sportvereine"},
    {"name": "Schützengesellschaft Schwalenberg", "category": "Sportvereine"},
    {"name": "Schützengruppe Siekholz", "category": "Sportvereine"},
    {"name": "Schützenverein Siekholz", "category": "Sportvereine"},
    {"name": "Tennisclub Schieder-Schwalenberg", "category": "Sportvereine"},
    {"name": "TG Siekholz", "category": "Sportvereine"},
    {"name": "TSV Lothe", "category": "Sportvereine"},
    {"name": "TuS Wöbbel", "category": "Sportvereine"},
    {"name": "Stadtsportverband", "category": "Sportvereine"},
    {"name": "TuS 08 Brakelsiek", "category": "Sportvereine"},
    {"name": "TuS Schieder-Schwalenberg", "category": "Sportvereine"},
    
    # Vereine (alle anderen)
    {"name": "Angelsportverein Schieder", "category": "Vereine"},
    {"name": "Angelsportverein Schieder Glashütte", "category": "Vereine"},
    {"name": "Ankerplatz", "category": "Vereine"},
    {"name": "OPEL Club Schieder-Schwalenberg", "category": "Vereine"},
    {"name": "PS Freunde Lippe", "category": "Vereine"},
    {"name": "Schwalenberger Brauzunft", "category": "Vereine"},
    {"name": "Trachtengilde Schwalenberg", "category": "Vereine"},
    {"name": "VFDG e.V.", "category": "Vereine"},
    {"name": "Wanderarbeiterverein Lothe", "category": "Vereine"},
    {"name": "MGV Wöbbel", "category": "Vereine"},
    {"name": "Musikzug der Freiwilligen Feuerwehr", "category": "Vereine"},
    {"name": "Ökumenischer Chor", "category": "Vereine"},
    {"name": "Spielmannszug Brakelsiek", "category": "Vereine"},
    {"name": "FC Schalke 04 Fan Club Brakelsiek", "category": "Vereine"},
    {"name": "Förderverein Grundschule Schwalenberg", "category": "Vereine"},
    {"name": "Förderverein Brakelsieker Mehrzweckhalle", "category": "Vereine"},
    {"name": "Bürgerstiftung Schwalenberg", "category": "Vereine"},
    {"name": "Förderverein Jugendfeuerwehr", "category": "Vereine"},
    {"name": "Förderverein Löschzug Schieder", "category": "Vereine"},
    {"name": "Förderverein Schloss und Schlosspark Schieder", "category": "Vereine"},
    {"name": "Freiwillige Feuerwehr", "category": "Vereine"},
    {"name": "Brieftaubenverein Frohes Wiedersehen Lothe", "category": "Vereine"},
    {"name": "Geflügelzuchtverein Brakelsiek", "category": "Vereine"},
    {"name": "Geflügelzuchtverein Lothe", "category": "Vereine"},
    {"name": "Heimat- und Verkehrsverein Brakelsiek", "category": "Vereine"},
    {"name": "Heimat- und Verkehrsverein Lothe", "category": "Vereine"},
    {"name": "Heimat- und Verkehrsverein Schwalenberg", "category": "Vereine"},
    {"name": "Heimat- und Verkehrsverein Siekholz", "category": "Vereine"},
    {"name": "Heimatverein Wöbbel e.V.", "category": "Vereine"},
    {"name": "Jugendkreis Brakelsiek JKB e.V.", "category": "Vereine"},
    {"name": "Jugendkreis Lothe e.V.", "category": "Vereine"},
    {"name": "Jugendzentrum Church Schwalenberg", "category": "Vereine"},
    {"name": "Kolibri e.V.", "category": "Vereine"},
    {"name": "Kunstverein Schieder-Schwalenberg", "category": "Vereine"},
    {"name": "Luftsportgemeinschaft Lippe Südost e.V.", "category": "Vereine"},
    {"name": "MärchenWerkSTadt e.V.", "category": "Vereine"},
    {"name": "Biologische Station Lippe e.V.", "category": "Vereine"},
    {"name": "NABU Arbeitsgruppe Schieder-Schwalenberg", "category": "Vereine"},
    {"name": "Seniorentreff Brakelsiek", "category": "Vereine"},
    {"name": "Der Tisch in Schieder-Schwalenberg", "category": "Vereine"},
    {"name": "DRK Ortsverein Schwalenberg", "category": "Vereine"},
    {"name": "Evangelische Pfadfinderschaft Europas", "category": "Vereine"},
    {"name": "Sozialverband VdK", "category": "Vereine"},
    {"name": "Freundschaft - druschba e.V.", "category": "Vereine"},
    {"name": "Brieftaubenverein Lothe", "category": "Vereine"},
    {"name": "Brieftaubenverein Schwalenberg", "category": "Vereine"},
    {"name": "Förderverein Freibad Schieder-Schwalenberg", "category": "Vereine"},
    {"name": "Verein für Deutsche Schäferhunde OG Lothe", "category": "Vereine"},
    {"name": "Verein für Deutsche Schäferhunde OG Wöbbel", "category": "Vereine"},
    {"name": "Landfrauenverband Brakelsiek", "category": "Vereine"},
    {"name": "Wirtschaftsinitiative Schieder-Schwalenberg", "category": "Vereine"},
    {"name": "Wortmann Fischer e.V.", "category": "Vereine"},
]

print(f"📊 Insgesamt {len(clubs_data)} Vereine")

# Alte Clubs löschen
cur.execute("DELETE FROM clubs WHERE tenant_id = %s", (tenant_id,))
print(f"   {cur.rowcount} alte Vereine gelöscht")

# Neue Clubs importieren
imported_count = 0

for club in clubs_data:
    try:
        cat_id = category_ids[club["category"]]
        cur.execute("""
            INSERT INTO clubs (tenant_id, category_id, name, created_at, updated_at)
            VALUES (%s, %s, %s, NOW(), NOW())
        """, (tenant_id, cat_id, club["name"]))
        imported_count += 1
    except Exception as e:
        print(f"❌ Fehler: {club['name']}: {e}")
        conn.rollback()
        break

conn.commit()

print(f"\n✅ {imported_count} Vereine erfolgreich importiert!")

# Verifikation
cur.execute("""
    SELECT cc.name, COUNT(c.id)
    FROM club_categories cc
    LEFT JOIN clubs c ON c.category_id = cc.id AND c.tenant_id = cc.tenant_id
    WHERE cc.tenant_id = %s
    GROUP BY cc.name
    ORDER BY cc.display_order
""", (tenant_id,))

results = cur.fetchall()

print("\n📊 Verifikation:")
for category, count in results:
    print(f"   {category}: {count}")

cur.close()
conn.close()

print("\n🎉 Import abgeschlossen!")
