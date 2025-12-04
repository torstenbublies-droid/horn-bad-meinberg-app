-- Multi-Tenant Seed Data
-- This script creates 2 test tenants with sample data
-- Run this after db:push to populate the database

-- ===== TENANTS =====

INSERT INTO tenants (id, slug, name, domain, is_active, primary_color, secondary_color, logo_url, hero_image_url, chatbot_name, chatbot_system_prompt, weather_lat, weather_lon, contact_email, contact_phone, contact_address, created_at) VALUES
-- Schieder-Schwalenberg (Original)
('tenant_schieder_001', 'schieder', 'Schieder-Schwalenberg', 'schieder.buerger-app.de', true, '#0066CC', '#00A86B', '/assets/logo-schieder.png', '/assets/hero-schieder.jpg', 'Schwalenbot', 'Du bist Schwalenbot, der freundliche Chatbot für Schieder-Schwalenberg. Du hilfst Bürgern bei Fragen zur Stadt, Veranstaltungen, Ämtern und Services.', '51.8667', '9.1167', 'info@schieder-schwalenberg.de', '05282 9600', 'Bahnhofstraße 1, 32816 Schieder-Schwalenberg', NOW()),

-- Musterstadt (Test)
('tenant_musterstadt_001', 'musterstadt', 'Musterstadt', 'musterstadt.buerger-app.de', true, '#E91E63', '#FF9800', '/assets/logo-musterstadt.png', '/assets/hero-musterstadt.jpg', 'MusterBot', 'Du bist MusterBot, der digitale Assistent für Musterstadt. Du beantwortest Fragen zu städtischen Services, Veranstaltungen und Einrichtungen.', '50.1109', '8.6821', 'info@musterstadt.de', '069 123456', 'Hauptstraße 1, 60311 Musterstadt', NOW());

-- ===== NEWS =====

-- Schieder News
INSERT INTO news (id, tenant_id, title, content, category, image_url, author, published_at, created_at) VALUES
('news_schieder_001', 'tenant_schieder_001', 'Neues Schwimmbad eröffnet', 'Das modernisierte Freibad Schieder öffnet am 1. Juni seine Pforten. Nach umfangreichen Renovierungsarbeiten erstrahlt das Bad in neuem Glanz. Besucher erwarten ein beheiztes Becken, neue Rutsche und ein moderner Spielplatz.', 'Freizeit', '/assets/news/schwimmbad.jpg', 'Stadtverwaltung', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
('news_schieder_002', 'tenant_schieder_001', 'Stadtfest 2025 - Save the Date', 'Vom 15. bis 17. August findet das traditionelle Stadtfest statt. Mit Live-Musik, Kunsthandwerkermarkt und kulinarischen Spezialitäten wird für jeden etwas geboten. Der Eintritt ist frei.', 'Veranstaltungen', '/assets/news/stadtfest.jpg', 'Kulturamt', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days');

-- Musterstadt News
INSERT INTO news (id, tenant_id, title, content, category, image_url, author, published_at, created_at) VALUES
('news_musterstadt_001', 'tenant_musterstadt_001', 'Digitalisierung schreitet voran', 'Musterstadt wird smart! Ab sofort können Bürger viele Anträge online einreichen. Das neue Bürgerportal macht es möglich. Termine beim Bürgerbüro können ebenfalls digital gebucht werden.', 'Verwaltung', '/assets/news/digitalisierung.jpg', 'Bürgermeisteramt', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
('news_musterstadt_002', 'tenant_musterstadt_001', 'Neuer Radweg eingeweiht', 'Der neue Radweg entlang der Hauptstraße wurde heute offiziell eröffnet. Die 3 km lange Strecke verbindet Innenstadt und Gewerbegebiet sicher für Radfahrer. Weitere Ausbaustufen sind geplant.', 'Infrastruktur', '/assets/news/radweg.jpg', 'Tiefbauamt', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days');

-- ===== EVENTS =====

-- Schieder Events
INSERT INTO events (id, tenant_id, title, description, start_date, end_date, location, image_url, category, organizer_name, organizer_contact, registration_url) VALUES
('event_schieder_001', 'tenant_schieder_001', 'Wochenmarkt', 'Frische regionale Produkte jeden Samstag auf dem Marktplatz. Von Obst und Gemüse über Käse bis hin zu Backwaren - hier findet jeder etwas.', NOW() + INTERVAL '2 days', NOW() + INTERVAL '2 days' + INTERVAL '4 hours', 'Marktplatz Schieder', '/assets/events/wochenmarkt.jpg', 'Markt', 'Stadt Schieder-Schwalenberg', 'markt@schieder-schwalenberg.de', NULL),
('event_schieder_002', 'tenant_schieder_001', 'Konzert im Kurpark', 'Das Blasorchester Schieder spielt Klassiker und moderne Stücke. Bei schönem Wetter im Freien, bei Regen im Kurhaus. Eintritt frei, Spenden willkommen.', NOW() + INTERVAL '10 days', NOW() + INTERVAL '10 days' + INTERVAL '2 hours', 'Kurpark Schieder', '/assets/events/konzert.jpg', 'Kultur', 'Blasorchester Schieder', 'info@blasorchester-schieder.de', NULL);

-- Musterstadt Events
INSERT INTO events (id, tenant_id, title, description, start_date, end_date, location, image_url, category, organizer_name, organizer_contact, registration_url) VALUES
('event_musterstadt_001', 'tenant_musterstadt_001', 'Bürgerdialog Klimaschutz', 'Wie wird Musterstadt klimaneutral? Diskutieren Sie mit Experten und der Stadtverwaltung über Maßnahmen und Ziele. Ihre Meinung zählt!', NOW() + INTERVAL '7 days', NOW() + INTERVAL '7 days' + INTERVAL '3 hours', 'Rathaus Musterstadt, Großer Saal', '/assets/events/buergerdialog.jpg', 'Politik', 'Umweltamt Musterstadt', 'umwelt@musterstadt.de', 'https://musterstadt.de/anmeldung-buergerdialog');

-- ===== DEPARTMENTS =====

-- Schieder Departments
INSERT INTO departments (id, tenant_id, name, description, contact_person, email, phone, address, opening_hours, website) VALUES
('dept_schieder_001', 'tenant_schieder_001', 'Bürgerbüro', 'Meldewesen, Ausweise, Führungszeugnisse, Beglaubigungen', 'Frau Schmidt', 'buergerbuero@schieder-schwalenberg.de', '05282 9600-10', 'Bahnhofstraße 1, 32816 Schieder-Schwalenberg', 'Mo-Fr 8:00-12:00, Do 14:00-18:00', 'https://schieder-schwalenberg.de/buergerbuero'),
('dept_schieder_002', 'tenant_schieder_001', 'Ordnungsamt', 'Gewerbe, Gaststätten, Veranstaltungen, Fundsachen', 'Herr Müller', 'ordnungsamt@schieder-schwalenberg.de', '05282 9600-20', 'Bahnhofstraße 1, 32816 Schieder-Schwalenberg', 'Mo-Fr 8:00-12:00', 'https://schieder-schwalenberg.de/ordnungsamt');

-- Musterstadt Departments
INSERT INTO departments (id, tenant_id, name, description, contact_person, email, phone, address, opening_hours, website) VALUES
('dept_musterstadt_001', 'tenant_musterstadt_001', 'Bürgerservice', 'Alle Anliegen rund um Meldewesen, Dokumente und Anträge', 'Herr Weber', 'service@musterstadt.de', '069 123456-100', 'Hauptstraße 1, 60311 Musterstadt', 'Mo-Fr 8:00-16:00, Sa 9:00-12:00', 'https://musterstadt.de/buergerservice');

-- ===== MAYOR INFO =====

INSERT INTO mayor_info (id, tenant_id, name, title, bio, image_url, email, phone) VALUES
('mayor_schieder_001', 'tenant_schieder_001', 'Bernd Dumcke', 'Bürgermeister', 'Bernd Dumcke ist seit 2015 Bürgermeister von Schieder-Schwalenberg. Sein Fokus liegt auf nachhaltiger Stadtentwicklung, Tourismus und Digitalisierung der Verwaltung.', '/assets/mayor/dumcke.jpg', 'buergermeister@schieder-schwalenberg.de', '05282 9600-0'),
('mayor_musterstadt_001', 'tenant_musterstadt_001', 'Dr. Anna Müller', 'Bürgermeisterin', 'Dr. Anna Müller leitet seit 2020 die Geschicke von Musterstadt. Ihre Schwerpunkte sind Klimaschutz, Mobilität und soziale Gerechtigkeit.', '/assets/mayor/mueller.jpg', 'buergermeisterin@musterstadt.de', '069 123456-1');

-- ===== WASTE SCHEDULE =====

-- Schieder Waste
INSERT INTO waste_schedule (id, tenant_id, waste_type, collection_date, district) VALUES
('waste_schieder_001', 'tenant_schieder_001', 'Restmüll', NOW() + INTERVAL '3 days', 'Zentrum'),
('waste_schieder_002', 'tenant_schieder_001', 'Gelber Sack', NOW() + INTERVAL '5 days', 'Zentrum'),
('waste_schieder_003', 'tenant_schieder_001', 'Papiertonne', NOW() + INTERVAL '10 days', 'Zentrum'),
('waste_schieder_004', 'tenant_schieder_001', 'Biotonne', NOW() + INTERVAL '7 days', 'Zentrum');

-- Musterstadt Waste
INSERT INTO waste_schedule (id, tenant_id, waste_type, collection_date, district) VALUES
('waste_musterstadt_001', 'tenant_musterstadt_001', 'Restmüll', NOW() + INTERVAL '2 days', 'Innenstadt'),
('waste_musterstadt_002', 'tenant_musterstadt_001', 'Gelber Sack', NOW() + INTERVAL '4 days', 'Innenstadt'),
('waste_musterstadt_003', 'tenant_musterstadt_001', 'Papiertonne', NOW() + INTERVAL '9 days', 'Innenstadt');

-- ===== ALERTS =====

-- Schieder Alerts
INSERT INTO alerts (id, tenant_id, title, message, severity, category, is_active, created_at) VALUES
('alert_schieder_001', 'tenant_schieder_001', 'Baustelle Hauptstraße', 'Aufgrund von Bauarbeiten ist die Hauptstraße zwischen Rathaus und Sparkasse bis 30.06. gesperrt. Bitte nutzen Sie die Umleitung über die Schulstraße.', 'warning', 'Verkehr', true, NOW());

-- Musterstadt Alerts
INSERT INTO alerts (id, tenant_id, title, message, severity, category, is_active, created_at) VALUES
('alert_musterstadt_001', 'tenant_musterstadt_001', 'Hitzewarnung', 'Der Deutsche Wetterdienst warnt vor extremer Hitze. Bitte vermeiden Sie körperliche Anstrengung und trinken Sie ausreichend Wasser.', 'critical', 'Wetter', true, NOW());

-- ===== POIS (Points of Interest) =====

-- Schieder POIs
INSERT INTO pois (id, tenant_id, name, description, category, latitude, longitude, address, image_url, website) VALUES
('poi_schieder_001', 'tenant_schieder_001', 'Schloss Schieder', 'Historisches Wasserschloss aus dem 16. Jahrhundert mit Museum und Café', 'Sehenswürdigkeit', 51.8689, 9.1234, 'Schlossstraße 10, 32816 Schieder-Schwalenberg', '/assets/pois/schloss.jpg', 'https://schloss-schieder.de'),
('poi_schieder_002', 'tenant_schieder_001', 'Kurpark', 'Gepflegter Park mit Teich, Spielplatz und Kurhaus', 'Freizeit', 51.8650, 9.1150, 'Parkstraße, 32816 Schieder-Schwalenberg', '/assets/pois/kurpark.jpg', NULL);

-- Musterstadt POIs
INSERT INTO pois (id, tenant_id, name, description, category, latitude, longitude, address, image_url, website) VALUES
('poi_musterstadt_001', 'tenant_musterstadt_001', 'Stadtmuseum', 'Geschichte von Musterstadt vom Mittelalter bis heute', 'Kultur', 50.1120, 8.6830, 'Museumsgasse 5, 60311 Musterstadt', '/assets/pois/museum.jpg', 'https://museum.musterstadt.de');

-- ===== INSTITUTIONS =====

-- Schieder Institutions
INSERT INTO institutions (id, tenant_id, name, category, description, address, phone, email, website) VALUES
('inst_schieder_001', 'tenant_schieder_001', 'Grundschule Schieder', 'Bildung', 'Städtische Grundschule mit offenem Ganztag', 'Schulstraße 12, 32816 Schieder-Schwalenberg', '05282 1234', 'grundschule@schieder.de', 'https://grundschule-schieder.de');

-- Musterstadt Institutions
INSERT INTO institutions (id, tenant_id, name, category, description, address, phone, email, website) VALUES
('inst_musterstadt_001', 'tenant_musterstadt_001', 'Stadtbibliothek', 'Bildung', 'Öffentliche Bibliothek mit über 50.000 Medien', 'Bücherstraße 3, 60311 Musterstadt', '069 123456-200', 'bibliothek@musterstadt.de', 'https://bibliothek.musterstadt.de');

-- ===== CLUBS =====

-- Schieder Clubs
INSERT INTO clubs (id, tenant_id, name, description, category, contact_person, email, phone, website) VALUES
('club_schieder_001', 'tenant_schieder_001', 'SV Schieder 1920', 'Sportverein mit Fußball, Tennis und Turnen', 'Sport', 'Hans Meier', 'info@sv-schieder.de', '05282 5678', 'https://sv-schieder.de');

-- Musterstadt Clubs
INSERT INTO clubs (id, tenant_id, name, description, category, contact_person, email, phone, website) VALUES
('club_musterstadt_001', 'tenant_musterstadt_001', 'Gesangverein Harmonie', 'Traditionsreicher Chor mit 80 Mitgliedern', 'Kultur', 'Maria Schmidt', 'info@harmonie-musterstadt.de', '069 987654', 'https://harmonie-musterstadt.de');

-- ===== COUNCIL MEETINGS =====

-- Schieder Council
INSERT INTO council_meetings (id, tenant_id, title, meeting_date, location, agenda_url, minutes_url) VALUES
('council_schieder_001', 'tenant_schieder_001', 'Ratssitzung Juni 2025', NOW() + INTERVAL '20 days', 'Rathaus Schieder, Ratssaal', 'https://schieder-schwalenberg.de/rat/agenda-juni.pdf', NULL);

-- Musterstadt Council
INSERT INTO council_meetings (id, tenant_id, title, meeting_date, location, agenda_url, minutes_url) VALUES
('council_musterstadt_001', 'tenant_musterstadt_001', 'Stadtrat Juli 2025', NOW() + INTERVAL '25 days', 'Rathaus Musterstadt, Sitzungssaal 1', 'https://musterstadt.de/rat/agenda-juli.pdf', NULL);

-- ===== DONE =====

SELECT 'Multi-Tenant seed data inserted successfully!' AS status;
SELECT 'Tenants created: Schieder-Schwalenberg, Musterstadt' AS info;
