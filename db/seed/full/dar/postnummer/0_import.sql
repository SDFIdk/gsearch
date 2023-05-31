DROP TABLE IF EXISTS dar.postnummer;

CREATE TABLE dar.postnummer AS
SELECT
    id_lokalid::uuid AS id,
    navn,
    postnr
FROM
    dar_fdw.postnummer;

CREATE INDEX ON dar.postnummer (id);

VACUUM ANALYZE dar.postnummer;
