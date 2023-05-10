
DROP TABLE IF EXISTS basic.retskreds;

WITH kommunenumre AS (
    SELECT
        r.retskredsnummer,
        string_agg(k.kommunekode, ',') AS kommunekode
    FROM
        dagi_10.retskreds r
        LEFT JOIN dagi_10.kommuneinddeling k ON st_intersects(k.geometri, r.geometri)
    GROUP BY
        r.retskredsnummer
),
retskredse AS (
    SELECT
        r.retskredsnummer,
        r.navn,
        r.myndighedskode,
        st_force2d (r.geometri) AS geometri
    FROM
        dagi_500.retskreds r
    GROUP BY
        r.retskredsnummer,
        r.navn,
        r.myndighedskode,
        r.geometri
)
SELECT
    r.navn AS visningstekst,
    r.retskredsnummer,
    coalesce(r.navn, '') AS retkredsnavn,
    r.myndighedskode,
    k.kommunekode,
    st_multi (st_union (r.geometri)) AS geometri,
    st_extent (r.geometri) AS bbox
INTO basic.retskreds
FROM
    retskredse r
    LEFT JOIN kommunenumre k ON r.retskredsnummer = k.retskredsnummer
GROUP BY
    r.retskredsnummer,
    r.navn,
    r.myndighedskode,
    k.kommunekode;
