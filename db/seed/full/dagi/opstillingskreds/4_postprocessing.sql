ALTER TABLE basic_initialloading.opstillingskreds
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic_initialloading.opstillingskreds
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(opstillingskredsnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(opstillingskredsnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', split_part(opstillingskredsnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring (opstillingskredsnavn, 4)), 'D'))
    STORED;

ALTER TABLE basic_initialloading.opstillingskreds
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic_initialloading.opstillingskreds
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('functions.gsearch_fts_config', split_part(opstillingskredsnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', split_part(opstillingskredsnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', split_part(opstillingskredsnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('functions.gsearch_fts_config', functions.split_and_endsubstring (opstillingskredsnavn, 4)), 'D'))
    STORED;

ALTER TABLE basic_initialloading.opstillingskreds
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic_initialloading.opstillingskreds
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', functions.fnfonetik (split_part(opstillingskredsnavn, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', functions.fnfonetik (split_part(opstillingskredsnavn, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', functions.fnfonetik (split_part(opstillingskredsnavn, ' ', 3), 2)), 'C') ||
                         setweight(to_tsvector('simple', functions.split_and_endsubstring_fonetik (coalesce(opstillingskredsnavn), 4)), 'D'))
    STORED;
