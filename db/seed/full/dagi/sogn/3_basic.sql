DROP TABLE IF EXISTS basic_initialloading.sogn;

WITH kommunenumre AS (
    SELECT
        s.sognekode,
        string_agg(k.kommunekode, ',') AS kommunekode
    FROM
        dagi_10.sogneinddeling s
        LEFT JOIN dagi_10.kommuneinddeling k ON st_intersects(k.geometri, s.geometri)
    GROUP BY
        s.sognekode
),
sogne AS (
    SELECT
        s.sognekode,
        s.navn,
        st_force2d (s.geometri) AS geometri
    FROM
        dagi_500.sogneinddeling s
    GROUP BY
        s.sognekode,
        s.navn,
        s.geometri
)
SELECT
    s.navn || ' sogn' AS visningstekst,
    s.sognekode,
    s.navn AS sognenavn,
    k.kommunekode,
    st_multi (st_union (s.geometri)) AS geometri,
    st_extent (s.geometri) AS bbox
INTO basic_initialloading.sogn
FROM
    sogne s
    LEFT JOIN kommunenumre k ON s.sognekode = k.sognekode
GROUP BY
    s.sognekode,
    s.navn,
    k.kommunekode;
