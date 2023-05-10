
DROP TABLE IF EXISTS basic.region;

WITH kommunenumre AS (
    SELECT
        r.regionskode,
        string_agg(k.kommunekode, ',') AS kommunekode
    FROM
        dagi_10.regionsinddeling r
        LEFT JOIN dagi_10.kommuneinddeling k ON st_intersects(k.geometri, r.geometri)
    GROUP BY
        r.regionskode
),
regioner AS (
    SELECT
        r.regionskode,
        r.navn,
        st_force2d (r.geometri) AS geometri
    FROM
        dagi_500.regionsinddeling r
    GROUP BY
        r.regionskode,
        r.navn,
        r.geometri
)
SELECT
    r.navn AS visningstekst,
    r.regionskode,
    coalesce(r.navn, '') AS regionsnavn,
    k.kommunekode,
    st_multi (st_union (r.geometri)) AS geometri,
    st_extent (r.geometri) AS bbox
INTO basic.region
FROM
    regioner r
    LEFT JOIN kommunenumre k ON r.regionskode = k.regionskode
GROUP BY
    r.regionskode,
    r.navn,
    k.kommunekode;
