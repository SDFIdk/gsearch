CREATE INDEX ON basic_initialloading.kommune USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic_initialloading.kommune USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic_initialloading.kommune USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic_initialloading.kommune (kommunekode);

CREATE INDEX ON basic_initialloading.kommune (kommunenavn);

VACUUM ANALYZE basic_initialloading.kommune;