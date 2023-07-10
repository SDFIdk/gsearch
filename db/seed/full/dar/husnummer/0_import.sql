DROP TABLE IF EXISTS dar.husnummer;

CREATE TABLE dar.husnummer AS SELECT DISTINCT
    h.id_lokalid AS id,
    h.adgangsadressebetegnelse,
    h.adgangspunktlokalid::uuid AS adgangspunkt_id,
    h.geometri AS husnummerretning,
    h.husnummertekst,
    h.vejpunktlokalid::uuid AS vejpunkt_id,
    h.jordstykkelokalid AS jordstykke_id,
    h.plapaaflbgjordstykkelokalid AS placeretpaaforeloebigtjordstykke_id,
    h.geodanmarkbygninglokalid AS geodanmarkbygning_id,
    h.adgangtilbygninglokalid::uuid AS adgangtilbygning_id,
    h.supplerendebynavnlokalid::uuid AS supplerendebynavn_id,
    h.postnummerlokalid::uuid AS postnummer_id,
    LEFT (h.vejmidtelokalid,
        4) AS kommunekode,
    RIGHT (h.vejmidtelokalid,
        4) AS vejkode,
    h.navngivenvejlokalid::uuid AS navngivenvej_id
FROM
    dar_fdw.husnummer h;

CREATE INDEX ON dar.husnummer (id);

CREATE INDEX ON dar.husnummer (navngivenvej_id);

CREATE INDEX ON dar.husnummer (vejpunkt_id);

VACUUM ANALYZE dar.husnummer;
