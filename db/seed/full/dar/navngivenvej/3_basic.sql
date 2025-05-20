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
postnumre AS (
    SELECT
        n.id,
        string_agg(DISTINCT p.postnr, ',') AS postnummer,
        string_agg(DISTINCT p.navn, ',') AS postnummernavn,
        string_agg (
                p.postnr || ' ' || p.navn,
                ', '
                ORDER BY
                    p.postnr,
                    p.navn
        ) supplementtext
    FROM
        dar.navngivenvej n
        JOIN dar.navngivenvejpostnummer nvp ON (nvp.navngivenvej_id = n.id)
        JOIN dar.postnummer p ON (nvp.postnummer_id = p.id)
    GROUP BY
        n.id
),
supplerendebynavne AS (
    SELECT
        n.id,
        string_agg(DISTINCT sb.navn, ',') AS supplerendebynavn
    FROM
        dar.navngivenvej n
        -- Er under 50% af navngiven veje der har et supplerende bynavn tilknyttet
        LEFT JOIN dar.navngivenvejsupplerendebynavn nvsb ON (nvsb.navngivenvej_id = n.id)
        LEFT JOIN dar.supplerendebynavn sb ON (nvsb.supplerendebynavn_id = sb.id)
    GROUP BY
        n.id
),
vejnavne AS (
    SELECT
        n.id AS id,
        n.vejnavn,
        n.geometri AS geometri
    FROM
        dar.navngivenvej n
    GROUP BY
        n.id,
        n.vejnavn,
        n.geometri
)
    --SELECT v.vejnavn || '(' || v.postnummer[1] || ' - ' || v.postnummer[-1] || ')' AS visningstekst,
SELECT
    v.vejnavn || ' (' || p.supplementtext || ')' AS visningstekst,
    v.id,
    v.vejnavn,
    sbn.supplerendebynavn,
    p.postnummer,
    p.postnummernavn,
    k.kommunekode,
    st_multi (st_union (geometri)) AS geometri,
    st_envelope (st_collect (v.geometri)) AS bbox
INTO basic_initialloading.navngivenvej
FROM
    vejnavne v
    LEFT JOIN kommunenumre k ON v.id = k.id
    LEFT JOIN postnumre p ON v.id = p.id
    LEFT JOIN supplerendebynavne sbn ON v.id = sbn.id
GROUP BY
    v.id,
    v.vejnavn,
    sbn.supplerendebynavn,
    p.postnummer,
    p.postnummernavn,
    p.supplementtext,
    k.kommunekode;
