export PGCLIENTENCODING=UTF8
export PGHOST=loaddb14.kmsext.dk
export PGPORT=11114
export PGUSER=datafordeler
export PGPASSWORD=splashing92//27Maaterial
export PGDATABASE=datafordeler

for file in $(ls *.sql)
do
    echo "  > $file"
    psql -t -f $file
done
