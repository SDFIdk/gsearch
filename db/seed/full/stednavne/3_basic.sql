DROP TABLE IF EXISTS basic_initialloading.stednavn;

WITH agg_stednavne_officiel AS (
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
        array_agg(DISTINCT skrivemaade) AS skrivemaader
    FROM
        stednavne_udstilling.stednavne_udstilling u
    WHERE
        navnestatus = 'uofficielt'
    GROUP BY
    	objectid
),
agg_stednavne AS (
    SELECT
        su.objectid,
        id_lokalid,
        navnefoelgenummer,
        visningstekst as visningstekst,
        navnestatus,
        o.skrivemaade AS skrivemaade,
        u.skrivemaader AS skrivemaader_uofficielle,
        "type",
        subtype,
        kommunekode,
        st_force2d (geometri_udtyndet) AS geometri
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
        u.skrivemaader,
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
    skrivemaader_uofficielle,
    type AS stednavn_type,
    subtype AS stednavn_subtype,
    kommunekode,
    st_multi (st_union (geometri)) AS geometri,
    st_envelope (st_collect (geometri)) AS bbox
INTO basic_initialloading.stednavn
FROM
    agg_stednavne
GROUP BY
    id,
    visningstekst,
    visningstekst_nohyphen,
    skrivemaade,
    skrivemaader_uofficielle,
    type,
    subtype,
    kommunekode;