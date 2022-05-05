export PGCLIENTENCODING=UTF8;
export PGUSER=postgres
export PGPASSWORD=Hypocrisy96.Agency51
export PGDATABASE=gsearch_elvis
export PGHOST=loaddb14.kmsext.dk
export PGPORT=11513
logfile="log_local.txt"
errfile="error_local.txt"
sqlfile="total_local.txt"

rm $logfile $errfile $sqlfile

cat *.sql > $sqlfile


psql -t -v ON_ERROR_STOP=1 -f $sqlfile >>$logfile 2>>$errfile

