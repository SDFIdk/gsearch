DROP FUNCTION IF EXISTS api.politikreds (text, jsonb, int, int, int);

CREATE OR REPLACE FUNCTION api.politikreds (input_tekst text, filters text, sortoptions integer, rowlimit integer, srid integer)
    RETURNS SETOF api.politikreds
    LANGUAGE plpgsql
    STABLE
    AS $function$
DECLARE
    max_rows integer;
    query_string text;
    plain_query_string text;
    stmt text;
BEGIN
    -- Initialize
    max_rows = 1000;
    IF rowlimit > max_rows THEN
        RAISE 'rowlimit skal være <= %', max_rows;
    END IF;
    IF filters IS NULL THEN
        filters = '1=1';
    END IF;
    IF btrim(input_tekst) = ANY ('{.,-, '', \,}') THEN
        input_tekst = '';
    END IF;
    -- Build the query_string

    SELECT
        -- Removes repeated whitespace and following symbols -()!
        regexp_replace(btrim(input_tekst), '[-()! \s]+', ' ', 'g')
    INTO input_tekst;

    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(input_tekst), ' ')) t
)
    SELECT
        string_agg(fonetik.fnfonetik (t, 2), ':* <-> ') || ':*'
    FROM
        tokens INTO query_string;
    -- build the plain version of the query string for ranking purposes
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(regexp_replace(btrim(input_tekst),'[ ][&][ ]|[&][ ]|[ ][&]','','g'), ' ')) t
)
    SELECT
        string_agg(t, ':* <-> ') || ':*'
    FROM
        tokens INTO plain_query_string;
    -- Execute and return the result
    stmt = format(E'SELECT
            politikredsnummer::text,
            navn::text,
            visningstekst,
            myndighedskode::text,
            kommunekode::text,
            CASE WHEN $4 = 25832 THEN geometri
            ELSE ST_TRANSFORM(geometri, $4) END,
            CASE WHEN $4 = 25832 THEN bbox::geometry
            ELSE BOX2D(ST_TRANSFORM(bbox, ''EPSG:25832'', $4))::geometry END
        FROM
            basic.politikreds
        WHERE (
            textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
            OR textsearchable_unaccent_col @@ to_tsquery(''simple'', $2)
            OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
        AND %s
        ORDER BY
            basic.combine_rank(
                $2,
                $2,
                textsearchable_plain_col,
                textsearchable_unaccent_col,
                ''simple''::regconfig,
                ''basic.septima_fts_config''::regconfig
            ) desc,
                ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision desc,
                navn
            LIMIT $3;', filters);
    RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, rowlimit, srid;
END
$function$;
