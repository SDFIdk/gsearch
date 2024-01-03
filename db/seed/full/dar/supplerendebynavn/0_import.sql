DROP TABLE IF EXISTS dar.supplerendebynavn;

CREATE TABLE dar.supplerendebynavn AS
SELECT
    id_lokalid::uuid AS id,
    navn
FROM
    dar_fdw.supplerendebynavn;

CREATE INDEX ON dar.supplerendebynavn (id);

CREATE INDEX ON dar.supplerendebynavn (id, navn);

VACUUM ANALYZE dar.supplerendebynavn;
