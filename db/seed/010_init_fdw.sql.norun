-- Transfer data from fdw:
DROP SERVER IF EXISTS prod_geosearch CASCADE;
DROP SERVER IF EXISTS prod_databox CASCADE;

CREATE SERVER IF NOT EXISTS prod_geosearch FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '12.pg.septima.dk', dbname 'prod_geosearch', fetch_size '1000');
CREATE SERVER IF NOT EXISTS prod_databox FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '12.pg.septima.dk', dbname 'prod_databox', fetch_size '1000');

DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER prod_geosearch;
DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER prod_databox;
CREATE USER MAPPING FOR CURRENT_USER SERVER prod_geosearch OPTIONS (user 'prod_geosearch_user', password 'Y0ush0uldnthavemadey0urpassw0rdpassw0rd');
CREATE USER MAPPING FOR CURRENT_USER SERVER prod_databox OPTIONS (user 'prod_geosearch_user', password 'Y0ush0uldnthavemadey0urpassw0rdpassw0rd');

IMPORT FOREIGN SCHEMA dagi_10m_nohist_l1 FROM SERVER prod_geosearch INTO dagi_10m_nohist_l1_fdw;
IMPORT FOREIGN SCHEMA dagi_500m_nohist_l1 FROM SERVER prod_geosearch INTO dagi_500m_nohist_l1_fdw;
IMPORT FOREIGN SCHEMA dar FROM SERVER prod_databox INTO dar_fdw;
IMPORT FOREIGN SCHEMA fonetik FROM SERVER prod_geosearch INTO fonetik_fdw;
IMPORT FOREIGN SCHEMA mat_kf FROM SERVER prod_databox INTO mat_kf_fdw;
IMPORT FOREIGN SCHEMA stednavne_udstil FROM SERVER prod_geosearch INTO stednavne_udstil_fdw;
