-- Fix UTF-8 encoding issues in staff names and department names
-- Replace broken characters with correct German umlauts

-- Fix staff names
UPDATE staff SET name = REPLACE(name, 'B�rgerdialog', 'Bürgerdialog') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'Ba�os', 'Baños') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'B�rner', 'Börner') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'Bollh�fer', 'Bollhöfer') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'F�rber', 'Färber') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'Gr�ttner', 'Grüttner') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'J�rg', 'Jörg') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'L�scher', 'Löscher') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'L�cking', 'Lücking') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'M�ller', 'Müller') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'P�hlker', 'Pöhlker') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'R�diger', 'Rüdiger') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'Sch�fer', 'Schäfer') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'Sch�n', 'Schön') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'S�lter', 'Sölter') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, 'T�lle', 'Tölle') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE staff SET name = REPLACE(name, '�nl�', 'Ünlü') WHERE tenant_id = 'tenant_hornbadmeinberg_001';

-- Fix department names
UPDATE departments SET name = REPLACE(name, 'B�rgermeister', 'Bürgermeister') WHERE tenant_id = 'tenant_hornbadmeinberg_001';
UPDATE departments SET name = REPLACE(name, 'Kl�ranlage', 'Kläranlage') WHERE tenant_id = 'tenant_hornbadmeinberg_001';

-- Verify fixes
SELECT 'Staff with fixed names:' as info, COUNT(*) as count FROM staff WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name LIKE '%ü%' OR name LIKE '%ö%' OR name LIKE '%ä%';
SELECT 'Departments with fixed names:' as info, COUNT(*) as count FROM departments WHERE tenant_id = 'tenant_hornbadmeinberg_001' AND name LIKE '%ü%' OR name LIKE '%ö%' OR name LIKE '%ä%';
