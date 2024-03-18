CREATE INDEX ON basic_initialloading.stednavn USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic_initialloading.stednavn USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic_initialloading.stednavn USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic_initialloading.stednavn (lower(visningstekst));

CREATE INDEX ON basic_initialloading.stednavn (visningstekst);

CREATE INDEX ON basic_initialloading.stednavn (kommunekode);

CREATE INDEX ON basic_initialloading.stednavn USING gist (geometri);

VACUUM ANALYZE basic_initialloading.stednavn;
