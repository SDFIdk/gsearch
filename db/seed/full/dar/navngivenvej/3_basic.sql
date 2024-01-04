DROP TABLE IF EXISTS basic_initialloading.navngivenvej;

WITH kommunenumre AS (
    SELECT
        n.id,
        string_agg(k.kommunekode, ',') AS kommunekode
    FROM
        dar.navngivenvej n
        LEFT JOIN dagi_10.kommuneinddeling k ON st_intersects(k.geometri, n.geometri)
    GROUP BY
        n.id
),
vejnavne AS (
    SELECT
        n.id AS id,
        n.vejnavn,
        p.postnr AS postnummer,
        p.navn AS postnummernavn,
        n.geometri AS geometri
    FROM
        dar.navngivenvej n
        JOIN dar.navngivenvejpostnummer nvp ON (nvp.navngivenvej_id = n.id)
        JOIN dar.postnummer p ON (nvp.postnummer_id = p.id)
    GROUP BY
        n.id,
        n.vejnavn,
        p.postnr,
        p.navn,
        n.geometri
)
    --SELECT v.vejnavn || '(' || v.postnummer[1] || ' - ' || v.postnummer[-1] || ')' AS visningstekst,
SELECT
    v.vejnavn AS visningstekst,
    v.id,
    coalesce(v.vejnavn, '') AS vejnavn,
    string_agg(DISTINCT v.postnummer, ',') AS postnummer,
    string_agg(DISTINCT v.postnummernavn, ',') AS postnummernavn,
    k.kommunekode,
    st_multi (st_union (geometri)) AS geometri,
    st_envelope (st_collect (v.geometri)) AS bbox
INTO basic_initialloading.navngivenvej
FROM
    vejnavne v
    LEFT JOIN kommunenumre k ON v.id = k.id
GROUP BY
    v.id,
    v.vejnavn,
    k.kommunekode;
