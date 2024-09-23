#!/bin/bash

set -eu

sqlfile=${TEMP_DIR}/06.sql

cat << EOF > ${sqlfile}
@subscripts/profile.sql

conn / as sysdba

alter session set container = $PDB_NAME;
alter session set current_schema = sqltune;

exec dbms_stats.gather_schema_stats(ownname => NULL);
exit
EOF

sqlplus /nolog @${sqlfile}

