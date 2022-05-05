-- Grant rights to gsearch-reader
GRANT USAGE ON SCHEMA api TO udv_gsearch_read;
GRANT SELECT ON ALL tables IN SCHEMA api TO udv_gsearch_read;
GRANT EXECUTE ON ALL functions IN SCHEMA api TO udv_gsearch_read;
