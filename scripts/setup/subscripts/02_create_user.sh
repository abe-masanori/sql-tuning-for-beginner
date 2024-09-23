#!/bin/bash

set -eu

sqlfile=${TEMP_DIR}/02.sql

cat << EOF > ${sqlfile}
@subscripts/profile.sql

conn / as sysdba

alter session set container = $PDB_NAME;

drop user if exists sqltune cascade;
create user sqltune
    identified by Passw0rd
    quota unlimited on users
;

grant create session to sqltune;
grant create table to sqltune;
grant select_catalog_role to sqltune;
grant alter session to sqltune;
grant alter system to sqltune;

exit
EOF

sqlplus /nolog @${sqlfile}

