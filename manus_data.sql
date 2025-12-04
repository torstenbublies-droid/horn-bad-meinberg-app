--
-- PostgreSQL database dump
--

\restrict iklwKTcLVph9OsmqO5HZMYvgdd01TsxEJ1DcSphTQJKl9Y9irKChr87fQwNWvJs

-- Dumped from database version 14.19 (Ubuntu 14.19-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.19 (Ubuntu 14.19-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: tenants; Type: TABLE DATA; Schema: public; Owner: buergerapp_user
--

INSERT INTO public.tenants VALUES ('tenant_barntrup_001', 'Barntrup', 'barntrup', 'barntrup.buergerapp.eu', '#A51890', '#E30074', '/assets/logo-barntrup.png', '/assets/hero-barntrup.webp', 'info@barntrup.de', '05263 409-0', 'Mittelstraße 38, 32683 Barntrup', '51.9833', '9.1167', NULL, 'Barntrupbot', 'Du bist Barntrupbot, der freundliche Chatbot für Barntrup. Du hilfst Bürgern bei Fragen zur Stadt, Veranstaltungen, Ämtern und Services.', NULL, true, '2025-11-22 04:18:35.111595', '2025-11-22 04:18:35.111595', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.tenants VALUES ('tenant_schieder_001', 'Schieder-Schwalenberg', 'schieder', 'schieder.buergerapp.eu', '#0066CC', '#00A86B', '/assets/logo-schieder.png', '/assets/hero-schieder.jpg', 'info@schieder-schwalenberg.de', '05282 / 601-0', 'Domäne 3, 32816 Schieder-Schwalenberg', '51.8667', '9.1167', NULL, 'Schwalenbot', 'Du bist Schwalenbot, der freundliche Chatbot für Schieder-Schwalenberg. Du hilfst Bürgern bei Fragen zur Stadt, Veranstaltungen, Ämtern und Services.', NULL, true, '2025-11-22 04:18:35.111595', '2025-11-22 04:18:35.111595', 'Marco Müllers', 'm.muellers@schieder-schwalenberg.de', '05282 / 601-11', 'Domäne 3, 32816 Schieder-Schwalenberg', 'Nach Vereinbarung', NULL, NULL);
INSERT INTO public.tenants VALUES ('tenant_hornbadmeinberg_001', 'Horn-Bad Meinberg', 'hornbadmeinberg', 'hornbadmeinberg.buergerapp.de', '#1e40af', '#3b82f6', '/assets/hornbadmeinberg/logo.jpg', '/assets/hornbadmeinberg/hero.png', 'post@horn-badmeinberg.de', '05234 / 201 - 0', 'Marktplatz 4, 32805 Horn-Bad Meinberg', NULL, NULL, 'Horn-Bad Meinberg', 'Horn-Bad Meinberg Assistent', NULL, NULL, true, '2025-12-02 05:51:41.14087', '2025-12-02 05:51:41.14087', 'Michael Ruttner', NULL, NULL, NULL, 'Mo: 8:30-12:00 & 14:00-16:00, Di: 8:30-12:00, Mi: 7:30-12:30, Do: 8:30-12:00 & 14:00-17:30, Fr: 8:30-12:00', 'https://www.horn-badmeinberg.de/Rechtliches/Impressum/', 'https://www.horn-badmeinberg.de/Rechtliches/Datenschutz/');


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: buergerapp_user
--

INSERT INTO public.departments VALUES (1, 'tenant_schieder_001', 'Fachbereich Stadtentwicklung', 'Building', 4, '2025-11-23 06:01:01.987037', '2025-11-23 06:01:01.987037');
INSERT INTO public.departments VALUES (2, 'tenant_schieder_001', 'Bauhof', 'Wrench', 5, '2025-11-23 06:01:01.989028', '2025-11-23 06:01:01.989028');
INSERT INTO public.departments VALUES (3, 'tenant_schieder_001', 'Fachbereich Finanzen und Organisation', 'Calculator', 2, '2025-11-23 06:01:01.989794', '2025-11-23 06:01:01.989794');
INSERT INTO public.departments VALUES (4, 'tenant_schieder_001', 'Fachbereich Ordnung und Soziales', 'Users', 3, '2025-11-23 06:01:01.990549', '2025-11-23 06:01:01.990549');
INSERT INTO public.departments VALUES (5, 'tenant_schieder_001', 'Auszubildende', 'GraduationCap', 8, '2025-11-23 06:01:01.991265', '2025-11-23 06:01:01.991265');
INSERT INTO public.departments VALUES (6, 'tenant_schieder_001', 'Betreuung', 'Heart', 9, '2025-11-23 06:01:01.992216', '2025-11-23 06:01:01.992216');
INSERT INTO public.departments VALUES (7, 'tenant_schieder_001', 'Touristinfo', 'MapPin', 7, '2025-11-23 06:01:01.993008', '2025-11-23 06:01:01.993008');
INSERT INTO public.departments VALUES (18, 'tenant_hornbadmeinberg_001', 'Kläranlage', 'Wrench', 0, '2025-12-02 07:04:55.398864', '2025-12-02 07:04:55.398864');
INSERT INTO public.departments VALUES (11, 'tenant_hornbadmeinberg_001', 'Stadtwerke, Umwelt und öffentliche Einrichtungen', 'Heart', 0, '2025-12-02 07:04:55.347697', '2025-12-02 07:17:22.300581');
INSERT INTO public.departments VALUES (20, 'tenant_hornbadmeinberg_001', 'Pressestelle', 'Info', 0, '2025-12-02 07:04:55.40201', '2025-12-02 07:17:22.34445');
INSERT INTO public.departments VALUES (16, 'tenant_hornbadmeinberg_001', 'Leiterin', 'Crown', 0, '2025-12-02 07:04:55.394564', '2025-12-02 07:17:22.338154');
INSERT INTO public.departments VALUES (19, 'tenant_hornbadmeinberg_001', 'Bürgermeister', 'Crown', -1, '2025-12-02 07:04:55.400602', '2025-12-02 07:04:55.400602');
INSERT INTO public.departments VALUES (15, 'tenant_hornbadmeinberg_001', 'Finanzen', 'Calculator', 0, '2025-12-02 07:04:55.387134', '2025-12-02 07:17:22.331633');
INSERT INTO public.departments VALUES (8, 'tenant_hornbadmeinberg_001', 'Bildung, Ordnung und Soziales', 'Users', 0, '2025-12-02 07:04:31.729091', '2025-12-02 07:17:22.2695');
INSERT INTO public.departments VALUES (13, 'tenant_hornbadmeinberg_001', 'Stadtentwicklung, Bauen und Liegenschaften', 'Building', 0, '2025-12-02 07:04:55.37459', '2025-12-02 07:17:22.321427');
INSERT INTO public.departments VALUES (10, 'tenant_hornbadmeinberg_001', 'Baubetriebshof', 'Wrench', 0, '2025-12-02 07:04:55.345565', '2025-12-02 07:17:22.296217');
INSERT INTO public.departments VALUES (14, 'tenant_hornbadmeinberg_001', 'Allgemeine Verwaltung', 'Briefcase', 0, '2025-12-02 07:04:55.384322', '2025-12-02 07:17:22.329588');
INSERT INTO public.departments VALUES (12, 'tenant_hornbadmeinberg_001', 'Zentrale Dienste / Personal', 'Users', 0, '2025-12-02 07:04:55.361214', '2025-12-02 07:17:22.31114');
INSERT INTO public.departments VALUES (17, 'tenant_hornbadmeinberg_001', 'Stabsstelle', 'Info', 0, '2025-12-02 07:04:55.396232', '2025-12-02 07:17:22.339531');


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: buergerapp_user
--

INSERT INTO public.events VALUES (1, 'tenant_schieder_001', 'HerzLIchtSEIN e.V.', 'HerzLIchtSEIN e.V.', '2025-11-23 11:00:00', NULL, NULL, NULL, 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender#2025-11-23 11:00:00-herzlichtsein-e-v', 'Veranstaltung', '2025-11-23 05:52:55.108309', '2025-11-23 05:52:55.108309');
INSERT INTO public.events VALUES (2, 'tenant_schieder_001', 'Weihnachtsmarkt in Lothe', 'Weihnachtsmarkt in Lothe', '2025-11-29 15:00:00', '2025-11-30 22:00:00', NULL, NULL, 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender#2025-11-29 15:00:00-weihnachtsmarkt-in-lothe', 'Veranstaltung', '2025-11-23 05:52:55.111918', '2025-11-23 05:52:55.111918');
INSERT INTO public.events VALUES (3, 'tenant_schieder_001', 'Schwalenberger ARTvent', 'Schwalenberger ARTvent', '2025-11-30 15:00:00', '2025-12-28 18:00:00', NULL, NULL, 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender#2025-11-30 15:00:00-schwalenberger-artvent', 'Veranstaltung', '2025-11-23 05:52:55.113312', '2025-11-23 05:52:55.113312');
INSERT INTO public.events VALUES (4, 'tenant_schieder_001', 'GlühweinTreff', 'GlühweinTreff', '2025-12-05 16:00:00', NULL, NULL, NULL, 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender#2025-12-05 16:00:00-gl-hweintreff', 'Veranstaltung', '2025-11-23 05:52:55.114436', '2025-11-23 05:52:55.114436');
INSERT INTO public.events VALUES (5, 'tenant_schieder_001', 'Kolibri Adventszauber-Der Weihnachtsmarkt in Schwalenberg', 'Kolibri Adventszauber-Der Weihnachtsmarkt in Schwalenberg', '2025-12-06 14:00:00', '2025-12-07 01:00:00', NULL, NULL, 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender#2025-12-06 14:00:00-kolibri-adventszauber-der-weihnachtsmarkt-in-schwa', 'Veranstaltung', '2025-11-23 05:52:55.11539', '2025-11-23 05:52:55.11539');
INSERT INTO public.events VALUES (6, 'tenant_schieder_001', 'Nikolaussingen & Glühweintrinken', 'Nikolaussingen & Glühweintrinken', '2025-12-06 17:30:00', NULL, NULL, NULL, 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender#2025-12-06 17:30:00-nikolaussingen-gl-hweintrinken', 'Veranstaltung', '2025-11-23 05:52:55.116242', '2025-11-23 05:52:55.116242');
INSERT INTO public.events VALUES (7, 'tenant_schieder_001', 'Demokratie- Stimme der Freiheit', 'Demokratie- Stimme der Freiheit', '2025-12-07 15:00:00', '2026-01-11 17:00:00', NULL, NULL, 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender#2025-12-07 15:00:00-demokratie-stimme-der-freiheit', 'Veranstaltung', '2025-11-23 05:52:55.117003', '2025-11-23 05:52:55.117003');
INSERT INTO public.events VALUES (8, 'tenant_schieder_001', 'Schwalenberger ARTvent', 'Schwalenberger ARTvent', '2025-12-07 15:00:00', '2026-01-04 18:00:00', NULL, NULL, 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender#2025-12-07 15:00:00-schwalenberger-artvent', 'Veranstaltung', '2025-11-23 05:52:55.117811', '2025-11-23 05:52:55.117811');
INSERT INTO public.events VALUES (9, 'tenant_schieder_001', 'Schwalenberger ARTvent', 'Schwalenberger ARTvent', '2025-12-14 15:00:00', '2026-01-11 18:00:00', NULL, NULL, 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender#2025-12-14 15:00:00-schwalenberger-artvent', 'Veranstaltung', '2025-11-23 05:52:55.118846', '2025-11-23 05:52:55.118846');
INSERT INTO public.events VALUES (10, 'tenant_schieder_001', 'Schwalenberger ARTvent', 'Schwalenberger ARTvent', '2025-12-21 15:00:00', '2026-01-18 18:00:00', NULL, NULL, 'https://www.schieder-schwalenberg.de/Tourismus/Tourismus-und-Freizeit/Service/Veranstaltungskalender#2025-12-21 15:00:00-schwalenberger-artvent', 'Veranstaltung', '2025-11-23 05:52:55.119624', '2025-11-23 05:52:55.119624');
INSERT INTO public.events VALUES (11, 'tenant_hornbadmeinberg_001', 'Frühlingsfest in Horn', 'Buntes Kirmestreiben rund ums Rathaus vor Ostern', '2025-03-20 04:00:00', NULL, 'Horn, Rathaus', NULL, 'https://www.horn-badmeinberg.de/Leben-Freizeit/Veranstaltungen/Traditionelle-Feste/', NULL, '2025-12-02 06:34:40.182156', '2025-12-02 06:34:40.182156');
INSERT INTO public.events VALUES (21, 'tenant_hornbadmeinberg_001', 'Osterfeuer', 'Als traditioneller Brauch werden in verschiedenen Stadtteilen Osterfeuer angezündet: Bad Meinberg, Billerbeck, Feldrom, Wehren und anderen Stadtteilen', '2025-03-31 04:00:00', NULL, 'Verschiedene Stadtteile', NULL, 'https://www.horn-badmeinberg.de/Leben-Freizeit/Veranstaltungen/Traditionelle-Feste/#osterfeuer', NULL, '2025-12-02 06:34:53.60361', '2025-12-02 06:34:53.60361');
INSERT INTO public.events VALUES (22, 'tenant_hornbadmeinberg_001', 'Weinfest in Bad Meinberg', 'Ein Fest rund um den Wein Ende Mai', '2025-05-25 04:00:00', NULL, 'Bad Meinberg', NULL, 'https://www.horn-badmeinberg.de/Leben-Freizeit/Veranstaltungen/Traditionelle-Feste/#weinfest-in-bad-meinberg', NULL, '2025-12-02 06:34:53.618044', '2025-12-02 06:34:53.618044');
INSERT INTO public.events VALUES (23, 'tenant_hornbadmeinberg_001', 'Kurpark-Sommerfest', 'Sommerfest im Kurpark Bad Meinberg', '2025-08-15 04:00:00', NULL, 'Kurpark Bad Meinberg', NULL, 'https://www.horn-badmeinberg.de/Leben-Freizeit/Veranstaltungen/Traditionelle-Feste/#kurpark-sommerfest', NULL, '2025-12-02 06:34:53.63161', '2025-12-02 06:34:53.63161');
INSERT INTO public.events VALUES (24, 'tenant_hornbadmeinberg_001', 'Hörnchenfest in Horn', 'Das Altstadtvergnügen mit verlängerter Einkaufsmöglichkeit am Samstag - Letztes Wochenende im September', '2025-09-28 04:00:00', NULL, 'Horn, Altstadt', NULL, 'https://www.horn-badmeinberg.de/Leben-Freizeit/Veranstaltungen/Traditionelle-Feste/#hörnchenfest-in-horn', NULL, '2025-12-02 06:34:53.645328', '2025-12-02 06:34:53.645328');
INSERT INTO public.events VALUES (25, 'tenant_hornbadmeinberg_001', 'Beller Schnirz', 'Traditionelles Volksfest im Stadtteil Belle - 3. Wochenende im Oktober', '2025-10-18 04:00:00', NULL, 'Belle', NULL, 'https://www.horn-badmeinberg.de/Leben-Freizeit/Veranstaltungen/Traditionelle-Feste/#beller-schnirz', NULL, '2025-12-02 06:34:53.658493', '2025-12-02 06:34:53.658493');
INSERT INTO public.events VALUES (26, 'tenant_hornbadmeinberg_001', 'Bauernmarkt in Bad Meinberg', 'Traditioneller Bauernmarkt in der Bad Meinberger Allee - 3. Wochenende im Oktober', '2025-10-19 04:00:00', NULL, 'Bad Meinberg, Allee', NULL, 'https://www.horn-badmeinberg.de/Leben-Freizeit/Veranstaltungen/Traditionelle-Feste/#bauernmarkt-in-bad-meinberg', NULL, '2025-12-02 06:34:53.672186', '2025-12-02 06:34:53.672186');
INSERT INTO public.events VALUES (27, 'tenant_hornbadmeinberg_001', 'Kläschen in Horn', 'Traditionelles Fest mit Kirmes rund um das Rathaus und verkaufsoffenem Sonntag - 3. Wochenende vor dem 1. Advent', '2025-11-10 05:00:00', NULL, 'Horn, Rathaus', NULL, 'https://www.horn-badmeinberg.de/Leben-Freizeit/Veranstaltungen/Traditionelle-Feste/#kläschen-in-horn', NULL, '2025-12-02 06:34:53.685402', '2025-12-02 06:34:53.685402');
INSERT INTO public.events VALUES (28, 'tenant_hornbadmeinberg_001', 'Christkindlmarkt in Bad Meinberg', 'Veranstaltungsort ist der Kurpark und das Kurgastzentrum - 3. Advent', '2025-12-15 05:00:00', NULL, 'Kurpark und Kurgastzentrum Bad Meinberg', NULL, 'https://www.horn-badmeinberg.de/Leben-Freizeit/Veranstaltungen/Traditionelle-Feste/#christkindlmarkt-in-bad-meinberg', NULL, '2025-12-02 06:34:53.699567', '2025-12-02 06:34:53.699567');
INSERT INTO public.events VALUES (29, 'tenant_hornbadmeinberg_001', 'Schützenfeste in sieben Stadtteilen', 'Die traditionellen Schützengesellschaften veranstalten jeweils in ihren Stadtteilen Schützenfeste: Bad Meinberg, Belle, Bellenberg, Feldrom, Horn, Kempen, Wehren', '2025-06-15 04:00:00', NULL, 'Verschiedene Stadtteile', NULL, 'https://www.horn-badmeinberg.de/Leben-Freizeit/Veranstaltungen/Traditionelle-Feste/#schützenfeste-in-sieben-stadtteilen', NULL, '2025-12-02 06:34:53.712326', '2025-12-02 06:34:53.712326');


--
-- Data for Name: news; Type: TABLE DATA; Schema: public; Owner: buergerapp_user
--

INSERT INTO public.news VALUES ('news_1764675033260_fnp1407fv', 'tenant_hornbadmeinberg_001', 'Nachrichten', 'Nachrichten', 'Nachrichten', NULL, NULL, '2025-12-02 11:30:33.22', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/', '2025-12-02 06:30:33.261665');
INSERT INTO public.news VALUES ('news_1764675033264_e0a85dhgv', 'tenant_hornbadmeinberg_001', 'Besser informiert durch soziale Medien - Stadt Horn-Bad Meinberg ist auf Facebook und Instagram', 'Besser informiert durch soziale Medien - Stadt Horn-Bad Meinberg ist auf Facebook und Instagram', 'Besser informiert durch soziale Medien - Stadt Horn-Bad Meinberg ist auf Facebook und Instagram', 'https://www.horn-badmeinberg.de/media/custom/3165_438_1_m.JPG?1764163335', NULL, '2025-11-26 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Besser-informiert-durch-soziale-Medien-Stadt-Horn-Bad-Meinberg-ist-auf-Facebook-und-Instagram.php?object=tx,3165.5.1&ModID=7&FID=3165.3490.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.264447');
INSERT INTO public.news VALUES ('news_1764675033266_yd8obg0pd', 'tenant_hornbadmeinberg_001', 'Damit alle sicher ankommen: Winterdienst erfordert Platz', 'Damit alle sicher ankommen: Winterdienst erfordert Platz', 'Damit alle sicher ankommen: Winterdienst erfordert Platz', 'https://www.horn-badmeinberg.de/media/custom/3165_436_1_m.JPG?1764077244', NULL, '2025-11-25 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Damit-alle-sicher-ankommen-Winterdienst-erfordert-Platz.php?object=tx,3165.5.1&ModID=7&FID=3165.3487.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.266868');
INSERT INTO public.news VALUES ('news_1764675033267_lygnu1kci', 'tenant_hornbadmeinberg_001', 'Wunschbaumaktion in Horn-Bad Meinberg hat begonnen', 'Wunschbaumaktion in Horn-Bad Meinberg hat begonnen', 'Wunschbaumaktion in Horn-Bad Meinberg hat begonnen', 'https://www.horn-badmeinberg.de/media/custom/3165_435_1_m.JPG?1763990180', NULL, '2025-11-24 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Wunschbaumaktion-in-Horn-Bad-Meinberg-hat-begonnen.php?object=tx,3165.5.1&ModID=7&FID=3165.3485.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.26802');
INSERT INTO public.news VALUES ('news_1764675033269_yf1ktfpm3', 'tenant_hornbadmeinberg_001', 'Stellenausschreibung Fachangestellte*n für Bäderbetriebe in Vollzeit und ganzjährig (m/w/d)', 'Die Stadt Horn-Bad Meinberg sucht für die städtische Schwimmhalle am Püngelsberg und das städtische Freibad Eggebad zum nächstmöglichen Zeitpunkt eine*n', 'Die Stadt Horn-Bad Meinberg sucht für die städtische Schwimmhalle am Püngelsberg und das städtische Freibad Eggebad zum nächstmöglichen Zeitpunkt eine*n', 'https://www.horn-badmeinberg.de/media/custom/449_1476_1_m.JPG?1581502333', NULL, '2025-11-13 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Stellenausschreibung-Fachangestellte-n-f%C3%BCr-B%C3%A4derbetriebe-in-Vollzeit-und-ganzj%C3%A4hrig-m-w-d-.php?object=tx,3165.5.1&ModID=7&FID=3165.3484.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.269998');
INSERT INTO public.news VALUES ('news_1764675033271_3igq1y6vm', 'tenant_hornbadmeinberg_001', 'Schwimmhalle im Schulzentrum ab Montag wieder in Betrieb', 'Schwimmhalle im Schulzentrum ab Montag wieder in Betrieb', 'Schwimmhalle im Schulzentrum ab Montag wieder in Betrieb', 'https://www.horn-badmeinberg.de/media/custom/3165_433_1_m.JPG?1762516246', NULL, '2025-11-07 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Schwimmhalle-im-Schulzentrum-ab-Montag-wieder-in-Betrieb.php?object=tx,3165.5.1&ModID=7&FID=3165.3481.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.271764');
INSERT INTO public.news VALUES ('news_1764675033268_7fh5g7hfv', 'tenant_hornbadmeinberg_001', 'Notmaßnahme und Sperrung am Holzhauser Berg', 'Notmaßnahme und Sperrung am Holzhauser Berg', 'Notmaßnahme und Sperrung am Holzhauser Berg', 'https://www.horn-badmeinberg.de/media/custom/3165_434_1_m.JPG?1763050937', NULL, '2025-11-13 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Notma%C3%9Fnahme-und-Sperrung-am-Holzhauser-Berg.php?object=tx,3165.5.1&ModID=7&FID=3165.3482.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.26886');
INSERT INTO public.news VALUES ('news_1764675033270_2dd3xx69f', 'tenant_hornbadmeinberg_001', 'Stadtwerke Horn-Bad Meinberg versenden Ablesekarten für Wasserzählerstände 2025', 'Stadtwerke Horn-Bad Meinberg versenden Ablesekarten für Wasserzählerstände 2025', 'Stadtwerke Horn-Bad Meinberg versenden Ablesekarten für Wasserzählerstände 2025', 'https://www.horn-badmeinberg.de/media/custom/449_3235_1_m.JPG?1604573716', NULL, '2025-11-12 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Stadtwerke-Horn-Bad-Meinberg-versenden-Ablesekarten-f%C3%BCr-Wasserz%C3%A4hlerst%C3%A4nde-2025.php?object=tx,3165.5.1&ModID=7&FID=3165.3477.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.270728');
INSERT INTO public.news VALUES ('news_1764675033272_lmv8ene7u', 'tenant_hornbadmeinberg_001', 'Baustelle an der Steinheimer Straße noch bis 21. November', 'Baustelle an der Steinheimer Straße noch bis 21. November', 'Baustelle an der Steinheimer Straße noch bis 21. November', 'https://www.horn-badmeinberg.de/media/custom/449_1476_1_m.JPG?1581502333', NULL, '2025-11-07 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Baustelle-an-der-Steinheimer-Stra%C3%9Fe-noch-bis-21-November.php?object=tx,3165.5.1&ModID=7&FID=3165.3476.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.272687');
INSERT INTO public.news VALUES ('news_1764675033273_vlgyr0bmg', 'tenant_hornbadmeinberg_001', 'Stadt Horn-Bad Meinberg lädt zur Seniorenweihnachtsfeier ein', 'MAXIMALE ANMELDEZAHL ERREICHT', 'MAXIMALE ANMELDEZAHL ERREICHT', 'https://www.horn-badmeinberg.de/media/custom/449_1476_1_m.JPG?1581502333', NULL, '2025-11-06 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Stadt-Horn-Bad-Meinberg-l%C3%A4dt-zur-Seniorenweihnachtsfeier-ein.php?object=tx,3165.5.1&ModID=7&FID=3165.3480.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.273603');
INSERT INTO public.news VALUES ('news_1764675033274_v3ztnnhhr', 'tenant_hornbadmeinberg_001', 'Erster Verdachtsfall von Geflügelpest in Lippe', 'Erster Verdachtsfall von Geflßgelpest in Lippe', 'Erster Verdachtsfall von Geflßgelpest in Lippe', 'https://www.horn-badmeinberg.de/media/custom/3165_238_1_m.GIF?1737716459', NULL, '2025-11-05 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Erster-Verdachtsfall-von-Gefl%C3%BCgelpest-in-Lippe.php?object=tx,3165.5.1&ModID=7&FID=3165.3478.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.274491');
INSERT INTO public.news VALUES ('news_1764675033275_a01mct6ew', 'tenant_hornbadmeinberg_001', 'Neuer Ratgeber gibt Orientierung in unsicheren Zeiten', 'Neuer Ratgeber gibt Orientierung in unsicheren Zeiten', 'Neuer Ratgeber gibt Orientierung in unsicheren Zeiten', 'https://www.horn-badmeinberg.de/media/custom/3165_429_1_m.JPG?1762162699', NULL, '2025-11-03 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Neuer-Ratgeber-gibt-Orientierung-in-unsicheren-Zeiten.php?object=tx,3165.5.1&ModID=7&FID=3165.3474.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.276121');
INSERT INTO public.news VALUES ('news_1764675033265_m93fwd4b1', 'tenant_hornbadmeinberg_001', 'Stadt Horn-Bad Meinberg sucht engagierte Mitglieder für Beeinträchtigen- und Seniorenbeirat sowie Integrationsbeirat', 'Stadt Horn-Bad Meinberg sucht engagierte Mitglieder für Beeinträchtigen- und Seniorenbeirat sowie Integrationsbeirat', 'Stadt Horn-Bad Meinberg sucht engagierte Mitglieder für Beeinträchtigen- und Seniorenbeirat sowie Integrationsbeirat', 'https://www.horn-badmeinberg.de/media/custom/449_1476_1_m.JPG?1581502333', NULL, '2025-11-25 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Stadt-Horn-Bad-Meinberg-sucht-engagierte-Mitglieder-f%C3%BCr-Beeintr%C3%A4chtigen-und-Seniorenbeirat-sowie-Integrationsbeirat.php?object=tx,3165.5.1&ModID=7&FID=3165.3489.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.26564');
INSERT INTO public.news VALUES ('news_1764675033275_sthipn8df', 'tenant_hornbadmeinberg_001', 'Mit Eseln durch den Winter: LTM lädt zu Erlebnisführungen mit Camillo und Co.', 'Mit Eseln durch den Winter: LTM lßdt zu Erlebnisfßhrungen mit Camillo und Co.', 'Mit Eseln durch den Winter: LTM lßdt zu Erlebnisfßhrungen mit Camillo und Co.', 'https://www.horn-badmeinberg.de/media/custom/3165_430_1_m.JPG?1762248112', NULL, '2025-11-04 00:00:00', 'https://www.horn-badmeinberg.de/Verwaltung/Nachrichten/Mit-Eseln-durch-den-Winter-LTM-l%C3%A4dt-zu-Erlebnisf%C3%BChrungen-mit-Camillo-und-Co-.php?object=tx,3165.5.1&ModID=7&FID=3165.3475.1&NavID=3165.47&La=1&kat=8.51%2C390.4&call=suche', '2025-12-02 06:30:33.275365');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: buergerapp_user
--



--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buergerapp_user
--

SELECT pg_catalog.setval('public.departments_id_seq', 33, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: buergerapp_user
--

SELECT pg_catalog.setval('public.events_id_seq', 29, true);


--
-- PostgreSQL database dump complete
--

\unrestrict iklwKTcLVph9OsmqO5HZMYvgdd01TsxEJ1DcSphTQJKl9Y9irKChr87fQwNWvJs

