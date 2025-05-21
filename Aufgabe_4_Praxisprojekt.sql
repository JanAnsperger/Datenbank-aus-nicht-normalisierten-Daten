-- View Callcenter

-- Schritt 1: View erstellen
CREATE VIEW "Beschraenkte_Kundenansicht" AS
SELECT 
    "KundenID", 
    "KundeName", 
    "KundeAdresse", 
    CONCAT('*************', RIGHT(CAST("KundeKreditkarte" AS TEXT), 3)) AS "Kartenendziffern"
FROM "Kunden";

-- Schritt 2: Zugriff auf die Tabelle Kunden entziehen
REVOKE ALL ON "Kunden" FROM "Callcenter";

-- Schritt 3: Zugriff auf die View geben
GRANT SELECT ON "Beschraenkte_Kundenansicht" TO "Callcenter";

-- Schritt 4: Testen ob es funktioniert hat beid er Rolle
SET ROLE callcenter_mitarbeiter;

SELECT * FROM "Kunden"; -- sollte FEHLER geben

SELECT * FROM "Beschraenkte_Kundenansicht"; -- sollte funktionieren

-- Zurück zum Admin:
SET ROLE "Admin";

-- View Datenanalyst

-- Schritt 1: View erstellen
CREATE OR REPLACE VIEW "DA_Ansicht" AS
SELECT
"KundenID",
TRIM(SPLIT_PART(TRIM(SPLIT_PART("KundeAdresse", ',', 2)), ' ', 1)) AS plz,
TRIM(SUBSTRING(TRIM(SPLIT_PART("KundeAdresse", ',', 2)) FROM '^\d+\s+(.*)$')) AS ort
FROM "Kunden";

-- View Test
SELECT * FROM "DA_Ansicht";

-- Schritt 2: Zugriff auf die Tabelle Kunden entziehen
REVOKE ALL ON "Kunden" FROM "Datenanalyst";

-- Schritt 3: Zugriff auf die View geben
GRANT SELECT ON "DA_Ansicht" TO "Datenanalyst";

-- Schritt 4: Testen ob es funktioniert hat bei der Rolle
SET ROLE "Datenanalyst";

SELECT * FROM "Kunden"; -- sollte FEHLER geben

SELECT * FROM "DA_Ansicht"; -- sollte funktionieren

-- Zurück zum Admin:
SET ROLE "Admin";