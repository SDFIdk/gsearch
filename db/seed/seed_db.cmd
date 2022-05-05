SET PGCLIENTENCODING=UTF8;
SET pguser=postgres
SET pgdatabase=gsearch
SET pghost=localhost
SET pgport=5432
SET psql="C:\Program Files\PostgreSQL\13\bin\psql.exe"
SET logfile="log_local.txt"
SET errfile="error_local.txt"
SET sqlfile="total_local.txt"

DEL %logfile% >nul 2>&1
DEL %errfile% >nul 2>&1
DEL %sqlfile% >nul 2>&1

@echo off
type *.sql > %sqlfile%
@echo on

%psql% -t -v ON_ERROR_STOP=1 -f %sqlfile% >>%logfile% 2>>%errfile%
IF %ERRORLEVEL% NEQ 0 GOTO error
GOTO slut
:error
ECHO Fejl ved afvikling af script. Se %errfile% for supplerende information
:slut
