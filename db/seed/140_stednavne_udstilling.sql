DROP TABLE IF EXISTS stednavne.stednavne_udstilling;
CREATE TABLE IF NOT EXISTS stednavne.stednavne_udstilling (
        objectid int4 NULL,
        id_lokalid varchar NULL,
        navnefoelgenummer int4 NULL,
        navnestatus varchar NULL,
        skrivemaade varchar NULL,
        sprog varchar NULL,
        "type" varchar NULL,
        subtype varchar NULL,
        subtype_presentation varchar NULL,
        geometri public.geometry(geometry, 25832) NULL,
        geometri_udtyndet public.geometry(geometry, 25832) NULL,
        presentationstring varchar NULL,
        area float8 NULL,
        municipality_filter varchar NULL
        );


-- BEBYGGELSE

INSERT INTO stednavne.stednavne_udstilling 
SELECT 
objectid,
    id_lokalid,
    navnefoelgenummer,
    navnestatus,
    skrivemaade,
    sprog,
    'bebyggelse' as type,
    bebyggelsestype,
    initcap(bebyggelsestype) as subtype_presentation,
    geometri,
    st_simplify(geometri, 100, true) as geometri_udtyndet,
    skrivemaade as presentationstring,
    udregnet_areal as area,
    '0000' as municipality_filter
    FROM stednavne.bebyggelse;


    UPDATE stednavne.stednavne_udstilling 
    SET presentationstring = s.skrivemaade || ' (by i ' || p.navn || ')'
            FROM
            stednavne.stednavne_udstilling s JOIN
            dagi_10.postnummerinddeling p ON (ST_contains(p.geometri, s.geometri_udtyndet));



            -- BEGRAVELSESPLADS

            INSERT INTO stednavne.stednavne_udstilling 
            SELECT 
            objectid,
            id_lokalid,
            navnefoelgenummer,
            navnestatus,
            skrivemaade,
            sprog,
            'begravelsesplads' as type,
            begravelsespladstype,
            initcap(begravelsespladstype) as subtype_presentation,
            geometri,
            st_simplify(geometri, 100, true) as geometri_udtyndet,
            skrivemaade || ' (' || initcap(begravelsespladstype) || ' i ' || ')' as presentationstring,
                    udregnet_areal as area,
                    '0000' as municipality_filter
                    FROM stednavne.begravelsesplads;


                    -- BYGNING

                    INSERT INTO stednavne.stednavne_udstilling 
                    SELECT 
                    objectid,
                    id_lokalid,
                    navnefoelgenummer,
                    navnestatus,
                    skrivemaade,
                    sprog,
                    'bygning' as type,
                    bygningstype,
                    initcap(bygningstype) as subtype_presentation,
                    geometri,
                    st_simplify(geometri, 100, true) as geometri_udtyndet,
                    skrivemaade || ' (' || initcap(bygningstype) || ' i ' || ')' as presentationstring,
                            udregnet_areal as area,
                            '0000' as municipality_filter
                            FROM stednavne.bygning;

