DROP TABLE IF EXISTS dar.navngivenvej;

CREATE TABLE dar.navngivenvej AS
SELECT
    id_lokalid::uuid AS id,
    vejnavn,
    COALESCE(geometri, st_setsrid(st_geomfromtext(wkt_omr),25832)) AS geometri
FROM
    dar_fdw.navngivenvej;

CREATE INDEX ON dar.navngivenvej (id);

CREATE INDEX ON dar.navngivenvej USING gist (geometri);

VACUUM ANALYZE dar.navngivenvej;
