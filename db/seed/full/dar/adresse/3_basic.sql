DROP TABLE IF EXISTS basic_initialloading.adresse;

-- Gets the list of problem roadnames
-- SELECT DISTINCT a.vejnavn FROM basic_initialloading.adresse a WHERE vejnavn ~ '\d';

WITH adresser AS (
    SELECT
        a.id,
        a.adressebetegnelse as visningstekst,
        a.doerbetegnelse AS doerbetegnelse,
        a.etagebetegnelse,
        h.husnummertekst AS husnummer,
        h.navngivenvej_id,
        h.sortering AS husnummer_sortering,
        n.vejnavn,
        sb.navn AS supplerendebynavn,
        h.vejkode,
        h.kommunekode,
        k.navn AS kommunenavn,
        p.postnr AS postnummer,
        p.navn AS postnummernavn,
        st_force2d (COALESCE(ap.geometri)) AS geometri,
        st_force2d (COALESCE(ap2.geometri)) AS vejpunkt_geometri
    FROM
        dar.adresse a
        JOIN (
            SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY navngivenvej_id ORDER BY NULLIF ((substring(husnummertekst::text
                FROM '[0-9]*')), '')::int,
                    substring(husnummertekst::text
                FROM '[0-9]*([A-Z])') NULLS FIRST) AS sortering
            FROM
                dar.husnummer) h ON a.husnummer_id = h.id::uuid
        JOIN dar.navngivenvej n ON n.id = h.navngivenvej_id::uuid
        LEFT JOIN dar.supplerendebynavn sb ON sb.id = h.supplerendebynavn_id::uuid
        JOIN dar.postnummer p ON p.id = h.postnummer_id::uuid
        JOIN dar.adressepunkt ap ON ap.id = h.adgangspunkt_id
        JOIN dar.adressepunkt ap2 ON ap2.id = h.vejpunkt_id
        JOIN dagi_500.kommuneinddeling k ON k.kommunekode = h.kommunekode
)
SELECT
    a.id,
    a.visningstekst,
    a.vejnavn,
    a.vejkode,
    a.husnummer,
    a.etagebetegnelse,
    a.doerbetegnelse,
    a.supplerendebynavn,
    a.postnummer,
    a.postnummernavn,
    a.kommunekode,
    a.kommunenavn,
    nv.textsearchable_plain_col_vej,
    nv.textsearchable_unaccent_col_vej,
    nv.textsearchable_phonetic_col_vej,
    a.navngivenvej_id,
    a.husnummer_sortering,
    -- Er 1 for alle rækker, men bruges i functionen, men det virker ikke relevant når alle har 1.
    ROW_NUMBER() OVER (PARTITION BY a.id ORDER BY CASE lower(a.etagebetegnelse)
        WHEN '' THEN
            -10
        WHEN 'k3' THEN
            -3
        WHEN 'k2' THEN
            -2
        WHEN 'kl' THEN
            -1
        WHEN 'st' THEN
            0
        ELSE
            NULLIF ((substring(a.etagebetegnelse FROM '[0-9]*')), '')::int
        END,
        CASE lower(a.doerbetegnelse)
        WHEN 'tv' THEN
            -3
        WHEN 'mf' THEN
            -2
        WHEN 'th' THEN
            -1
        ELSE
            NULLIF ((substring(a.doerbetegnelse FROM '^[^0-9]*([0-9]+)')), '')::int
        END) AS sortering,
        st_multi (a.geometri) AS geometri,
    st_multi (a.vejpunkt_geometri) AS vejpunkt_geometri
INTO basic_initialloading.adresse
FROM
    adresser a
    JOIN basic.navngivenvej nv ON a.navngivenvej_id = nv.id;
