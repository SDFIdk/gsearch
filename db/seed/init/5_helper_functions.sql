SELECT '006_helper_functions.sql ' || now();


-- Returns the tail of a space-delimited string, where N denotes the start of the tail. Ex: split_and_endsubstring("x y z", 2) -> "y z"
DROP FUNCTION IF EXISTS functions.split_and_endsubstring (text, integer);

CREATE OR REPLACE FUNCTION functions.split_and_endsubstring (input text, N integer)
    RETURNS text IMMUTABLE
    AS $$
BEGIN
    RETURN ARRAY_TO_STRING((STRING_TO_ARRAY(coalesce(input, ''), ' '))[N:], ' ');
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS functions.split_and_endsubstring_fonetik (text, integer);

CREATE OR REPLACE FUNCTION functions.split_and_endsubstring_fonetik (input text, N integer)
    RETURNS text IMMUTABLE
    AS $$
DECLARE
    temp_arr text[];
    res_str text := '';
    var text;
BEGIN
    SELECT
        (STRING_TO_ARRAY(coalesce(input, ''), ' '))[N:] INTO temp_arr;
    IF CARDINALITY(temp_arr) < 1 THEN
        RETURN '';
    END IF;
    FOREACH var IN ARRAY temp_arr LOOP
        SELECT
            res_str || ' ' || functions.fnfonetik (var, 2)::text INTO res_str;
    END LOOP;
    RETURN btrim(res_str);
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS functions.stednavne_uofficielle_tsvector (text);

CREATE OR REPLACE FUNCTION functions.stednavne_uofficielle_tsvector (input text)
    RETURNS tsvector IMMUTABLE
    AS $$
DECLARE
    temp_arr text[];
    var text;
    res tsvector := ''::tsvector;
BEGIN
    SELECT
        STRING_TO_ARRAY(input, ';') INTO temp_arr;
    FOREACH var IN ARRAY temp_arr LOOP
        SELECT
            res || setweight(to_tsvector('simple', split_part(coalesce(var, ''), ' ', 1)), 'A') || setweight(to_tsvector('simple', split_part(coalesce(var, ''), ' ', 2)), 'B') || setweight(to_tsvector('simple', functions.split_and_endsubstring (var, 3)), 'C') INTO res;
    END LOOP;
    RETURN res;
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS functions.stednavne_uofficielle_tsvector_phonetic (text);

CREATE OR REPLACE FUNCTION functions.stednavne_uofficielle_tsvector_phonetic (input text)
    RETURNS tsvector IMMUTABLE
    AS $$
DECLARE
    temp_arr text[];
    var text;
    res tsvector := ''::tsvector;
BEGIN
    SELECT
        STRING_TO_ARRAY(input, ';') INTO temp_arr;
    FOREACH var IN ARRAY temp_arr LOOP
        SELECT
            res || setweight(to_tsvector('simple', functions.fnfonetik (split_part(coalesce(var, ''), ' ', 1), 2)), 'A') || setweight(to_tsvector('simple', functions.fnfonetik (split_part(coalesce(var, ''), ' ', 2), 2)), 'B') || setweight(to_tsvector('simple', functions.split_and_endsubstring_fonetik (var, 3)), 'C') INTO res;
    END LOOP;
    RETURN res;
END;
$$
LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS functions.array_to_string_immutable (text[]);

CREATE OR REPLACE FUNCTION functions.array_to_string_immutable (input text[])
    RETURNS text IMMUTABLE
    AS $$
BEGIN
    RETURN array_to_string(coalesce(input, '{}'), ' ');
END;
$$
LANGUAGE plpgsql;

-- Sums the rank of two queries
DROP FUNCTION IF EXISTS functions.combine_rank (text, text, tsvector, tsvector, regconfig, regconfig);

CREATE OR REPLACE FUNCTION functions.combine_rank (q1 text, q2 text, col1 tsvector, col2 tsvector, dict1 regconfig, dict2 regconfig)
    RETURNS double precision
    AS $$
BEGIN
    RETURN ts_rank_cd(col1, to_tsquery(dict1, q1))::double precision + ts_rank_cd(col2, to_tsquery(dict2, q2))::double precision;
END;
$$
LANGUAGE plpgsql;

-- sums the rank of N queries from input text arr
DROP FUNCTION IF EXISTS functions.combine_rank_arr (text[], tsvector);

CREATE OR REPLACE FUNCTION functions.combine_rank_arr (query_strings text[], col tsvector)
    RETURNS double precision
    AS $$
DECLARE
    res double precision;
    q text;
BEGIN
    res := 0;
    FOREACH q IN ARRAY query_strings LOOP
        res := res + ts_rank_cd(col, to_tsquery('simple', q))::double precision;
    END LOOP;
    RETURN res;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION functions.split_string (_str text, _delim1 text = '-', _delim2 text = ' ')
    RETURNS SETOF text
    AS $func$
    SELECT
        unnest(string_to_array(a, _delim2))::text
    FROM
        unnest(string_to_array(_str, _delim1)) a
$func$
LANGUAGE sql
IMMUTABLE;

CREATE OR REPLACE FUNCTION functions.fnfonetik (character varying, integer)
    RETURNS character varying
    LANGUAGE plpgsql
    IMMUTABLE
    AS $function$
DECLARE
    _Input ALIAS FOR $1;
    _func ALIAS FOR $2;
    -- 1 = alm fonetik, 2 = vej fonetik, 3 = normalisering
    _Wrk varchar(500);
    _Wrk2 varchar(500);
    I int4;
    rec record;
BEGIN
    _Wrk := ' ' || Upper(_Input) || ' ';
    FOR rec IN
    SELECT
        regelnr,
        "type",
        s1,
        s2,
        s3
    FROM
        functions.fonetiskregel
    WHERE (_func = 1)
        OR ((_func = 2)
            AND (vejfonetik = 1))
        OR ((_func = 3)
            AND (normalisering = 1))
    ORDER BY
        regelnr LOOP
            IF (rec.type = 1) THEN
                _Wrk := replace(_Wrk, rec.s1, rec.s2);
            ELSIF rec.type = 2 THEN
                IF (position(replace(rec.s1, '*', '') IN _Wrk) > 0) THEN
                    -- Ikke noedvendigt men sparer MEGET tid i de fleste tilfaelde
                    I := 1;
                    WHILE (I <= length(rec.s3))
                    LOOP
                        _Wrk := replace(_Wrk, replace(rec.s1, '*', substring(rec.s3, I, 1)), replace(rec.s2, '*', substring(rec.s3, I, 1)));
                        I := I + 1;
                    END LOOP;
                END IF;
            ELSIF rec.type = 3 THEN
                IF substring(_Wrk, 1, length(rec.s1)) = rec.s1 THEN
                    _Wrk = rec.s2 || substring(_Wrk, length(rec.s1) + 1);
                END IF;
            ELSE
                I := 1;
                WHILE (I <= length(_Wrk))
                LOOP
                    IF substring(_Wrk, I, 1) = substring(_Wrk, I + 1, 1) THEN
                        IF substring(_Wrk, I, 1)
                            NOT BETWEEN '0' AND '9' THEN
                            _Wrk := replace(_Wrk, repeat(substring(_Wrk, I, 1), 2), substring(_Wrk, I, 1));
                        END IF;
                    END IF;
                    I := I + 1;
                END LOOP;
            END IF;
        END LOOP;
    RETURN _Wrk;
END;
$function$;

