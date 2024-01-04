DROP TABLE IF EXISTS basic_initialloading.stednavn;

WITH stednavne AS (
    SELECT
        objectid,
        id_lokalid,
        coalesce(visningstekst, '') AS visningstekst,
        navnestatus,
        skrivemaade,
        type,
        subtype,
        kommunekode,
        st_force2d (geometri_udtyndet) AS geometri
    FROM
        stednavne_udstilling.stednavne_udstilling
),
agg_stednavne_officiel AS (
    SELECT
        objectid,
        skrivemaade
    FROM
        stednavne_udstilling.stednavne_udstilling o
    WHERE
        navnestatus <> 'uofficielt'
),
agg_stednavne_uofficiel AS (
    SELECT
        objectid,
        skrivemaade
    FROM
        stednavne_udstilling.stednavne_udstilling u
    WHERE
        navnestatus = 'uofficielt'
),
agg_stednavne AS (
    SELECT
        su.objectid,
        id_lokalid,
        navnefoelgenummer,
        visningstekst as visningstekst,
        navnestatus,
        o.skrivemaade AS skrivemaade,
        u.skrivemaade AS uofficielle_skrivemaader,
        "type",
        subtype,
        kommunekode,
        geometri_udtyndet as geometri
    FROM
        stednavne_udstilling.stednavne_udstilling su
    LEFT JOIN agg_stednavne_officiel o ON
        o.objectid = su.objectid
    LEFT JOIN agg_stednavne_uofficiel u ON
        u.objectid = su.objectid
    GROUP BY
        su.objectid,
        id_lokalid,
        navnefoelgenummer,
        visningstekst,
        o.skrivemaade,
        u.skrivemaade,
        "type",
        subtype,
        kommunekode,
        geometri_udtyndet
)
SELECT
    id_lokalid AS id,
    visningstekst,
    replace(replace(visningstekst, ' - ', ' '), '-', ' ') AS visningstekst_nohyphen,
    skrivemaade,
    (
        CASE WHEN uofficielle_skrivemaader IS NULL THEN
            ''
        ELSE
            uofficielle_skrivemaader
        END) AS skrivemaade_uofficiel,
    (
        CASE WHEN uofficielle_skrivemaader IS NULL THEN
            ''
        ELSE
            replace(uofficielle_skrivemaader, '-', ' ')
        END) AS skrivemaade_uofficiel_nohyphen,
    type AS stednavn_type,
    subtype AS stednavn_subtype,
    kommunekode,
    st_multi (st_union (geometri)) AS geometri,
    st_envelope (st_collect (geometri)) AS bbox INTO basic_initialloading.stednavn
FROM
    agg_stednavne
GROUP BY
    id,
    visningstekst,
    visningstekst_nohyphen,
    skrivemaade,
    skrivemaade_uofficiel,
    skrivemaade_uofficiel_nohyphen,
    type,
    subtype,
    kommunekode;
    