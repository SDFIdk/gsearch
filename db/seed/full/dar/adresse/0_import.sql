DROP TABLE IF EXISTS dar.adresse;

CREATE TABLE dar.adresse (
    id uuid PRIMARY KEY,
    adressebetegnelse varchar,
    doerbetegnelse varchar,
    doerpunkt_id uuid,
    etagebetegnelse varchar,
    bygning_id uuid,
    husnummer_id uuid
);

CREATE INDEX ON dar.adresse (husnummer_id);

CREATE INDEX ON dar.adresse (adressebetegnelse);

INSERT INTO dar.adresse SELECT DISTINCT
    id_lokalid::uuid AS id,
    adressebetegnelse,
    doerbetegnelse,
    doerpunktlokalid::uuid,
    etagebetegnelse,
    bygninglokalid::uuid,
    husnummerlokalid::uuid AS husnummer_id
FROM
    dar_fdw.adresse;

VACUUM ANALYZE dar.adresse;
