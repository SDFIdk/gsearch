
ALTER TABLE basic.retskreds
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.retskreds
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(retkredsnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(retkredsnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', split_part(retkredsnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring (retkredsnavn, 4)), 'D'))
    STORED;

ALTER TABLE basic.retskreds
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.retskreds
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('basic.septima_fts_config', split_part(retkredsnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(retkredsnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(retkredsnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (retkredsnavn, 4)), 'D'))
    STORED;

ALTER TABLE basic.retskreds
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.retskreds
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(retkredsnavn, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(retkredsnavn, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(retkredsnavn, ' ', 3), 2)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (retkredsnavn, 4)), 'D'))
    STORED;
