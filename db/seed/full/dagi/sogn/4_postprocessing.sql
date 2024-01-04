ALTER TABLE basic.sogn
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.sogn
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(sognenavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(sognenavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', split_part(sognenavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring (sognenavn, 4)), 'D'))
    STORED;

ALTER TABLE basic.sogn
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.sogn
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('functions.gsearch_fts_config', split_part(sognenavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', split_part(sognenavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', split_part(sognenavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', functions.split_and_endsubstring (sognenavn, 4)), 'D'))
    STORED;

ALTER TABLE basic.sogn
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.sogn
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', functions.fnfonetik (split_part(sognenavn, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', functions.fnfonetik (split_part(sognenavn, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', functions.fnfonetik (split_part(sognenavn, ' ', 3), 2)), 'C') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring_fonetik (sognenavn, 4)), 'D'))
    STORED;
