-- Add icons to departments for Horn-Bad Meinberg
-- Based on Schieder-Schwalenberg icon mapping

-- Bürgermeister - Crown icon (already has special styling)
UPDATE departments SET icon = 'Crown' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Bürgermeister';

-- Finanzen - Calculator icon
UPDATE departments SET icon = 'Calculator' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Finanzen';

-- Bildung, Ordnung und Soziales - Users icon
UPDATE departments SET icon = 'Users' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Bildung, Ordnung und Soziales';

-- Stadtentwicklung, Bauen und Liegenschaften - Building icon
UPDATE departments SET icon = 'Building' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Stadtentwicklung, Bauen und Liegenschaften';

-- Baubetriebshof - Wrench icon
UPDATE departments SET icon = 'Wrench' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Baubetriebshof';

-- Allgemeine Verwaltung - Briefcase icon
UPDATE departments SET icon = 'Briefcase' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Allgemeine Verwaltung';

-- Zentrale Dienste / Personal - Users icon
UPDATE departments SET icon = 'Users' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Zentrale Dienste / Personal';

-- Stabsstelle - Info icon
UPDATE departments SET icon = 'Info' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Stabsstelle';

-- Kläranlage - Wrench icon (technical/infrastructure)
UPDATE departments SET icon = 'Wrench' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Kläranlage';

-- Stadtwerke, Umwelt und öffentliche Einrichtungen - Heart icon (public services)
UPDATE departments SET icon = 'Heart' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Stadtwerke, Umwelt und öffentliche Einrichtungen';

-- Pressestelle - Info icon
UPDATE departments SET icon = 'Info' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Pressestelle';

-- Leiterin - Crown icon (leadership)
UPDATE departments SET icon = 'Crown' 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name = 'Leiterin';

-- Verify changes
SELECT name, icon, (SELECT COUNT(*) FROM staff WHERE department_id = d.id) as staff_count 
FROM departments d 
WHERE tenant_id = 'tenant_hornbadmeinberg_001' 
ORDER BY display_order, name;
