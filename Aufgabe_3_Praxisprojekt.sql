-- Admin
CREATE ROLE "Admin";

GRANT ALL PRIVILEGES ON
ALL TABLES IN SCHEMA public TO "Admin";

GRANT ALL PRIVILEGES ON
ALL SEQUENCES IN SCHEMA public TO "Admin";

GRANT ALL PRIVILEGES ON 
ALL FUNCTIONS IN SCHEMA public TO "Admin";

ALTER ROLE "Admin" WITH SUPERUSER; -- Update 

-- Callcenter
CREATE ROLE "Callcenter";

GRANT SELECT ON"Kunden", "Verkaeufe" TO "Callcenter";

-- Datenanalyst
CREATE ROLE "Datenanalyst";

GRANT SELECT ON ALL TABLES IN SCHEMA public TO "Datenanalyst";

-- Logistik
CREATE ROLE "Logistik";

GRANT SELECT ON "Verkaeufe" TO "Logistik";

GRANT SELECT, UPDATE ON "Produkte" TO "Logistik";

-- Einkauf
CREATE ROLE "Einkauf";

GRANT SELECT ON "Verkaeufe" TO "Einkauf";

GRANT SELECT, INSERT, UPDATE, DELETE ON "Produkte" TO "Einkauf";

-- Buchhaltung
CREATE ROLE "Buchhaltung";

GRANT SELECT, INSERT, UPDATE, DELETE ON "Kunden" TO "Buchhaltung";

GRANT SELECT ON "Verkaeufe" TO "Buchhaltung";


-- User erstellen

-- Admins
CREATE USER geschaeftsfuehrer WITH PASSWORD 'boss123';
CREATE USER systemadministrator WITH PASSWORD 'it123';

-- Andere Benutzer
CREATE USER lagerist WITH PASSWORD 'lager123';
CREATE USER datenanalyst WITH PASSWORD 'data123';
CREATE USER callcenter_mitarbeiter WITH PASSWORD 'callcenter123';
CREATE USER buchhalter WITH PASSWORD 'buchmacher123';
CREATE USER einkaeufer WITH PASSWORD 'einkauf123';

-- Rollen zuweisen
GRANT "Admin" TO geschaeftsfuehrer;
GRANT "Admin" TO systemadministrator;

GRANT "Logistik" TO lagerist;
GRANT "Datenanalyst" TO datenanalyst;
GRANT "Callcenter" TO callcenter_mitarbeiter;
GRANT "Buchhaltung" TO buchhalter;
GRANT "Einkauf" TO einkaeufer;


-- Überprüfung der Rollen und Benutzer
SELECT
pg_roles.rolname AS rolle,
pg_user.usename AS benutzer
FROM
pg_auth_members
JOIN pg_roles ON pg_roles.oid = pg_auth_members.roleid
JOIN pg_user ON pg_user.usesysid = pg_auth_members.member
ORDER BY rolle;





