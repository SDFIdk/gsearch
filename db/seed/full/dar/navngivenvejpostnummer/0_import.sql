DROP TABLE IF EXISTS dar.navngivenvejpostnummer;

CREATE TABLE dar.navngivenvejpostnummer AS
SELECT
    id_lokalid::uuid AS id,
    navngivenvejlokalid::uuid AS navngivenvej_id,
    postnummerlokalid::uuid AS postnummer_id
FROM
    dar_fdw.navngivenvejpostnummer;

CREATE INDEX ON dar.navngivenvejpostnummer (navngivenvej_id);

CREATE INDEX ON dar.navngivenvejpostnummer (postnummer_id);

CREATE INDEX ON dar.navngivenvejpostnummer (navngivenvej_id, postnummer_id);

VACUUM ANALYZE dar.navngivenvejpostnummer;
