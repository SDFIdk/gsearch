DROP TABLE IF EXISTS dar.navngivenvejsupplerendebynavn;

CREATE TABLE dar.navngivenvejsupplerendebynavn AS
SELECT
    id_lokalid::uuid AS id,
    navngivenvejlokalid::uuid AS navngivenvej_id,
    supplerendebynavnlokalid::uuid AS supplerendebynavn_id
FROM
    dar_fdw.navngivenvejsupplerendebynavn;

CREATE INDEX ON dar.navngivenvejsupplerendebynavn (navngivenvej_id);

CREATE INDEX ON dar.navngivenvejsupplerendebynavn (supplerendebynavn_id);

CREATE INDEX ON dar.navngivenvejsupplerendebynavn (navngivenvej_id, supplerendebynavn_id);

VACUUM ANALYZE dar.navngivenvejsupplerendebynavn;
