CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.retskreds CASCADE;
CREATE TYPE api.retskreds AS
(
 id             TEXT,
 retkredsnavn   TEXT,
 praesentation  TEXT,
 myndighedskode TEXT,
 geometri       geometry,
 bbox           geometry,
 rang1          double precision,
 rang2          double precision
 );

COMMENT ON TYPE api.retskreds IS 'Retskreds';
COMMENT ON COLUMN api.retskreds.id IS 'Retskredsnummer';
COMMENT ON COLUMN api.retskreds.retkredsnavn IS 'Navn på retskreds';
COMMENT ON COLUMN api.retskreds.praesentation IS 'Præsentationsform for en retskreds';
COMMENT ON COLUMN api.retskreds.myndighedskode IS 'Retskredsens myndighedskode. Er unik for hver retskreds. 4 cifre.';
COMMENT ON COLUMN api.retskreds.geometri IS 'Geometri i valgt koordinatsystem';
COMMENT ON COLUMN api.retskreds.bbox IS 'Geometriens boundingbox i valgt koordinatsystem';

DROP TABLE IF EXISTS basic.retskreds_mv;
WITH retskredse AS
(
 SELECT r.retskredsnummer,
 r.navn,
 r.myndighedskode,
 st_force2d(r.geometri) AS geometri
 FROM dagi_500m_nohist_l1.retskreds r
 )
SELECT r.navn                         AS praesentation,
       r.retskredsnummer,
       coalesce(r.navn, '')           AS retkredsnavn,
       r.myndighedskode,
       st_multi(st_union(r.geometri)) AS geometri,
       st_extent(r.geometri)          AS bbox
       INTO basic.retskreds_mv
       FROM retskredse r
       GROUP BY r.retskredsnummer, r.navn, r.myndighedskode;

       ALTER TABLE basic.retskreds_mv
       DROP COLUMN IF EXISTS textsearchable_plain_col;
       ALTER TABLE basic.retskreds_mv
       ADD COLUMN textsearchable_plain_col tsvector
       GENERATED ALWAYS AS
       (
        setweight(to_tsvector('simple', split_part(retkredsnavn, ' ', 1)), 'A') ||
        setweight(to_tsvector('simple', split_part(retkredsnavn, ' ', 2)), 'B') ||
        setweight(to_tsvector('simple', split_part(retkredsnavn, ' ', 3)), 'C') ||
        setweight(to_tsvector('simple', basic.split_and_endsubstring(retkredsnavn, 4)), 'D')
       ) STORED;

       ALTER TABLE basic.retskreds_mv
       DROP COLUMN IF EXISTS textsearchable_unaccent_col;
       ALTER TABLE basic.retskreds_mv
       ADD COLUMN textsearchable_unaccent_col tsvector
       GENERATED ALWAYS AS
       (
        setweight(to_tsvector('basic.septima_fts_config', split_part(retkredsnavn, ' ', 1)), 'A') ||
        setweight(to_tsvector('basic.septima_fts_config', split_part(retkredsnavn, ' ', 2)), 'B') ||
        setweight(to_tsvector('basic.septima_fts_config', split_part(retkredsnavn, ' ', 3)), 'C') ||
        setweight(
            to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring(retkredsnavn, 4)),
            'D')
       ) STORED;

       ALTER TABLE basic.retskreds_mv
       DROP COLUMN IF EXISTS textsearchable_phonetic_col;
       ALTER TABLE basic.retskreds_mv
       ADD COLUMN textsearchable_phonetic_col tsvector
       GENERATED ALWAYS AS
       (
        setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(retkredsnavn, ' ', 1), 2)), 'A') ||
        setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(retkredsnavn, ' ', 2), 2)), 'B') ||
        setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(retkredsnavn, ' ', 3), 2)), 'C') ||
        setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik(retkredsnavn, 4)), 'D')
       ) STORED;

       CREATE INDEX ON basic.retskreds_mv USING GIN (textsearchable_plain_col);
       CREATE INDEX ON basic.retskreds_mv USING GIN (textsearchable_unaccent_col);
       CREATE INDEX ON basic.retskreds_mv USING GIN (textsearchable_phonetic_col);

       DROP FUNCTION IF EXISTS api.retskreds(text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.retskreds(input_tekst text, filters text, sortoptions integer, rowlimit integer)
    RETURNS SETOF api.retskreds
    LANGUAGE plpgsql
    STABLE
    AS
    $function$
    DECLARE
    max_rows           integer;
    query_string       TEXT;
    plain_query_string TEXT;
    stmt               TEXT;
    BEGIN
    -- Initialize
    max_rows = 100;
    IF rowlimit > max_rows THEN
    RAISE 'rowlimit skal være <= %', max_rows;
    END IF;
    if filters IS NULL THEN
    filters = '1=1';
    END IF;
    IF btrim(input_tekst) = Any ('{.,-, '', \,}') THEN
    input_tekst = '';
    END IF;

    -- Build the query_string
    WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_tekst), ' ')) t)
    SELECT string_agg(fonetik.fnfonetik(t, 2), ':* <-> ') || ':*'
    FROM tokens
    INTO query_string;

    -- build the plain version of the query string for ranking purposes
    WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_tekst), ' ')) t)
    SELECT string_agg(t, ':* <-> ') || ':*'
    FROM tokens
    INTO plain_query_string;

    -- Execute and return the result
    stmt = format(E'SELECT
            retskredsnummer, retkredsnavn, praesentation, myndighedskode, geometri, bbox::geometry,
            basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
            ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rank2
            FROM
            basic.retskreds_mv
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
            AND %s
            ORDER BY
            rank1 desc, rank2 desc,
            retkredsnavn
            LIMIT $3;', filters);
    RETURN QUERY EXECUTE stmt using query_string, plain_query_string, rowlimit;
    END
    $function$;

    -- Test cases:
    /*
       SELECT (api.retskreds('hjør',NULL, 1, 100)).*;
       SELECT (api.retskreds('køben',NULL, 1, 100)).*;
       SELECT (api.retskreds('ret',NULL, 1, 100)).*;
       SELECT (api.retskreds('i he',NULL, 1, 100)).*; 
     */
