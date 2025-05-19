DROP TABLE IF EXISTS basic_initialloading.stednavn;

WITH stednavne_officiel AS (
    SELECT
        objectid,
        skrivemaade
    FROM
        stednavne_udstilling.stednavne_udstilling
    WHERE
        navnestatus <> 'uofficielt'
),
agg_stednavne_uofficiel AS (
    SELECT
        objectid,
        string_agg(skrivemaade, ',' ORDER BY skrivemaade ASC) AS skrivemaader
    FROM
        stednavne_udstilling.stednavne_udstilling
    WHERE
        navnestatus = 'uofficielt'
    GROUP BY
        objectid
),
agg_stednavne AS (
    SELECT
        su.objectid,
        su.id_lokalid,
        su.navnefoelgenummer,
        su.visningstekst,
        su.visningstekst_uden_hjaelpetekst,
        so.skrivemaade AS skrivemaade,
        asu.skrivemaader AS skrivemaade_uofficiel,
        su.navnestatus,
        su."type",
        su.subtype,
        su.kommunekode,
        st_force2d (su.geometri_udtyndet) AS geometri
    FROM
        stednavne_udstilling.stednavne_udstilling su
    LEFT JOIN stednavne_officiel so ON
        so.objectid = su.objectid
    LEFT JOIN agg_stednavne_uofficiel asu ON
        asu.objectid = su.objectid
    GROUP BY
        su.objectid,
        su.id_lokalid,
        su.navnefoelgenummer,
        su.visningstekst,
        su.visningstekst_uden_hjaelpetekst,
        so.skrivemaade,
        asu.skrivemaader,
        su.navnestatus,
        su."type",
        su.subtype,
        su.kommunekode,
        su.geometri_udtyndet
),
visningstekst_uofficel_merge AS (
    SELECT
        objectid,
        visningstekst_uden_hjaelpetekst, -- Needed for not getting dublicates for stednavne with mulitple uofficel skrivemaader
        REPLACE(agg_s.visningstekst, '(', '(' || skrivemaade || ', ') AS visningstekst -- Uofficel skrivemaade shall always have the officel skrivemadde in visningstekst
    FROM
        agg_stednavne agg_s
    WHERE
        navnestatus = 'uofficielt'
      AND skrivemaade IS NOT NULL -- Nogle stednavne har ikke en officel skrivemaade, dem ønsker vi ikke at matche med
)
SELECT
    DISTINCT id_lokalid AS id, -- Need DISTINCT for not getting duplicates of the same row if there is two or more skrivemaade_uofficel
    (
        CASE WHEN agg_s.navnestatus = 'uofficielt' AND skrivemaade IS NOT NULL -- Nogle stednavne har ikke en officel skrivemaade, dem ønsker vi ikke at matche med
            THEN
                 vum.visningstekst
            ELSE
                 agg_s.visningstekst
            END
        ) AS visningstekst,
    (
        CASE WHEN agg_s.navnestatus = 'uofficielt' AND skrivemaade IS NOT NULL -- Nogle stednavne har ikke en officel skrivemaade, dem ønsker vi ikke at matche med
            THEN
                 replace(replace(vum.visningstekst, ' - ', ' '), '-', ' ')
            ELSE
                 replace(replace(agg_s.visningstekst, ' - ', ' '), '-', ' ')
            END
        ) AS visningstekst_nohyphen,
    agg_s.visningstekst_uden_hjaelpetekst,
    skrivemaade,
    skrivemaade_uofficiel,
    type AS stednavn_type,
    subtype AS stednavn_subtype,
    kommunekode,
    st_multi (st_union (geometri)) AS geometri,
    st_envelope (st_collect (geometri)) AS bbox
INTO basic_initialloading.stednavn
FROM
    agg_stednavne agg_s
    LEFT JOIN visningstekst_uofficel_merge vum ON
        vum.objectid = agg_s.objectid
        AND vum.visningstekst_uden_hjaelpetekst = agg_s.visningstekst_uden_hjaelpetekst -- Needed for not getting dublicates for stednavne with mulitple uofficel skrivemaader
GROUP BY
    id,
    vum.visningstekst,
    agg_s.visningstekst,
    visningstekst_nohyphen,
    agg_s.visningstekst_uden_hjaelpetekst,
    skrivemaade,
    skrivemaade_uofficiel,
    agg_s.navnestatus,
    type,
    subtype,
    kommunekode;