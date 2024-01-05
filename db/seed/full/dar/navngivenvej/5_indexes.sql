CREATE INDEX ON basic.navngivenvej USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.navngivenvej USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.navngivenvej USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.navngivenvej (lower(vejnavn));

CREATE INDEX ON basic.navngivenvej (supplerendebynavn);

CREATE INDEX ON basic.navngivenvej (kommunekode);

CREATE INDEX ON basic.navngivenvej USING gist (geometri);

VACUUM ANALYZE basic.navngivenvej;
