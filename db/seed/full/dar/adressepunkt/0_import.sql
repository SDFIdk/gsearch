DROP TABLE IF EXISTS dar.adressepunkt CASCADE;

CREATE TABLE dar.adressepunkt (
    id uuid PRIMARY KEY,
    geometri geometry
);

CREATE INDEX ON dar.adressepunkt (id);

CREATE INDEX ON dar.adressepunkt USING gist (geometri);

INSERT INTO dar.adressepunkt SELECT DISTINCT
    id_lokalid::uuid,
    geometri
FROM
    dar_fdw.adressepunkt
ON CONFLICT
    DO NOTHING;

VACUUM ANALYZE dar.adressepunkt;
