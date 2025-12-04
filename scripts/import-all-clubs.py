#!/usr/bin/env python3
"""
Import aller 86 Vereine von der Website
Kategorisiert in: Sportvereine und Vereine
"""

import psycopg2
import json

# Datenbank-Verbindung
conn = psycopg2.connect(
    host="localhost",
    database="buergerapp",
    user="buergerapp_user",
    password="buergerapp_dev_2025"
)

# Alle 86 Vereine (manuell aus Website extrahiert)
clubs_data = [
    # Sportvereine
    {"name": "1. Pyrmonter Segel- und Wassersportclub e.V.", "category": "Sportvereine", "contact": "Wolfgang Niederhöfer"},
    {"name": "DLRG Ortsgruppe Schieder-Schwalenberg", "category": "Sportvereine", "contact": "Bodo Schultz"},
    {"name": "Schießsportverein Lothe", "category": "Sportvereine", "contact": "Meik Waldvogt"},
    {"name": "Schützengesellschaft Lothe", "category": "Sportvereine", "contact": ""},
    {"name": "Schützengesellschaft Schwalenberg", "category": "Sportvereine", "contact": "Sven Ridder"},
    {"name": "Schützengruppe Siekholz", "category": "Sportvereine", "contact": "Werner Ridder"},
    {"name": "Schützenverein Siekholz", "category": "Sportvereine", "contact": "Niko Nikolakoudis"},
    {"name": "Tennisclub Schieder-Schwalenberg", "category": "Sportvereine", "contact": "Stephan Müller"},
    {"name": "TG Siekholz", "category": "Sportvereine", "contact": "Martin Schulz"},
    {"name": "TSV Lothe", "category": "Sportvereine", "contact": "Rolf Unglaube"},
    {"name": "TuS Wöbbel", "category": "Sportvereine", "contact": "Christian Hansmann"},
    {"name": "Stadtsportverband", "category": "Sportvereine", "contact": "Stephan Müller"},
    {"name": "TuS 08 Brakelsiek", "category": "Sportvereine", "contact": "Hartmut Tewesmeier"},
    {"name": "TuS Schieder-Schwalenberg", "category": "Sportvereine", "contact": "Kerstin Monsehr"},
    
    # Vereine (alle anderen)
    {"name": "Angelsportverein Schieder", "category": "Vereine", "contact": "Marc Beckmeier"},
    {"name": "Angelsportverein Schieder Glashütte", "category": "Vereine", "contact": "Rinat Schwarzkopf"},
    {"name": "Ankerplatz - Offene Jugendarbeit der ev.-ref. KG Wöbbel, Belle und Billerbeck", "category": "Vereine", "contact": "Maike Derstvensek"},
    {"name": "OPEL Club Schieder-Schwalenberg", "category": "Vereine", "contact": "Sascha Schröder"},
    {"name": "PS Freunde Lippe", "category": "Vereine", "contact": "Stefan Hilkemeier"},
    {"name": "Schwalenberger Brauzunft", "category": "Vereine", "contact": ""},
    {"name": "Trachtengilde Schwalenberg", "category": "Vereine", "contact": "André Eikermann"},
    {"name": "VFDG - Verein zur Förderung und Organisation zur Erhaltung alter Lippischer Gebräuche und Gepflogenheiten", "category": "Vereine", "contact": "Frank Wiehemeier"},
    {"name": "Wanderarbeiterverein Lothe", "category": "Vereine", "contact": "Jürgen Rogat"},
    {"name": "MGV Wöbbel", "category": "Vereine", "contact": "Ludolf Beermann"},
    {"name": "Musikzug der Freiwilligen Feuerwehr Schieder-Schwalenberg", "category": "Vereine", "contact": "Heinz-Jürgen Bolte"},
    {"name": "Ökumenischer Chor der Kirchengemeinden in Schieder-Schwalenberg", "category": "Vereine", "contact": "Guido Theis"},
    {"name": "Spielmannszug Brakelsiek", "category": "Vereine", "contact": "Larissa Wienke"},
    {"name": "FC Schalke 04 Fan Club Brakelsiek", "category": "Vereine", "contact": "Peter Meinberg"},
    {"name": "Förderverein der Grundschule Schwalenberg", "category": "Vereine", "contact": "Fabienne Schweizer"},
    {"name": "Förderverein der Brakelsieker Mehrzweckhalle", "category": "Vereine", "contact": "Wolfgang Ridder"},
    {"name": "Bürgerstiftung Schwalenberg", "category": "Vereine", "contact": "Marcus Rohde / Friedrich Schierholz"},
    {"name": "Förderverein Jugendfeuerwehr Schieder-Schwalenberg", "category": "Vereine", "contact": "Marco Tölle"},
    {"name": "Förderverein Löschzug Schieder der Freiwilligen Feuerwehr", "category": "Vereine", "contact": "Heinz-Günter Ermer"},
    {"name": "Förderverein Schloss und Schlosspark Schieder", "category": "Vereine", "contact": "Detlev Hundt"},
    {"name": "Freiwillige Feuerwehr der Stadt Schieder-Schwalenberg", "category": "Vereine", "contact": "Mike Mundhenke"},
    {"name": "Brieftaubenverein Frohes Wiedersehen Lothe", "category": "Vereine", "contact": "Ralf Holtkamp"},
    {"name": "Geflügelzuchtverein Brakelsiek", "category": "Vereine", "contact": "Dirk Vogel"},
    {"name": "Geflügelzuchtverein Lothe", "category": "Vereine", "contact": "Mathias Fiene"},
    {"name": "Heimat- und Verkehrsverein Brakelsiek", "category": "Vereine", "contact": "Dirk Steinmeier"},
    {"name": "Heimat- und Verkehrsverein Lothe", "category": "Vereine", "contact": "Walter Deppenmeier / Dorothee Klein"},
    {"name": "Heimat- und Verkehrsverein Schwalenberg", "category": "Vereine", "contact": "Jens Rheker"},
    {"name": "Heimat- und Verkehrsverein Siekholz", "category": "Vereine", "contact": "Petra Beuchler"},
    {"name": "Heimatverein Wöbbel e.V.", "category": "Vereine", "contact": "Susanne Post"},
    {"name": "Jugendkreis Brakelsiek JKB e.V.", "category": "Vereine", "contact": "Philipp Schüsler"},
    {"name": "Jugendkreis Lothe e.V.", "category": "Vereine", "contact": "Janina Fiene"},
    {"name": "Jugendzentrum Church Schwalenberg", "category": "Vereine", "contact": "Astrid Pyttlik"},
    {"name": "Kolibri - Förderverein für offene Kinder- und Jugendarbeit Schwalenberg e.V.", "category": "Vereine", "contact": "Ingo Gierschner"},
    {"name": "Kunstverein Schieder-Schwalenberg", "category": "Vereine", "contact": ""},
    {"name": "Luftsportgemeinschaft Lippe Südost e.V.", "category": "Vereine", "contact": "Henning Stoffels-Korndorf"},
    {"name": "MärchenWerkSTadt e.V.", "category": "Vereine", "contact": "Marion Weber"},
    {"name": "Biologische Station Lippe e.V.", "category": "Vereine", "contact": "Matthias Füller"},
    {"name": "Naturschutzbund Deutschland NABU - Arbeitsgruppe Schieder-Schwalenberg", "category": "Vereine", "contact": "Erich Benning"},
    {"name": "Seniorentreff Brakelsiek", "category": "Vereine", "contact": "Petra Flader"},
    {"name": "Der Tisch in Schieder-Schwalenberg", "category": "Vereine", "contact": ""},
    {"name": "DRK Ortsverein Schwalenberg", "category": "Vereine", "contact": "Hannelore Kreylos"},
    {"name": "Evangelische Pfadfinderschaft Europas - Stamm Schieder", "category": "Vereine", "contact": "Michale Rostig"},
    {"name": "Sozialverband VdK Ortsverband Schieder-Schwalenberg", "category": "Vereine", "contact": "Almuth Höcker"},
    {"name": "Verein zur Hilfe für Aussiedler und Spätaussiedler \"Freundschaft - druschba\" e.V.", "category": "Vereine", "contact": ""},
    {"name": "Brieftaubenverein Lothe", "category": "Vereine", "contact": "Ralf Holtkamp"},
    {"name": "Brieftaubenverein Schwalenberg", "category": "Vereine", "contact": "Ludger Hermanns"},
    {"name": "Förderverein Freibad Schieder-Schwalenberg e.V.", "category": "Vereine", "contact": "Dagmar Schultz"},
    {"name": "Verein für Deutsche Schäferhunde OG Lothe", "category": "Vereine", "contact": "Jürgen Koch"},
    {"name": "Verein für Deutsche Schäferhunde OG Wöbbel", "category": "Vereine", "contact": "Stefan Bierwirth"},
    {"name": "Landfrauenverband Brakelsiek", "category": "Vereine", "contact": "Ellen Nesemeier"},
    {"name": "Wirtschaftsinitiative Schieder-Schwalenberg", "category": "Vereine", "contact": "Sabine Eichmann van der Heyden"},
    {"name": "Wortmann Fischer e.V.", "category": "Vereine", "contact": "Heinz-Werner Schlicht"},
]

print(f"📊 Insgesamt {len(clubs_data)} Vereine gefunden")

# Zähle Kategorien
sport_count = sum(1 for club in clubs_data if club["category"] == "Sportvereine")
other_count = sum(1 for club in clubs_data if club["category"] == "Vereine")

print(f"  - Sportvereine: {sport_count}")
print(f"  - Vereine: {other_count}")

# Tenant-ID ermitteln
cur = conn.cursor()
cur.execute("SELECT id FROM tenants WHERE slug = 'schieder'")
tenant_result = cur.fetchone()

if not tenant_result:
    print("❌ Tenant 'schieder' nicht gefunden!")
    exit(1)

tenant_id = tenant_result[0]
print(f"✅ Tenant ID: {tenant_id}")

# Alte Clubs löschen
print("\n🗑️  Lösche alte Vereine...")
cur.execute("DELETE FROM clubs WHERE tenant_id = %s", (tenant_id,))
deleted_count = cur.rowcount
print(f"   {deleted_count} alte Vereine gelöscht")

# Neue Clubs importieren
print("\n📥 Importiere neue Vereine...")
imported_count = 0

for club in clubs_data:
    try:
        cur.execute("""
            INSERT INTO clubs (tenant_id, name, category, contact_person, created_at, updated_at)
            VALUES (%s, %s, %s, %s, NOW(), NOW())
        """, (tenant_id, club["name"], club["category"], club["contact"]))
        imported_count += 1
    except Exception as e:
        print(f"❌ Fehler beim Importieren von '{club['name']}': {e}")

conn.commit()

print(f"\n✅ {imported_count} Vereine erfolgreich importiert!")

# Verifikation
cur.execute("SELECT category, COUNT(*) FROM clubs WHERE tenant_id = %s GROUP BY category", (tenant_id,))
results = cur.fetchall()

print("\n📊 Verifikation:")
for category, count in results:
    print(f"   {category}: {count}")

cur.close()
conn.close()

print("\n🎉 Import abgeschlossen!")
