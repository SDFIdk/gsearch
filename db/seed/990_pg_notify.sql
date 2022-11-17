SELECT '990_pg_notify.sql ' || now();


SELECT pg_notify('gsearch', 'reload');
