-- Multi-Tenant Production Seed Data
-- This script creates 2 production tenants: Schieder-Schwalenberg and Barntrup
-- Run this after db:push to populate the database

-- ===== TENANTS =====

INSERT INTO tenants (id, slug, name, domain, "isActive", "primaryColor", "secondaryColor", "logoUrl", "heroImageUrl", "chatbotName", "chatbotSystemPrompt", "weatherLat", "weatherLon", "contactEmail", "contactPhone", "contactAddress", "createdAt") VALUES
-- Schieder-Schwalenberg
('tenant_schieder_001', 'schieder', 'Schieder-Schwalenberg', 'schieder.buergerapp.eu', true, '#0066CC', '#00A86B', '/assets/logo-schieder.png', '/assets/hero-schieder.jpg', 'Schwalenbot', 'Du bist Schwalenbot, der freundliche Chatbot für Schieder-Schwalenberg. Du hilfst Bürgern bei Fragen zur Stadt, Veranstaltungen, Ämtern und Services.', '51.8667', '9.1167', 'info@schieder-schwalenberg.de', '05282 9600', 'Bahnhofstraße 1, 32816 Schieder-Schwalenberg', NOW()),

-- Barntrup
('tenant_barntrup_001', 'barntrup', 'Barntrup', 'barntrup.buergerapp.eu', true, '#006837', '#E30074', '/assets/logo-barntrup.png', '/assets/hero-barntrup.jpg', 'BarntrupBot', 'Du bist BarntrupBot, der digitale Assistent für die Stadt Barntrup. Du hilfst Bürgern bei Fragen zur Stadt, Veranstaltungen, Ämtern und Services.', '51.9833', '9.1167', 'info@barntrup.de', '05263 409-0', 'Mittelstraße 38, 32683 Barntrup', NOW());

-- ===== NEWS =====

-- Schieder News
INSERT INTO news (id, "tenantId", title, content, category, image_url, author, published_at, created_at) VALUES
('news_schieder_001', 'tenant_schieder_001', 'Neues Schwimmbad eröffnet', 'Das modernisierte Freibad Schieder öffnet am 1. Juni seine Pforten. Nach umfangreichen Renovierungsarbeiten erstrahlt das Bad in neuem Glanz. Besucher erwarten ein beheiztes Becken, neue Rutsche und ein moderner Spielplatz.', 'Freizeit', '/assets/news/schwimmbad.jpg', 'Stadtverwaltung', NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
('news_schieder_002', 'tenant_schieder_001', 'Stadtfest 2025 - Save the Date', 'Vom 15. bis 17. August findet das traditionelle Stadtfest statt. Mit Live-Musik, Kunsthandwerkermarkt und kulinarischen Spezialitäten wird für jeden etwas geboten. Der Eintritt ist frei.', 'Veranstaltungen', '/assets/news/stadtfest.jpg', 'Kulturamt', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
('news_schieder_003', 'tenant_schieder_001', 'Digitalisierung der Verwaltung', 'Die Stadt Schieder-Schwalenberg setzt auf moderne Technologie. Ab sofort können viele Anträge online eingereicht werden. Das neue Bürgerportal macht Behördengänge einfacher.', 'Verwaltung', '/assets/news/digitalisierung-schieder.jpg', 'Stadtverwaltung', NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days');

-- Barntrup News
INSERT INTO news (id, "tenantId", title, content, category, image_url, author, published_at, created_at) VALUES
('news_barntrup_001', 'tenant_barntrup_001', 'Regeneratives Barntrup - Klimaschutz aktiv', 'Die Stadt Barntrup setzt auf erneuerbare Energien. Das Projekt "Regeneratives Barntrup" bringt Photovoltaik, Windkraft und nachhaltige Mobilität voran. Bürger können sich aktiv beteiligen.', 'Umwelt', '/assets/news/regenerativ-barntrup.jpg', 'Stadtverwaltung Barntrup', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
('news_barntrup_002', 'tenant_barntrup_001', 'Neue Wasserzählerablesung online', 'Barntrup wird digital! Die Wasserzählerablesung kann jetzt bequem online erfolgen. Einfach auf der Website registrieren und Zählerstände eingeben. Keine Zettel mehr nötig.', 'Verwaltung', '/assets/news/wasserzaehler.jpg', 'Stadtwerke Barntrup', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
('news_barntrup_003', 'tenant_barntrup_001', 'Bürgerinformation verbessert', 'Die Stadt Barntrup hat ihr Informationsangebot ausgebaut. Alle wichtigen Infos zu Verwaltung, Veranstaltungen und Services sind jetzt übersichtlich auf der neuen Website zu finden.', 'Verwaltung', '/assets/news/buergerinfo.jpg', 'Pressestelle Barntrup', NOW() - INTERVAL '6 days', NOW() - INTERVAL '6 days');

-- ===== EVENTS =====

-- Schieder Events
INSERT INTO events (id, "tenantId", title, description, start_date, end_date, location, image_url, category, organizer_name, organizer_contact, registration_url) VALUES
('event_schieder_001', 'tenant_schieder_001', 'Wochenmarkt', 'Frische regionale Produkte jeden Samstag auf dem Marktplatz. Von Obst und Gemüse über Käse bis hin zu Backwaren - hier findet jeder etwas.', NOW() + INTERVAL '2 days', NOW() + INTERVAL '2 days' + INTERVAL '4 hours', 'Marktplatz Schieder', '/assets/events/wochenmarkt.jpg', 'Markt', 'Stadt Schieder-Schwalenberg', 'markt@schieder-schwalenberg.de', NULL),
('event_schieder_002', 'tenant_schieder_001', 'Konzert im Kurpark', 'Das Blasorchester Schieder spielt Klassiker und moderne Stücke. Bei schönem Wetter im Freien, bei Regen im Kurhaus. Eintritt frei, Spenden willkommen.', NOW() + INTERVAL '10 days', NOW() + INTERVAL '10 days' + INTERVAL '2 hours', 'Kurpark Schieder', '/assets/events/konzert.jpg', 'Kultur', 'Blasorchester Schieder', 'info@blasorchester-schieder.de', NULL),
('event_schieder_003', 'tenant_schieder_001', 'Stadtführung Historisches Schieder', 'Entdecken Sie die Geschichte von Schieder-Schwalenberg bei einer geführten Tour durch die Altstadt. Treffpunkt am Schloss.', NOW() + INTERVAL '15 days', NOW() + INTERVAL '15 days' + INTERVAL '2 hours', 'Schloss Schieder', '/assets/events/stadtfuehrung.jpg', 'Kultur', 'Touristinfo Schieder', 'tourist@schieder-schwalenberg.de', 'https://schieder-schwalenberg.de/stadtfuehrung');

-- Barntrup Events
INSERT INTO events (id, "tenantId", title, description, start_date, end_date, location, image_url, category, organizer_name, organizer_contact, registration_url) VALUES
('event_barntrup_001', 'tenant_barntrup_001', 'Wochenmarkt Barntrup', 'Jeden Mittwoch frische Produkte aus der Region. Obst, Gemüse, Fleisch, Käse und mehr direkt vom Erzeuger.', NOW() + INTERVAL '3 days', NOW() + INTERVAL '3 days' + INTERVAL '4 hours', 'Marktplatz Barntrup', '/assets/events/markt-barntrup.jpg', 'Markt', 'Stadt Barntrup', 'info@barntrup.de', NULL),
('event_barntrup_002', 'tenant_barntrup_001', 'Bürgersprechstunde Bürgermeister', 'Bürgermeister Borris Ortmeier steht für Ihre Fragen und Anliegen zur Verfügung. Keine Anmeldung erforderlich.', NOW() + INTERVAL '8 days', NOW() + INTERVAL '8 days' + INTERVAL '2 hours', 'Rathaus Barntrup', '/assets/events/buergersprechstunde.jpg', 'Politik', 'Stadt Barntrup', 'buergermeister@barntrup.de', NULL),
('event_barntrup_003', 'tenant_barntrup_001', 'Klimaschutz-Workshop', 'Wie kann jeder Einzelne zum Klimaschutz beitragen? Workshop mit praktischen Tipps für Haushalt, Mobilität und Konsum.', NOW() + INTERVAL '12 days', NOW() + INTERVAL '12 days' + INTERVAL '3 hours', 'Stadthaus Barntrup', '/assets/events/klimaschutz.jpg', 'Umwelt', 'Regeneratives Barntrup', 'klimaschutz@barntrup.de', 'https://barntrup.de/klimaschutz-workshop');

-- ===== DEPARTMENTS =====

-- Schieder Departments
INSERT INTO departments (id, "tenantId", name, description, contact_person, email, phone, address, opening_hours, website) VALUES
('dept_schieder_001', 'tenant_schieder_001', 'Bürgerbüro', 'Meldewesen, Ausweise, Führungszeugnisse, Beglaubigungen', 'Frau Schmidt', 'buergerbuero@schieder-schwalenberg.de', '05282 9600-10', 'Bahnhofstraße 1, 32816 Schieder-Schwalenberg', 'Mo-Fr 8:00-12:00, Do 14:00-18:00', 'https://schieder-schwalenberg.de/buergerbuero'),
('dept_schieder_002', 'tenant_schieder_001', 'Ordnungsamt', 'Gewerbe, Gaststätten, Veranstaltungen, Fundsachen', 'Herr Müller', 'ordnungsamt@schieder-schwalenberg.de', '05282 9600-20', 'Bahnhofstraße 1, 32816 Schieder-Schwalenberg', 'Mo-Fr 8:00-12:00', 'https://schieder-schwalenberg.de/ordnungsamt'),
('dept_schieder_003', 'tenant_schieder_001', 'Bauamt', 'Baugenehmigungen, Bauberatung, Stadtplanung', 'Herr Weber', 'bauamt@schieder-schwalenberg.de', '05282 9600-30', 'Bahnhofstraße 1, 32816 Schieder-Schwalenberg', 'Mo-Fr 8:00-12:00, Do 14:00-16:00', 'https://schieder-schwalenberg.de/bauamt');

-- Barntrup Departments
INSERT INTO departments (id, "tenantId", name, description, contact_person, email, phone, address, opening_hours, website) VALUES
('dept_barntrup_001', 'tenant_barntrup_001', 'Bürgerbüro', 'Meldewesen, Ausweise, Führungszeugnisse, Beglaubigungen, Terminvergabe', 'Frau Meier', 'buergerbuero@barntrup.de', '05263 409-100', 'Mittelstraße 38, 32683 Barntrup', 'Mo 8:00-12:00 & 13:00-17:00, Di-Mi 8:00-12:00, Do 8:00-12:00 & 13:00-16:00, Fr 8:00-12:00', 'https://barntrup.de/buergerbuero'),
('dept_barntrup_002', 'tenant_barntrup_001', 'Ordnungsamt', 'Gewerbe, Gaststätten, Veranstaltungen, Fundsachen, Mängelmelder', 'Herr Schmidt', 'ordnungsamt@barntrup.de', '05263 409-200', 'Mittelstraße 38, 32683 Barntrup', 'Mo-Fr 8:00-12:00', 'https://barntrup.de/ordnungsamt'),
('dept_barntrup_003', 'tenant_barntrup_001', 'Bauamt', 'Baugenehmigungen, Bauberatung, Stadtplanung', 'Herr Hoffmann', 'bauamt@barntrup.de', '05263 409-300', 'Mittelstraße 38, 32683 Barntrup', 'Mo-Fr 8:00-12:00, Do 14:00-16:00', 'https://barntrup.de/bauamt');

-- ===== MAYOR INFO =====

INSERT INTO mayor_info (id, "tenantId", name, title, bio, image_url, email, phone) VALUES
('mayor_schieder_001', 'tenant_schieder_001', 'Bernd Dumcke', 'Bürgermeister', 'Bernd Dumcke ist seit 2015 Bürgermeister von Schieder-Schwalenberg. Sein Fokus liegt auf nachhaltiger Stadtentwicklung, Tourismus und Digitalisierung der Verwaltung.', '/assets/mayor/dumcke.jpg', 'buergermeister@schieder-schwalenberg.de', '05282 9600-0'),
('mayor_barntrup_001', 'tenant_barntrup_001', 'Borris Ortmeier', 'Bürgermeister', 'Borris Ortmeier ist Bürgermeister der Stadt Barntrup. Er setzt sich für regenerative Energien, Digitalisierung und eine bürgernahe Verwaltung ein.', '/assets/mayor/ortmeier.jpg', 'buergermeister@barntrup.de', '05263 409-100');

-- ===== WASTE SCHEDULE =====

-- Schieder Waste
INSERT INTO waste_schedule (id, "tenantId", waste_type, collection_date, district) VALUES
('waste_schieder_001', 'tenant_schieder_001', 'Restmüll', NOW() + INTERVAL '3 days', 'Zentrum'),
('waste_schieder_002', 'tenant_schieder_001', 'Gelber Sack', NOW() + INTERVAL '5 days', 'Zentrum'),
('waste_schieder_003', 'tenant_schieder_001', 'Papiertonne', NOW() + INTERVAL '10 days', 'Zentrum'),
('waste_schieder_004', 'tenant_schieder_001', 'Biotonne', NOW() + INTERVAL '7 days', 'Zentrum'),
('waste_schieder_005', 'tenant_schieder_001', 'Restmüll', NOW() + INTERVAL '4 days', 'Schwalenberg'),
('waste_schieder_006', 'tenant_schieder_001', 'Gelber Sack', NOW() + INTERVAL '6 days', 'Schwalenberg'),
('waste_schieder_007', 'tenant_schieder_001', 'Papiertonne', NOW() + INTERVAL '11 days', 'Schwalenberg'),
('waste_schieder_008', 'tenant_schieder_001', 'Biotonne', NOW() + INTERVAL '8 days', 'Schwalenberg');

-- Barntrup Waste
INSERT INTO waste_schedule (id, "tenantId", waste_type, collection_date, district) VALUES
('waste_barntrup_001', 'tenant_barntrup_001', 'Restmüll', NOW() + INTERVAL '2 days', 'Zentrum'),
('waste_barntrup_002', 'tenant_barntrup_001', 'Gelber Sack', NOW() + INTERVAL '4 days', 'Zentrum'),
('waste_barntrup_003', 'tenant_barntrup_001', 'Papiertonne', NOW() + INTERVAL '9 days', 'Zentrum'),
('waste_barntrup_004', 'tenant_barntrup_001', 'Biotonne', NOW() + INTERVAL '6 days', 'Zentrum'),
('waste_barntrup_005', 'tenant_barntrup_001', 'Restmüll', NOW() + INTERVAL '3 days', 'Sonneborn'),
('waste_barntrup_006', 'tenant_barntrup_001', 'Gelber Sack', NOW() + INTERVAL '5 days', 'Sonneborn'),
('waste_barntrup_007', 'tenant_barntrup_001', 'Papiertonne', NOW() + INTERVAL '10 days', 'Sonneborn'),
('waste_barntrup_008', 'tenant_barntrup_001', 'Biotonne', NOW() + INTERVAL '7 days', 'Sonneborn');

-- ===== ALERTS =====

-- Schieder Alerts
INSERT INTO alerts (id, "tenantId", title, message, severity, category, "isActive", created_at) VALUES
('alert_schieder_001', 'tenant_schieder_001', 'Baustelle Hauptstraße', 'Aufgrund von Bauarbeiten ist die Hauptstraße zwischen Rathaus und Sparkasse bis 30.06. gesperrt. Bitte nutzen Sie die Umleitung über die Schulstraße.', 'warning', 'Verkehr', true, NOW());

-- Barntrup Alerts
INSERT INTO alerts (id, "tenantId", title, message, severity, category, "isActive", created_at) VALUES
('alert_barntrup_001', 'tenant_barntrup_001', 'Wasserzählerablesung läuft', 'Bitte denken Sie an die Wasserzählerablesung bis Ende des Monats. Online-Eingabe unter barntrup.de/wasserzaehler möglich.', 'info', 'Verwaltung', true, NOW());

-- ===== POIS (Points of Interest) =====

-- Schieder POIs
INSERT INTO pois (id, "tenantId", name, description, category, latitude, longitude, address, image_url, website) VALUES
('poi_schieder_001', 'tenant_schieder_001', 'Schloss Schieder', 'Historisches Wasserschloss aus dem 16. Jahrhundert mit Museum und Café', 'Sehenswürdigkeit', 51.8689, 9.1234, 'Schlossstraße 10, 32816 Schieder-Schwalenberg', '/assets/pois/schloss.jpg', 'https://schloss-schieder.de'),
('poi_schieder_002', 'tenant_schieder_001', 'Kurpark', 'Gepflegter Park mit Teich, Spielplatz und Kurhaus', 'Freizeit', 51.8650, 9.1150, 'Parkstraße, 32816 Schieder-Schwalenberg', '/assets/pois/kurpark.jpg', NULL),
('poi_schieder_003', 'tenant_schieder_001', 'Freibad Schieder', 'Modernes Freibad mit beheiztem Becken und Rutsche', 'Freizeit', 51.8670, 9.1180, 'Schwimmbadstraße 5, 32816 Schieder-Schwalenberg', '/assets/pois/freibad.jpg', NULL);

-- Barntrup POIs
INSERT INTO pois (id, "tenantId", name, description, category, latitude, longitude, address, image_url, website) VALUES
('poi_barntrup_001', 'tenant_barntrup_001', 'Rathaus Barntrup', 'Historisches Rathaus im Zentrum der Stadt', 'Verwaltung', 51.9833, 9.1167, 'Mittelstraße 38, 32683 Barntrup', '/assets/pois/rathaus-barntrup.jpg', 'https://barntrup.de'),
('poi_barntrup_002', 'tenant_barntrup_001', 'Emmerauenpark', 'Naturerlebnis am Fluss Emmer mit Wanderwegen', 'Freizeit', 51.9800, 9.1200, 'Am Emmerauenpark, 32683 Barntrup', '/assets/pois/emmerauenpark.jpg', NULL),
('poi_barntrup_003', 'tenant_barntrup_001', 'Stadtpark Barntrup', 'Grüne Oase mitten in der Stadt mit Spielplatz', 'Freizeit', 51.9840, 9.1180, 'Parkstraße, 32683 Barntrup', '/assets/pois/stadtpark.jpg', NULL);

-- ===== INSTITUTIONS =====

-- Schieder Institutions
INSERT INTO institutions (id, "tenantId", name, category, description, address, phone, email, website) VALUES
('inst_schieder_001', 'tenant_schieder_001', 'Grundschule Schieder', 'Bildung', 'Städtische Grundschule mit offenem Ganztag', 'Schulstraße 12, 32816 Schieder-Schwalenberg', '05282 1234', 'grundschule@schieder.de', 'https://grundschule-schieder.de'),
('inst_schieder_002', 'tenant_schieder_001', 'Stadtbücherei', 'Bildung', 'Öffentliche Bücherei mit großer Medienauswahl', 'Bahnhofstraße 3, 32816 Schieder-Schwalenberg', '05282 5678', 'buecherei@schieder-schwalenberg.de', NULL);

-- Barntrup Institutions
INSERT INTO institutions (id, "tenantId", name, category, description, address, phone, email, website) VALUES
('inst_barntrup_001', 'tenant_barntrup_001', 'Grundschule Barntrup', 'Bildung', 'Städtische Grundschule mit Betreuungsangebot', 'Schulstraße 5, 32683 Barntrup', '05263 2345', 'grundschule@barntrup.de', 'https://grundschule-barntrup.de'),
('inst_barntrup_002', 'tenant_barntrup_001', 'Stadtbücherei Barntrup', 'Bildung', 'Öffentliche Bibliothek mit Medien und Veranstaltungen', 'Mittelstraße 20, 32683 Barntrup', '05263 3456', 'buecherei@barntrup.de', 'https://buecherei.barntrup.de');

-- ===== CLUBS =====

-- Schieder Clubs
INSERT INTO clubs (id, "tenantId", name, description, category, contact_person, email, phone, website) VALUES
('club_schieder_001', 'tenant_schieder_001', 'SV Schieder 1920', 'Sportverein mit Fußball, Tennis und Turnen', 'Sport', 'Hans Meier', 'info@sv-schieder.de', '05282 5678', 'https://sv-schieder.de'),
('club_schieder_002', 'tenant_schieder_001', 'Schützenverein Schieder', 'Traditionsreicher Schützenverein mit Schützenfest', 'Tradition', 'Klaus Müller', 'info@schuetzen-schieder.de', '05282 6789', 'https://schuetzen-schieder.de');

-- Barntrup Clubs
INSERT INTO clubs (id, "tenantId", name, description, category, contact_person, email, phone, website) VALUES
('club_barntrup_001', 'tenant_barntrup_001', 'TuS Barntrup', 'Turn- und Sportverein mit vielfältigem Angebot', 'Sport', 'Michael Weber', 'info@tus-barntrup.de', '05263 4567', 'https://tus-barntrup.de'),
('club_barntrup_002', 'tenant_barntrup_001', 'Schützenverein Barntrup', 'Schützenverein mit Tradition und Schützenfest', 'Tradition', 'Peter Schmidt', 'info@schuetzen-barntrup.de', '05263 5678', 'https://schuetzen-barntrup.de');

-- ===== COUNCIL MEETINGS =====

-- Schieder Council
INSERT INTO council_meetings (id, "tenantId", title, meeting_date, location, agenda_url, minutes_url) VALUES
('council_schieder_001', 'tenant_schieder_001', 'Ratssitzung Juni 2025', NOW() + INTERVAL '20 days', 'Rathaus Schieder, Ratssaal', 'https://schieder-schwalenberg.de/rat/agenda-juni.pdf', NULL),
('council_schieder_002', 'tenant_schieder_001', 'Ausschuss Bau und Planung', NOW() + INTERVAL '15 days', 'Rathaus Schieder, Sitzungsraum 1', 'https://schieder-schwalenberg.de/rat/agenda-bau-mai.pdf', NULL);

-- Barntrup Council
INSERT INTO council_meetings (id, "tenantId", title, meeting_date, location, agenda_url, minutes_url) VALUES
('council_barntrup_001', 'tenant_barntrup_001', 'Ratssitzung Juli 2025', NOW() + INTERVAL '25 days', 'Rathaus Barntrup, Ratssaal', 'https://barntrup.de/rat/agenda-juli.pdf', NULL),
('council_barntrup_002', 'tenant_barntrup_001', 'Ausschuss Umwelt und Klimaschutz', NOW() + INTERVAL '18 days', 'Rathaus Barntrup, Sitzungsraum 2', 'https://barntrup.de/rat/agenda-umwelt-juni.pdf', NULL);

-- ===== DONE =====

SELECT 'Production seed data inserted successfully!' AS status;
SELECT 'Tenants created: Schieder-Schwalenberg, Barntrup' AS info;
SELECT 'Ready for buergerapp.eu deployment' AS deployment;
