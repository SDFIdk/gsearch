-- Debugging
-- For faster debugging, you can set the following to eg. 1000 rows.
-- You must comment in the last line for the 1000-limit to take effect.

DROP TABLE IF EXISTS g_options;
CREATE TEMPORARY TABLE g_options (maxrows int);
--INSERT INTO g_options VALUES (1000);
