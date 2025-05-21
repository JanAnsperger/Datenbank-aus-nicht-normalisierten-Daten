-- Datenbank aufsetzen 
CREATE DATABASE "MegaStore365";

-- Kunden-Tabelle
CREATE TABLE "Kunden" ("KundenID" INTEGER PRIMARY KEY,
"KundeName" VARCHAR(255) NOT NULL,
"KundeAdresse" VARCHAR(255) NOT NULL ,
"KundeKreditkarte" BIGINT NOT NULL);

-- Produkt-Tabelle
CREATE TABLE "Produkte" ("ProduktID" INTEGER PRIMARY KEY,
"ProduktName" VARCHAR(255) NOT NULL,
"ProduktPreis" DECIMAL(10,2) NOT NULL ,
"Kategorie" VARCHAR(255) NOT NULL);

-- Verkaufs-Tabelle
CREATE TABLE "Verkaeufe"(
"BestellID" INTEGER PRIMARY KEY,
"Menge" INTEGER NOT NULL,
"Bestelldatum" DATE NOT NULL,
"KundenID" INTEGER REFERENCES "Kunden"("KundenID"),
"ProduktID" INTEGER REFERENCES "Produkte"("ProduktID") 
);

-- Import prüfen

SELECT * FROM "Kunden" k  LIMIT 5;
SELECT * FROM "Produkte" p  LIMIT 5;
SELECT * FROM "Verkaeufe" v  LIMIT 5;
