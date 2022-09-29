CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.husnummer CASCADE;
CREATE TYPE api.husnummer AS
(
 id                       TEXT,
 kommunekode              TEXT,
 kommunenavn              TEXT,
 vejkode                  TEXT,
 vejnavn                  TEXT,
 husnummer                TEXT,
 postnummer               TEXT,
 postdistrikt             TEXT,
 adgangsadressebetegnelse TEXT,
 adgangspunkt_geometri    geometry,
 vejpunkt_geometri        geometry,
 rang1                    double precision,
 rang2                    double precision
 );

COMMENT ON TYPE api.husnummer IS 'Husnummer';
COMMENT ON COLUMN api.husnummer.id IS 'ID på husnummer';
COMMENT ON COLUMN api.husnummer.kommunekode IS 'Kommunekode for et husnummer';
COMMENT ON COLUMN api.husnummer.kommunenavn IS 'Kommunenavn for et husnummer';
COMMENT ON COLUMN api.husnummer.vejkode IS 'Vejkode for et husnummer';
COMMENT ON COLUMN api.husnummer.vejnavn is 'Vejnavn for et husnummer';
COMMENT ON COLUMN api.husnummer.husnummer is 'Husnummer';
COMMENT ON COLUMN api.husnummer.postnummer IS 'Postnummer for et husnummer';
COMMENT ON COLUMN api.husnummer.postdistrikt IS 'Postdistrikt for et husnummer';
COMMENT ON COLUMN api.husnummer.adgangsadressebetegnelse IS 'Adgangsadresse for et husnummer';
COMMENT ON COLUMN api.husnummer.vejpunkt_geometri IS 'Geometri for vejpunkt i valgt koordinatsystem';
COMMENT ON COLUMN api.husnummer.adgangspunkt_geometri IS 'Geometri for adgangspunkt i valgt koordinatsystem';

-- Husnummer script requires navngivenvej script to be executed first

DROP TABLE IF EXISTS basic.husnummer_mv;
WITH husnumre AS
(
 SELECT h.id_lokalid                       AS id,
 h.adgangsadressebetegnelse,
 h.husnummer,
 h.navngivenvej_id,
 n.vejnavn,
 h.vejkode,
 h.kommunekode,
 k.navn                             as kommunenavn,
 p.postnummer,
 p.navn                             as postdistrikt,
 st_force2d(COALESCE(ap.geometri))  as adgangspunkt_geometri,
 st_force2d(COALESCE(ap2.geometri)) as vejpunkt_geometri
 FROM dar.husnummer h
 JOIN dar.navngivenvej n ON n.id_lokalid = h.navngivenvej_id::uuid
 JOIN dar.postnummer p ON p.id_lokalid = h.postnummer_id::uuid
 JOIN dar.adressepunkt ap ON ap.id_lokalid = h.adgangspunkt_id
 JOIN dar.adressepunkt ap2 ON ap2.id_lokalid = h.vejpunkt_id
 JOIN dagi_500m_nohist_l1.kommuneinddeling k ON k.kommunekode = h.kommunekode
 )
SELECT h.id,
       h.adgangsadressebetegnelse,
       h.husnummer,
       h.vejnavn,
       h.vejkode,
       h.kommunekode,
       h.kommunenavn,
       h.postnummer,
       h.postdistrikt,
       h.navngivenvej_id,
       nv.textsearchable_plain_col       AS textsearchable_plain_col_vej,
       nv.textsearchable_unaccent_col    AS textsearchable_unaccent_col_vej,
       nv.textsearchable_phonetic_col    AS textsearchable_phonetic_col_vej,
       ROW_NUMBER() OVER
       (PARTITION BY h.navngivenvej_id ORDER BY
        (substring(h.husnummer FROM '[0-9]*'))::int,
        substring(h.husnummer FROM '[0-9]*([A-Z])') NULLS FIRST
       )                             AS sortering,
       st_multi(h.adgangspunkt_geometri) as adgangspunkt_geometri,
       st_multi(h.vejpunkt_geometri)     as vejpunkt_geometri
       INTO basic.husnummer_mv
       FROM husnumre h
       JOIN basic.navngivenvej_mv nv ON h.navngivenvej_id = nv.id;

       -- USE TEXTSEARCHABLE COLUMNS FROM NAVNGIVENVEJ INSTEAD OF RECOMPUTING THEM

       -- ALTER TABLE api.husnummer_mv DROP COLUMN IF EXISTS textsearchable_index_col_vej;
       -- ALTER TABLE api.husnummer_mv
       -- ADD COLUMN textsearchable_index_col_vej tsvector
       -- GENERATED ALWAYS AS
       --   (
               --    setweight(to_tsvector('api.septima_fts_config', split_part(coalesce(vejnavn, ''), ' ', 1)), 'A') ||
               --     setweight(to_tsvector('api.septima_fts_config', split_part(coalesce(vejnavn, ''), ' ', 2)), 'B') ||
               --     setweight(to_tsvector('api.septima_fts_config', split_part(coalesce(vejnavn, ''), ' ', 3)), 'C') ||
               --     setweight(to_tsvector('api.septima_fts_config', api.split_and_endsubstring(vejnavn, 4)), 'D')
               --   ) STORED
       -- ;

       -- ALTER TABLE api.husnummer_mv DROP COLUMN IF EXISTS textsearchable_rank_col_vej;
       -- ALTER TABLE api.husnummer_mv
       -- ADD COLUMN textsearchable_rank_col_vej tsvector
       -- GENERATED ALWAYS AS
       --   (
               --    setweight(to_tsvector('simple', split_part(coalesce(vejnavn, ''), ' ', 1)), 'A') ||
               --     setweight(to_tsvector('simple', split_part(coalesce(vejnavn, ''), ' ', 2)), 'B') ||
               --     setweight(to_tsvector('simple', split_part(coalesce(vejnavn, ''), ' ', 3)), 'C') ||
               --     setweight(to_tsvector('simple', api.split_and_endsubstring(vejnavn, 4)), 'D')
               --   ) STORED
       -- ;

       CREATE INDEX ON basic.husnummer_mv USING GIN (textsearchable_plain_col_vej);
       CREATE INDEX ON basic.husnummer_mv USING GIN (textsearchable_unaccent_col_vej);
       CREATE INDEX ON basic.husnummer_mv USING GIN (textsearchable_phonetic_col_vej);
       CREATE INDEX ON basic.husnummer_mv (lower(vejnavn), navngivenvej_id, sortering);

       DROP FUNCTION IF EXISTS api.husnummer(text, text, int, int);
CREATE OR REPLACE FUNCTION api.husnummer(input_tekst text, filters text, sortoptions int, rowlimit int)
    RETURNS SETOF api.husnummer
    LANGUAGE plpgsql
    STABLE
    AS
    $function$
    DECLARE
    max_rows           integer;
    query_string       TEXT;
    plain_query_string TEXT;
    husnummer          TEXT := '1=1';
    stmt               TEXT;
    BEGIN
    -- Initialize
    max_rows = 100;
    IF rowlimit > max_rows THEN
    RAISE 'rowlimit skal være <= %', max_rows;
    END IF;

    IF filters IS NULL THEN
    filters = '1=1';
    END IF;

    IF btrim(input_tekst) = Any ('{.,-, '', \,}') THEN
    input_tekst = '';
    END IF;

    -- If husnummer at end of input then store it and query rest on vejnavn
    IF regexp_replace(btrim(coalesce(input_tekst, '')), '^.* ', '') ~* '^[0-9]' THEN

    -- Get husnummer from input
    SELECT regexp_replace(btrim(coalesce(input_tekst)), '^.* ', '') INTO husnummer;

-- Build the query_string (converting vejnavn of input to phonetic)
    WITH tokens AS (
            SELECT UNNEST(
                string_to_array(
                    btrim(
                        replace(btrim(input_tekst), husnummer, '')
                        ),
                    ' ')
                )
            t)
    SELECT string_agg(fonetik.fnfonetik(t, 2), ':* <-> ') || ':*'
    FROM tokens
    INTO query_string;

    -- build the plain version of the query string for ranking purposes
    WITH tokens AS (
            SELECT UNNEST(
                string_to_array(
                    btrim(
                        replace(btrim(input_tekst), husnummer, '')
                        ),
                    ' ')
                )
            t)
    SELECT string_agg(t, ':* <-> ') || ':*'
    FROM tokens
    INTO plain_query_string;

husnummer := 'husnummer ilike ''' || husnummer || ''''; -- Set husnummer where statement to stored husnummer after it's been used to replace in inputstring

-- If no husnummer at end of input query as if it was just vejnavn
ELSE
WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_tekst), ' ')) t)
SELECT string_agg(fonetik.fnfonetik(t, 2), ':* <-> ') || ':*'
FROM tokens
INTO query_string;


WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_tekst), ' ')) t)
SELECT string_agg(t, ':* <-> ') || ':*'
FROM tokens
INTO plain_query_string;

END IF;

    -- Execute and return the result
IF (SELECT COALESCE(forekomster, 0)
        FROM basic.tekst_forekomst
        WHERE ressource = 'adresse'
        AND lower(input_tekst) = tekstelement) > 1000
    AND filters = '1=1' THEN
    stmt = format(E'SELECT
            id::text, kommunekode::text, kommunenavn::text, vejkode::text, vejnavn::text, 
            husnummer::text, postnummer::text, postdistrikt::text, adgangsadressebetegnelse::text,
            vejpunkt_geometri, adgangspunkt_geometri,
            0::float AS rank1,
            0::float AS rank2
            FROM
            basic.husnummer_mv
            WHERE
            lower(vejnavn) >= ''%s'' AND lower(vejnavn) <= ''%s'' || ''å''
            ORDER BY
            lower(vejnavn), navngivenvej_id, sortering
            LIMIT $3;', input_tekst, input_tekst);
    --   RAISE notice '%', stmt;
    RETURN QUERY EXECUTE stmt using query_string, plain_query_string, rowlimit;
    ELSE
    stmt = format(E'SELECT
            id::text, kommunekode::text, kommunenavn::text, vejkode::text, vejnavn::text, 
            husnummer::text, postnummer::text, postdistrikt::text, adgangsadressebetegnelse::text,
            vejpunkt_geometri, adgangspunkt_geometri,
            basic.combine_rank($2, $2, textsearchable_plain_col_vej, textsearchable_unaccent_col_vej, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
            ts_rank_cd(textsearchable_phonetic_col_vej, to_tsquery(''simple'',$1))::double precision AS rank2
            FROM
            basic.husnummer_mv
            WHERE
            (textsearchable_phonetic_col_vej @@ to_tsquery(''simple'', $1)
             OR textsearchable_plain_col_vej @@ to_tsquery(''simple'', $2))
            AND %s
            ORDER BY
            rank1 desc, rank2 desc,
            adgangsadressebetegnelse
            LIMIT $3;', filters);
    RETURN QUERY EXECUTE stmt using query_string, plain_query_string, rowlimit;
    END IF;
    END
    $function$;

    -- Test cases:
    /*
       SELECT (api.husnummer('park allé 2',NULL, 1, 100)).*;
       SELECT (api.husnummer('ålbor 5',NULL, 1, 100)).*;
       SELECT (api.husnummer('søborg h 100',NULL, 1, 100)).*;
       SELECT (api.husnummer('holbæk',NULL, 1, 100)).*;
       SELECT (api.husnummer('vinkel 3',NULL, 1, 100)).*;
       SELECT (api.husnummer('frederik 7',NULL, 1, 100)).*;
       SELECT (api.husnummer('san',NULL, 1, 100)).*;
       SELECT (api.husnummer('s',NULL, 1, 100)).*;
     */
