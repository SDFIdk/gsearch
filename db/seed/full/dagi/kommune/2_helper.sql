WITH kommuner AS (
    SELECT
        k.kommunekode,
        k.navn,
        r.regionskode,
        st_force2d (k.geometri) AS geometri
    FROM
        dagi_10.kommuneinddeling k
            LEFT JOIN dagi_500.regionsinddeling r ON k.regionlokalid = r.id_lokalid
)
SELECT
    (
        CASE
            WHEN
                k.kommunekode = '0101'
                THEN
                k.navn || 's Kommune'
            WHEN
                k.kommunekode = '0411'
                THEN
                k.navn
            ELSE
                k.navn || ' Kommune'
            END
        ) AS visningstekst,
    k.kommunekode,
    k.navn AS kommunenavn,
    k.regionskode,
    st_multi (st_union (k.geometri)) AS geometri,
    st_extent (k.geometri) AS bbox
INTO dagi_10.kommune_helper_stednavne
FROM
    kommuner k
GROUP BY
    k.kommunekode,
    k.navn,
    k.regionskode;
