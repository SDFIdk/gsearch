SELECT '004_foreign_data_wrappers.sql ' || now();


-- DAGI
DROP SERVER IF EXISTS :dagi_server CASCADE;

CREATE SERVER IF NOT EXISTS :dagi_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    host :dagi_hostname,
    port :dagi_port,
    dbname :dagi_database,
    fetch_size '1000'
);

DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER :dagi_server;

CREATE USER MAPPING FOR CURRENT_USER SERVER :dagi_server OPTIONS (
    USER :dagi_username,
    PASSWORD :dagi_password
);

IMPORT FOREIGN SCHEMA dagi_m_a_latest
FROM
    SERVER :dagi_server INTO dagi_10_fdw;

IMPORT FOREIGN SCHEMA dagi_m_a_500_latest
FROM
    SERVER :dagi_server INTO dagi_500_fdw;

-- DAR
DROP SERVER IF EXISTS :dar_server CASCADE;

CREATE SERVER IF NOT EXISTS :dar_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    host :dar_hostname,
    port :dar_port,
    dbname :dar_database,
    fetch_size '1000'
);

DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER :dar_server;

CREATE USER MAPPING FOR CURRENT_USER SERVER :dar_server OPTIONS (
    USER :dar_username,
    PASSWORD :dar_password
);

IMPORT FOREIGN SCHEMA dar_latest
FROM
    SERVER :dar_server INTO dar_fdw;

-- MATRIKLEN
DROP SERVER IF EXISTS :matriklen_server CASCADE;

CREATE SERVER IF NOT EXISTS :matriklen_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    host :matriklen_hostname,
    port :matriklen_port,
    dbname :matriklen_database,
    fetch_size '1000'
);

DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER :matriklen_server;

CREATE USER MAPPING FOR CURRENT_USER SERVER :matriklen_server OPTIONS (
    USER :matriklen_username,
    PASSWORD :matriklen_password
);

IMPORT FOREIGN SCHEMA matriklen2_latest
FROM
    SERVER :matriklen_server INTO matriklen_fdw;

-- MATRIKLEN_UDGAAET
DROP SERVER IF EXISTS :matriklen_udgaaet_server CASCADE;

CREATE SERVER IF NOT EXISTS :matriklen_udgaaet_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    host :matriklen_udgaaet_hostname,
    port :matriklen_udgaaet_port,
    dbname :matriklen_udgaaet_database,
    fetch_size '1000'
);

DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER :matriklen_udgaaet_server;

CREATE USER MAPPING FOR CURRENT_USER SERVER :matriklen_udgaaet_server OPTIONS (
    USER :matriklen_udgaaet_username,
    PASSWORD :matriklen_udgaaet_password
);

IMPORT FOREIGN SCHEMA matriklen2_udgaaet_latest
FROM
    SERVER :matriklen_udgaaet_server INTO matriklen_udgaaet_fdw;

-- STEDNAVNE
DROP SERVER IF EXISTS :stednavne_server CASCADE;

CREATE SERVER IF NOT EXISTS :stednavne_server FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    host :stednavne_hostname,
    port :stednavne_port,
    dbname :stednavne_database,
    fetch_size '1000'
);

DROP USER MAPPING IF EXISTS FOR CURRENT_USER SERVER :stednavne_server;

CREATE USER MAPPING FOR CURRENT_USER SERVER :stednavne_server OPTIONS (
    USER :stednavne_username,
    PASSWORD :stednavne_password
);

IMPORT FOREIGN SCHEMA stednavne_latest
FROM
    SERVER :stednavne_server INTO stednavne_fdw;

