-- 1. Protokolltabelle erstellen

CREATE TABLE zugriffsprotokoll (
    id SERIAL PRIMARY KEY,
    benutzername TEXT,
    tabellenname TEXT,
    zugriffsart TEXT,
    inhalt JSONB,
    zugriffszeit TIMESTAMPTZ DEFAULT now()
);
-- 2. Trigger-Funktion erstellen

CREATE OR REPLACE FUNCTION protokolliere_zugriff()
RETURNS TRIGGER AS $$
DECLARE
    nutzername TEXT;
    dateninhalte JSONB;
BEGIN
    -- Versuche, die aktuelle Rolle aus der Konfiguration zu lesen
    nutzername := current_setting('role', true);

    -- Fallback auf den aktuellen Benutzer, falls keine Rolle gesetzt ist
    IF nutzername IS NULL THEN
        nutzername := CURRENT_USER;
    END IF;

    -- Dateninhalte je nach Zugriffsart erfassen
    IF TG_OP = 'DELETE' THEN
        dateninhalte := to_jsonb(OLD);

    ELSIF TG_OP = 'INSERT' THEN
        dateninhalte := to_jsonb(NEW);

    ELSIF TG_OP = 'UPDATE' THEN
        dateninhalte := jsonb_build_object(
            'alt', to_jsonb(OLD),
            'neu', to_jsonb(NEW)
        );
    END IF;

    -- Eintrag ins Protokoll schreiben
    INSERT INTO zugriffsprotokoll (benutzername, tabellenname, zugriffsart, inhalt)
    VALUES (nutzername, TG_TABLE_NAME, TG_OP, dateninhalte);

    -- Bei INSERT/UPDATE Rückgabe des Tupels (für DELETE irrelevant)
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;


-- 3. Trigger an die Tabellen anhängen

-- Tabelle: Kunden
CREATE TRIGGER kunden_zugriffsprotokoll
AFTER INSERT OR UPDATE OR DELETE ON "Kunden"
FOR EACH ROW
EXECUTE FUNCTION protokolliere_zugriff();

-- Tabelle: Verkaeufe
CREATE TRIGGER verkaeufe_zugriffsprotokoll
AFTER INSERT OR UPDATE OR DELETE ON "Verkaeufe"
FOR EACH ROW
EXECUTE FUNCTION protokolliere_zugriff();

-- Tabelle: Produkte
CREATE TRIGGER produkte_zugriffsprotokoll
AFTER INSERT OR UPDATE OR DELETE ON "Produkte"
FOR EACH ROW
EXECUTE FUNCTION protokolliere_zugriff();

SET ROLE "Einkauf";

-- neues Produkt hinzufügen
INSERT INTO "Produkte" ("ProduktID", "ProduktName", "ProduktPreis", "Kategorie") 
VALUES (43, 'Katzenfutter', 4.99, 'Tierbedarf');

UPDATE "Produkte"
SET "ProduktPreis" = 9.99
WHERE "ProduktID" = 43;

DELETE FROM "Produkte"
WHERE "ProduktID" = 43;

SELECT * FROM "Produkte";

SET ROLE "Admin";
SELECT *
FROM zugriffsprotokoll
ORDER BY zugriffszeit DESC;

-- Welche Trigger sind vorhanden
-- Test
SELECT 
    event_object_table AS tabelle,
    trigger_name AS trigger,
    action_timing AS zeitpunkt,
    event_manipulation AS aktion,
    action_statement AS funktion
FROM 
    information_schema.triggers
ORDER BY 
    event_object_table, trigger_name;