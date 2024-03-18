CREATE INDEX ON basic_initialloading.stednavn (lower(visningstekst));

CREATE INDEX ON basic_initialloading.stednavn (kommunekode);

CREATE INDEX ON basic_initialloading.stednavn USING gist (geometri);

VACUUM ANALYZE basic_initialloading.stednavn;
