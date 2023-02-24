SELECT '008_danish_search.sql ' || now();


-- Requires Superuser:
DROP EXTENSION IF EXISTS unaccent CASCADE;

DROP EXTENSION IF EXISTS dict_xsyn CASCADE;

CREATE EXTENSION unaccent;

-- translate accents: å -> aa ->, æ -> ae, ect.
CREATE EXTENSION dict_xsyn;

-- common synonyms used in addresses: skt -> sankt, gl -> gammel/gamle
-- create fts config from simple
DROP TEXT SEARCH CONFIGURATION IF EXISTS basic.septima_fts_config;

CREATE TEXT SEARCH CONFIGURATION basic.septima_fts_config (
    COPY = pg_catalog.simple
);

-- dict_xsyn extension automatically creates a dictionary xsyn, using a custom rules file. So use our custom-made
-- Must be owner:
ALTER TEXT SEARCH DICTIONARY xsyn (RULES = 'xsyn_gsearch', KEEPORIG = TRUE, MATCHSYNONYMS = TRUE, MATCHORIG = TRUE, KEEPSYNONYMS = TRUE);

ALTER TEXT SEARCH DICTIONARY unaccent (RULES = 'unaccent_gsearch');

-- set the configuration to use the dictionaries in order: unaccent -> xsyn -> simply
ALTER TEXT SEARCH CONFIGURATION basic.septima_fts_config
    ALTER MAPPING FOR asciiword, asciihword, hword_asciipart, word, hword, hword_part, numword, numhword WITH unaccent,
    xsyn,
    simple;

-- drop mappings for hyphenated words. This results in hyphenated words being treated as a single word
ALTER TEXT SEARCH CONFIGURATION basic.septima_fts_config
    DROP MAPPING FOR hword_asciipart;

ALTER TEXT SEARCH CONFIGURATION basic.septima_fts_config
    DROP MAPPING FOR hword_part;

