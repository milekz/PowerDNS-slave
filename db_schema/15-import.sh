#!/bin/bash

cp -f /docker-entrypoint-initdb.d/20-schema.xxx /tmp/20-schema.yyy
cp -f /docker-entrypoint-initdb.d/40-schema.xxx /tmp/40-schema.yyy

sed -i "s/PGDB_USER/$PGSQL_USER/g" /tmp/20-schema.yyy
sed -i "s/PGDB_PASSWORD/$PGSQL_PASS/g" /tmp/20-schema.yyy
sed -i "s/PGDB_NAME/$PGSQL_DBNAME/g" /tmp/20-schema.yyy

sed -i "s/PDNS_PGDB_REPLICA_HOST/$PDNS_PGDB_REPLICA_HOST/g" /tmp/40-schema.yyy
sed -i "s/PDNS_PGDB_REPLICA_PASSWORD/$PDNS_PGDB_REPLICA_PASSWORD/g" /tmp/40-schema.yyy
sed -i "s/PDNS_PGDB_REPLICA_USERNAME/$PDNS_PGDB_REPLICA_USERNAME/g" /tmp/40-schema.yyy
sed -i "s/PDNS_PGDB_REPLICA_DBNAME/$PDNS_PGDB_REPLICA_DBNAME/g" /tmp/40-schema.yyy

RANDOMHASH=$(date +%s | md5sum | awk '{print $1}')

sed -i "s/RANDOMHASH/$RANDOMHASH/g" /tmp/40-schema.yyy

psql  < /tmp/20-schema.yyy

psql -U ${PGSQL_USER} ${PGSQL_DBNAME} < /docker-entrypoint-initdb.d/30-schema.xxx

psql ${PGSQL_DBNAME} < /tmp/40-schema.yyy


rm /tmp/20-schema.yyy
rm /tmp/40-schema.yyy


 