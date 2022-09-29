DROP TYPE IF EXISTS api.adresse CASCADE;
CREATE TYPE api.adresse AS (
        id TEXT,
        municpalityCode TEXT,
        municipalityName TEXT,
        streetCode TEXT,
        streetName TEXT,
        streetBuildingIdentifier TEXT,
        floorIdentifier TEXT,
        doorIdentifier TEXT,
        postcodeIdentifier TEXT,
        districtName TEXT,
        presentationstring TEXT,
        adgangspunkt_geometri geometry,
        vejpunkt_geometri geometry,
        rang1 double precision,
        rang2 double precision
        );  

COMMENT ON TYPE api.adresse IS 'Adresse';
COMMENT ON COLUMN api.adresse.id IS 'Id på adresse';
COMMENT ON COLUMN api.adresse.municpalityCode IS 'Kommunekode for en adresse';
COMMENT ON COLUMN api.adresse.municipalityName IS 'Kommunenavn for en adresse';
COMMENT ON COLUMN api.adresse.streetCode IS 'vejkode for en adresse';
COMMENT ON COLUMN api.adresse.streetName is 'vejnavn for en adresse';
COMMENT ON COLUMN api.adresse.streetBuildingIdentifier is 'husnummertekst på adresse';
COMMENT ON COLUMN api.adresse.floorIdentifier is 'etagebetegnelse for adresse';
COMMENT ON COLUMN api.adresse.doorIdentifier is 'dørbetegnelse for adresse';
COMMENT ON COLUMN api.adresse.postcodeIdentifier IS 'postnummer på adresse';
COMMENT ON COLUMN api.adresse.districtName IS 'Postnummer navn på adresse';
COMMENT ON COLUMN api.adresse.presentationstring IS 'Præsentationsform for en adresse';
COMMENT ON COLUMN api.adresse.vejpunkt_geometri IS 'Husnummergeometri på adresse for vejpunkt i valgt koordinatsystem';
COMMENT ON COLUMN api.adresse.adgangspunkt_geometri IS 'Husnummergeometri på adresse for adgangspunkt i valgt koordinatsystem';

DROP TABLE IF EXISTS basic.adresse;
with adresser AS 
(
 SELECT
 a.id,
 a.husnummer,
 a.adressebetegnelse,
 a.dørbetegnelse as doerbetegnelse,
 a.etagebetegnelse,
 h.husnummertekst,
 h.navngivenvej AS vejid,
 h.sortering AS husnummer_sortering,
 n.vejnavn,
 h.vejkode,
 h.kommunekode,
 k.navn as kommunenavn,
 p.postnr as postnr,
 p.navn as postdistrikt,
 st_force2d(COALESCE(ap.geometri)) as adgangspunkt_geometri,
 st_force2d(COALESCE(ap2.geometri)) as vejpunkt_geometri
 FROM
 dar.adresse a
 JOIN 
(SELECT
 *,
 ROW_NUMBER() OVER
 (PARTITION BY navngivenvej ORDER BY
  (substring(husnummertekst::text FROM '[0-9]*')),
  substring(husnummertekst::text FROM '[0-9]*([A-Z])') NULLS FIRST
 ) AS sortering
 FROM dar.husnummer
 ) h ON a.husnummer = h.id
JOIN dar.navngivenvej n ON n.id = h.navngivenvej::uuid
JOIN dar.postnummer p ON p.id = h.postnummer::uuid
JOIN dar.adressepunkt ap ON ap.id = h.adgangspunkt
JOIN dar.adressepunkt ap2 ON ap2.id = h.vejpunkt
JOIN dagi_500.kommuneinddeling k ON k.kommunekode = h.kommunekode
)
SELECT
a.id,
    a.adressebetegnelse as titel,
    a.vejnavn,
    a.vejkode,
    coalesce(a.husnummertekst::text, ''::text) AS husnummertekst,
    coalesce(a.etagebetegnelse, ''::text) AS etagebetegnelse,
    coalesce(a.doerbetegnelse, ''::text) AS doerbetegnelse,
    a.postnr AS postnummer,
    a.postdistrikt,
    a.kommunekode,
    a.kommunenavn,
    nv.textsearchable_plain_col AS textsearchable_plain_col_vej,
    nv.textsearchable_unaccent_col AS textsearchable_unaccent_col_vej,
    nv.textsearchable_phonetic_col AS textsearchable_phonetic_col_vej,
    a.vejid,
    a.husnummer_sortering,
    ROW_NUMBER() OVER (
            PARTITION BY a.husnummer
            ORDER BY
            CASE lower(a.etagebetegnelse)
            WHEN '' THEN -10
            WHEN 'k3' THEN -3
            WHEN 'k2' THEN -2
            WHEN 'kl' THEN -1
            WHEN 'st' THEN 0
            ELSE NULLIF((substring(a.etagebetegnelse FROM '[0-9]*')), '')::int
            END,
            CASE lower(a.doerbetegnelse)
            WHEN 'tv' THEN -3
            WHEN 'mf' THEN -2
            WHEN 'th' THEN -1
            ELSE NULLIF((substring(a.doerbetegnelse FROM '^[^0-9]*([0-9]+)')), '')::int
            END
            ) AS sortering,
    st_multi(adgangspunkt_geometri) as adgangspunkt_geometri,
    st_multi(vejpunkt_geometri) as vejpunkt_geometri
    INTO
    basic.adresse
    FROM 
    adresser a
    JOIN basic.navngivenvej nv ON a.vejid = nv.id
    ;

    -- USE TEXTSEARCHABLE COLUMNS FROM NAVNGIVENVEJ INSTEAD OF RECOMPUTING THEM

    -- append husnummer, etage, and dør
    ALTER TABLE basic.adresse DROP COLUMN IF EXISTS textsearchable_plain_col;
    ALTER TABLE basic.adresse
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS
    (
     textsearchable_plain_col_vej || 
     setweight(to_tsvector('simple', husnummertekst), 'D') ||
     setweight(to_tsvector('simple', etagebetegnelse), 'D') ||
     setweight(to_tsvector('simple', doerbetegnelse), 'D')
    ) STORED
    ;

    ALTER TABLE basic.adresse DROP COLUMN IF EXISTS textsearchable_unaccent_col;
    ALTER TABLE basic.adresse
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS
    (
     textsearchable_unaccent_col_vej || 
     setweight(to_tsvector('simple', husnummertekst), 'D') ||
     setweight(to_tsvector('simple', etagebetegnelse), 'D') ||
     setweight(to_tsvector('simple', doerbetegnelse), 'D')
    ) STORED
    ;

    ALTER TABLE basic.adresse DROP COLUMN IF EXISTS textsearchable_phonetic_col;
    ALTER TABLE basic.adresse
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS
    (
     textsearchable_phonetic_col_vej || 
     setweight(to_tsvector('simple', husnummertekst), 'D') ||
     setweight(to_tsvector('simple', etagebetegnelse), 'D') ||
     setweight(to_tsvector('simple', doerbetegnelse), 'D')
    ) STORED
    ;

    CREATE INDEX ON basic.adresse USING GIN (textsearchable_plain_col);
    CREATE INDEX ON basic.adresse USING GIN (textsearchable_unaccent_col);
    CREATE INDEX ON basic.adresse USING GIN (textsearchable_phonetic_col);
    CREATE INDEX ON basic.adresse (lower(vejnavn), vejid, husnummer_sortering, sortering);

    DROP FUNCTION IF EXISTS api.adresse(text, text, int, int);
CREATE OR REPLACE FUNCTION api.adresse(input_tekst text, filters text, sortoptions int, rowlimit int)
    RETURNS SETOF api.adresse
    LANGUAGE plpgsql
    STABLE
    AS $function$
    DECLARE 
    max_rows integer;
    input_vejnavn TEXT;
    input_husnr_etage_doer TEXT;
    vej_query_string TEXT;
    plain_vej_query_string TEXT;
    husnr_etage_doer_query_string TEXT;
    query_string TEXT;
    plain_query_string TEXT;
    stmt TEXT;
    BEGIN
    -- Initialize
    max_rows = 100;
    IF rowlimit > max_rows THEN
    RAISE 'rowlimit skal være <= %', max_rows;
    END IF;

    IF filters IS NULL THEN
    filters = '1=1';
    END IF;

    IF btrim(input_tekst) = Any('{.,-, '', \,}')  THEN
    input_tekst = '';
    END IF;

    SELECT btrim((REGEXP_MATCH(btrim(input_tekst), '([^\d]+) ?(.*)'))[1]) INTO input_vejnavn;
    SELECT btrim((REGEXP_MATCH(btrim(input_tekst), '([^\d]+) ?(.*)'))[2]) INTO input_husnr_etage_doer;


    WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_vejnavn), ' ')) t)
    SELECT string_agg(fonetik.fnfonetik(t,2), ':* <-> ') || ':*' FROM tokens INTO vej_query_string;

    WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_vejnavn), ' ')) t)
    SELECT string_agg(t, ':* <-> ') || ':*' FROM tokens INTO plain_vej_query_string;

    WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_husnr_etage_doer), ' ')) t)
    SELECT string_agg(t, ' <-> ') FROM tokens INTO husnr_etage_doer_query_string;

    IF husnr_etage_doer_query_string IS NOT NULL THEN
    SELECT vej_query_string || ' <-> ' || husnr_etage_doer_query_string INTO query_string;
    ELSE
    SELECT vej_query_string INTO query_string;
    END IF;

    IF husnr_etage_doer_query_string IS NOT NULL THEN
    SELECT plain_vej_query_string || ' <-> ' || husnr_etage_doer_query_string INTO plain_query_string;
    ELSE
    SELECT plain_vej_query_string INTO plain_query_string;
    END IF;

    IF (SELECT COALESCE(forekomster, 0) FROM basic.tekst_forekomst WHERE ressource = 'adresse' AND lower(input_vejnavn) = tekstelement) > 1000 
    AND filters = '1=1' THEN
    stmt = format(E'SELECT
            id::text, kommunekode::text, kommunenavn::text, vejkode::text, vejnavn::text, 
            husnummertekst::text, etagebetegnelse::text, doerbetegnelse::text, 
            postnummer::text, postdistrikt::text, titel::text, 
            vejpunkt_geometri, adgangspunkt_geometri,
            0::float AS rank1,
            0::float AS rank2
            FROM
            basic.adresse
            WHERE
            lower(vejnavn) >= ''%s'' AND lower(vejnavn) <= ''%s'' || ''å''
            ORDER BY
            lower(vejnavn), vejid, husnummer_sortering, sortering
            LIMIT $3
            ;', input_tekst, input_tekst);
    RAISE NOTICE 'stmt=%', stmt;
    RETURN QUERY EXECUTE stmt using query_string, plain_query_string, rowlimit;
    ELSE
    -- Execute and return the result
    stmt = format(E'SELECT
            id::text, kommunekode::text, kommunenavn::text, vejkode::text, vejnavn::text, 
            husnummertekst::text, etagebetegnelse::text, doerbetegnelse::text, 
            postnummer::text, postdistrikt::text, titel::text, 
            vejpunkt_geometri, adgangspunkt_geometri,
            basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
            ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rank2
            FROM
            basic.adresse
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
            AND %s
            ORDER BY
            rank1 desc, rank2 desc,
            lower(vejnavn), vejid, husnummer_sortering, sortering
            LIMIT $3
            ;', filters);
    RAISE NOTICE 'stmt=%', stmt;

    RETURN QUERY EXECUTE stmt using query_string, plain_query_string, rowlimit;
    END IF;
    END
    $function$
    ;


    -- Test cases:
    /*
       SELECT (api.adresse('park allé 2 1',NULL, 1, 100)).*;
       SELECT (api.adresse('ålbor 5 1. th.',NULL, 1, 100)).*;
       SELECT (api.adresse('søborg h 100',NULL, 1, 100)).*;
       SELECT (api.adresse('aarhus 3',NULL, 1, 100)).*;
       SELECT (api.adresse('århus 3',NULL, 1, 100)).*;
       SELECT (api.adresse('holbæk',NULL, 1, 100)).*;
       SELECT (api.adresse('vinkel 3',NULL, 1, 100)).*;
       SELECT (api.adresse('sve',NULL, 1, 100)).*;
       SELECT (api.adresse('s',NULL, 1, 100)).*;
     */


