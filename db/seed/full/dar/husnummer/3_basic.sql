DROP TABLE IF EXISTS basic.husnummer;

WITH husnumre AS (
    SELECT
        h.id AS id,
        h.adgangsadressebetegnelse AS visningstekst,
        h.husnummertekst,
        h.navngivenvej_id,
        n.vejnavn,
        h.vejkode,
        h.kommunekode,
        k.navn AS kommunenavn,
        p.postnr AS postnummer,
        p.navn AS postnummernavn,
        st_force2d (COALESCE(ap.geometri)) AS geometri,
        st_force2d (COALESCE(ap2.geometri)) AS vejpunkt_geometri
    FROM
        dar.husnummer h
        JOIN dar.navngivenvej n ON n.id = h.navngivenvej_id::uuid
        JOIN dar.postnummer p ON p.id = h.postnummer_id::uuid
        JOIN dar.adressepunkt ap ON ap.id = h.adgangspunkt_id
        JOIN dar.adressepunkt ap2 ON ap2.id = h.vejpunkt_id
        JOIN dagi_500.kommuneinddeling k ON k.kommunekode = h.kommunekode
)
SELECT
    h.id,
    h.visningstekst,
    h.husnummertekst,
    h.vejnavn,
    h.vejkode,
    h.kommunekode,
    h.kommunenavn,
    h.postnummer,
    h.postnummernavn,
    h.navngivenvej_id,
    nv.textsearchable_plain_col_vej,
    nv.textsearchable_unaccent_col_vej,
    nv.textsearchable_phonetic_col_vej,
    ROW_NUMBER() OVER (PARTITION BY h.navngivenvej_id ORDER BY NULLIF ((substring(h.husnummertekst::text FROM '[0-9]*')), '')::int,
        substring(h.husnummertekst::text FROM '[0-9]*([A-Z])') NULLS FIRST) AS sortering,
        st_multi (h.geometri) AS geometri,
    st_multi (h.vejpunkt_geometri) AS vejpunkt_geometri
INTO basic.husnummer
FROM
    husnumre h
    JOIN basic.navngivenvej nv ON h.navngivenvej_id = nv.id;
