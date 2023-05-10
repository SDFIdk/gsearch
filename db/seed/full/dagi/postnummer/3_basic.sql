
DROP TABLE IF EXISTS basic.postnummer;

WITH kommunenumre AS (
    SELECT
        p.postnummer,
        string_agg(k.kommunekode, ',') AS kommunekode
    FROM
        dagi_10.postnummerinddeling p
        LEFT JOIN dagi_10.kommuneinddeling k ON st_intersects(k.geometri, p.geometri)
    GROUP BY
        p.postnummer
),
postnumre AS (
    SELECT
        COALESCE(p2.postnummer, p1.postnummer) AS postnummer,
        COALESCE(p2.navn, p1.navn) AS postnummernavn,
        COALESCE(p2.ergadepostnummer, p1.ergadepostnummer) AS ergadepostnummer,
        st_force2d (COALESCE(p2.geometri, p1.geometri)) AS geometri
    FROM
        dagi_10.postnummerinddeling p1
        LEFT JOIN dagi_500.postnummerinddeling p2 USING (postnummer))
SELECT
    p.postnummer || ' ' || p.postnummernavn AS visningstekst,
    coalesce(p.postnummer, '') AS postnummer,
    coalesce(p.postnummernavn, '') AS postnummernavn,
    (p.ergadepostnummer = 'true') AS ergadepostnummer,
    k.kommunekode,
    st_multi (st_union (p.geometri)) AS geometri,
    st_extent (p.geometri) AS bbox
INTO basic.postnummer
FROM
    postnumre p
    LEFT JOIN kommunenumre k ON p.postnummer = k.postnummer
GROUP BY
    p.postnummer,
    p.postnummernavn,
    p.ergadepostnummer,
    k.kommunekode;
