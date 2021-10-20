-- Text search
DROP SCHEMA IF EXISTS ts cascade;
DROP TEXT SEARCH CONFIGURATION IF EXISTS ts.vejnavne;
DROP TEXT SEARCH DICTIONARY IF EXISTS ts.vejnavne; 
 


CREATE SCHEMA IF NOT EXISTS ts;

CREATE TEXT SEARCH CONFIGURATION ts.vejnavne ( COPY = pg_catalog.danish);

CREATE TEXT SEARCH DICTIONARY ts.vejnavne (
    TEMPLATE = synonym
--    ,SYNONYMS = danish -- Placeres i filen: /usr/share/postgresql/12/tsearch_data/danish.syn
    ,synonyms = synonym_sample
);

CREATE TEXT SEARCH DICTIONARY ts.danish_ispell (
    TEMPLATE = ispell,
    DictFile = ispell_sample,
    AffFile = ispell_sample,
--    LANGUAGE = danish,
    StopWords = danish
);

ALTER TEXT SEARCH CONFIGURATION ts.vejnavne
    ALTER MAPPING FOR asciiword, asciihword, hword_asciipart,
                      word, hword, hword_part
    WITH ts.vejnavne, danish_stem, ts.danish_ispell;

SELECT * FROM ts_debug('ts.vejnavne', 'sct-hans2');

--SELECT * FROM pg_catalog.pg_ts_dict;
--select * from pg_ts_config_map
--select * from pg_ts_config
-- select * from pg_ts_parser
-- select * from pg_ts_template



