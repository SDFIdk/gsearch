DROP TABLE IF EXISTS basic.politikreds;

WITH kommunenumre AS (
    SELECT
        p.politikredsnummer,
        string_agg(k.kommunekode, ',') AS kommunekode
    FROM
        dagi_10.politikreds p
        LEFT JOIN dagi_10.kommuneinddeling k ON st_intersects(k.geometri, p.geometri)
    GROUP BY
        p.politikredsnummer
),
    politikredse AS (
    SELECT
        p.politikredsnummer,
        p.navn,
        p.myndighedskode,
        st_force2d (p.geometri) AS geometri
    FROM
        dagi_500.politikreds p
    GROUP BY
        p.politikredsnummer,
        p.navn,
        p.myndighedskode,
        p.geometri
)
SELECT
    REPLACE(p.navn, 'Politi', 'Politikreds') AS visningstekst,
    p.politikredsnummer,
    coalesce(p.navn, '') AS navn,
    p.myndighedskode,
    k.kommunekode,
    st_multi (st_union (p.geometri)) AS geometri,
    st_extent (p.geometri) AS bbox
INTO basic.politikreds
FROM
    politikredse p
    LEFT JOIN kommunenumre k ON p.politikredsnummer = k.politikredsnummer
GROUP BY
    p.politikredsnummer,
    p.navn,
    p.myndighedskode,
    k.kommunekode;
