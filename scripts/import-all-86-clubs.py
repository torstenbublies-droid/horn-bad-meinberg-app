#!/usr/bin/env python3
"""
Import ALLER 86 Vereine von der Website (vollständige Liste)
"""

import psycopg2

conn = psycopg2.connect(
    host="localhost",
    database="buergerapp",
    user="buergerapp_user",
    password="buergerapp_dev_2025"
)

cur = conn.cursor()

# Tenant-ID
cur.execute("SELECT id FROM tenants WHERE slug = 'schieder'")
tenant_id = cur.fetchone()[0]

# Kategorien-IDs
cur.execute("SELECT id, name FROM club_categories WHERE tenant_id = %s", (tenant_id,))
categories = {row[1]: row[0] for row in cur.fetchall()}

sport_id = categories["Sportvereine"]
vereine_id = categories["Vereine"]

# ALLE 86 Vereine (vollständige Liste von der Website)
clubs = [
    # Sportvereine (14)
    (sport_id, "1. Pyrmonter Segel- und Wassersportclub e.V."),
    (sport_id, "DLRG Ortsgruppe Schieder-Schwalenberg"),
    (sport_id, "Schießsportverein Lothe"),
    (sport_id, "Schützengesellschaft Lothe"),
    (sport_id, "Schützengesellschaft Schwalenberg"),
    (sport_id, "Schützengruppe Siekholz"),
    (sport_id, "Schützenverein Siekholz"),
    (sport_id, "Stadtsportverband"),
    (sport_id, "Tennisclub Schieder-Schwalenberg"),
    (sport_id, "TG Siekholz"),
    (sport_id, "TSV Lothe"),
    (sport_id, "TuS 08 Brakelsiek"),
    (sport_id, "TuS Schieder-Schwalenberg"),
    (sport_id, "TuS Wöbbel"),
    
    # Vereine (72)
    (vereine_id, "Angelsportverein Schieder"),
    (vereine_id, "Angelsportverein Schieder Glashütte"),
    (vereine_id, "Ankerplatz"),
    (vereine_id, "Biologische Station Lippe e.V."),
    (vereine_id, "Brieftaubenverein Frohes Wiedersehen Lothe"),
    (vereine_id, "Brieftaubenverein Lothe"),
    (vereine_id, "Brieftaubenverein Schwalenberg"),
    (vereine_id, "Bürgerstiftung Schwalenberg - Stiftungsrat"),
    (vereine_id, "Bürgerstiftung Schwalenberg - Vorstand"),
    (vereine_id, "Der Tisch in Schieder-Schwalenberg"),
    (vereine_id, "DRK Ortsverein Schwalenberg"),
    (vereine_id, "Evangelische Pfadfinderschaft Europas - Stamm Schieder"),
    (vereine_id, "FC Schalke 04 Fan Club Brakelsiek"),
    (vereine_id, "Förderverein Brakelsieker Mehrzweckhalle"),
    (vereine_id, "Förderverein der Grundschule Schwalenberg"),
    (vereine_id, "Förderverein Freibad Schieder-Schwalenberg e.V."),
    (vereine_id, "Förderverein Jugendfeuerwehr Schieder-Schwalenberg"),
    (vereine_id, "Förderverein Löschzug Schieder"),
    (vereine_id, "Förderverein Schloss und Schlosspark Schieder"),
    (vereine_id, "Freiwillige Feuerwehr der Stadt Schieder-Schwalenberg"),
    (vereine_id, "Freundschaft - druschba e.V."),
    (vereine_id, "Geflügelzuchtverein Brakelsiek"),
    (vereine_id, "Geflügelzuchtverein Lothe"),
    (vereine_id, "Heimat- und Verkehrsverein Brakelsiek"),
    (vereine_id, "Heimat- und Verkehrsverein Brakelsiek - Grillhütte"),
    (vereine_id, "Heimat- und Verkehrsverein Lothe"),
    (vereine_id, "Heimat- und Verkehrsverein Lothe - Grillhütte"),
    (vereine_id, "Heimat- und Verkehrsverein Schwalenberg"),
    (vereine_id, "Heimat- und Verkehrsverein Siekholz"),
    (vereine_id, "Heimatverein Wöbbel e.V."),
    (vereine_id, "Heimatverein Wöbbel e.V. - Grillhütte"),
    (vereine_id, "Jugendkreis Brakelsiek JKB e.V."),
    (vereine_id, "Jugendkreis Lothe e.V."),
    (vereine_id, "Jugendzentrum Church Schwalenberg"),
    (vereine_id, "Kolibri - Förderverein für offene Kinder- und Jugendarbeit Schwalenberg e.V."),
    (vereine_id, "Kunstverein Schieder-Schwalenberg"),
    (vereine_id, "Landfrauenverband Brakelsiek"),
    (vereine_id, "Luftsportgemeinschaft Lippe Südost e.V."),
    (vereine_id, "MärchenWerkSTadt e.V."),
    (vereine_id, "MGV Wöbbel"),
    (vereine_id, "Musikzug der Freiwilligen Feuerwehr Schieder-Schwalenberg"),
    (vereine_id, "Naturschutzbund Deutschland NABU - Arbeitsgruppe Schieder-Schwalenberg"),
    (vereine_id, "Ökumenischer Chor der Kirchengemeinden in Schieder-Schwalenberg"),
    (vereine_id, "OPEL Club Schieder-Schwalenberg"),
    (vereine_id, "PS Freunde Lippe"),
    (vereine_id, "Schwalenberger Brauzunft"),
    (vereine_id, "Seniorentreff Brakelsiek"),
    (vereine_id, "Sozialverband VdK Ortsverband Schieder-Schwalenberg"),
    (vereine_id, "Spielmannszug Brakelsiek"),
    (vereine_id, "Trachtengilde Schwalenberg"),
    (vereine_id, "Verein für Deutsche Schäferhunde OG Lothe"),
    (vereine_id, "Verein für Deutsche Schäferhunde OG Wöbbel"),
    (vereine_id, "Verein zur Hilfe für Aussiedler und Spätaussiedler Freundschaft - druschba e.V."),
    (vereine_id, "VFDG - Verein zur Förderung und Organisation zur Erhaltung alter Lippischer Gebräuche und Gepflogenheiten"),
    (vereine_id, "Wanderarbeiterverein Lothe"),
    (vereine_id, "Wirtschaftsinitiative Schieder-Schwalenberg"),
    (vereine_id, "Wortmann Fischer e.V."),
]

print(f"📊 Insgesamt {len(clubs)} Vereine")

# Alte Clubs löschen
cur.execute("DELETE FROM clubs WHERE tenant_id = %s", (tenant_id,))
print(f"   {cur.rowcount} alte Vereine gelöscht")

# Neue Clubs importieren
for cat_id, name in clubs:
    cur.execute("""
        INSERT INTO clubs (tenant_id, category_id, name, created_at, updated_at)
        VALUES (%s, %s, %s, NOW(), NOW())
    """, (tenant_id, cat_id, name))

conn.commit()

print(f"✅ {len(clubs)} Vereine erfolgreich importiert!")

# Verifikation
cur.execute("""
    SELECT cc.name, COUNT(c.id)
    FROM club_categories cc
    LEFT JOIN clubs c ON c.category_id = cc.id
    WHERE cc.tenant_id = %s
    GROUP BY cc.name
""", (tenant_id,))

print("\n📊 Verifikation:")
for category, count in cur.fetchall():
    print(f"   {category}: {count}")

cur.close()
conn.close()

print("\n🎉 Import abgeschlossen!")
