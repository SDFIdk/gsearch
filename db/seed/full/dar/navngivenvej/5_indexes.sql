CREATE INDEX ON basic_initialloading.navngivenvej USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic_initialloading.navngivenvej USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic_initialloading.navngivenvej USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic_initialloading.navngivenvej (lower(vejnavn));

CREATE INDEX ON basic_initialloading.navngivenvej (kommunekode);

CREATE INDEX ON basic_initialloading.navngivenvej USING gist (geometri);

VACUUM ANALYZE basic_initialloading.navngivenvej;
