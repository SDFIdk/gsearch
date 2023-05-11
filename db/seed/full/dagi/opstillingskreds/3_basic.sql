DROP TABLE IF EXISTS basic.opstillingskreds;

WITH kommunenumre AS (
    SELECT
        o.opstillingskredsnummer,
        string_agg(k.kommunekode, ',') AS kommunekode
    FROM
        dagi_10.opstillingskreds o
        LEFT JOIN dagi_10.kommuneinddeling k ON st_intersects(k.geometri, o.geometri)
    GROUP BY
        o.opstillingskredsnummer
),
opstillingskredse AS (
    SELECT
        o.opstillingskredsnummer,
        o.navn,
        o.valgkredsnummer,
        s.storkredsnummer,
        s.navn AS storkredsnavn,
        st_force2d (o.geometri) AS geometri
    FROM
        dagi_500.opstillingskreds o
        JOIN dagi_500.storkreds s ON o.storkredslokalid = s.id_lokalid
    GROUP BY
        o.opstillingskredsnummer,
        o.navn,
        o.valgkredsnummer,
        storkredsnummer,
        storkredsnavn,
        o.geometri
)
SELECT
    o.navn || 'kredsen' AS visningstekst,
    o.opstillingskredsnummer,
    coalesce(o.navn, '') AS opstillingskredsnavn,
    o.valgkredsnummer,
    o.storkredsnummer,
    o.storkredsnavn,
    k.kommunekode,
    st_multi (st_union (o.geometri)) AS geometri,
    st_extent (o.geometri) AS bbox
INTO basic.opstillingskreds
FROM
    opstillingskredse o
LEFT JOIN kommunenumre k ON o.opstillingskredsnummer = k.opstillingskredsnummer
GROUP BY
    o.opstillingskredsnummer,
    o.navn,
    o.valgkredsnummer,
    storkredsnummer,
    storkredsnavn,
    k.kommunekode;
