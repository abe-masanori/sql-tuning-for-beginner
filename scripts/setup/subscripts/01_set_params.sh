#!/bin/bash

set -eu

sqlfile=${TEMP_DIR}/01.sql

cat << EOF > ${sqlfile}
@subscripts/profile.sql

conn / as sysdba

alter system set filesystemio_options=setall scope=spfile;
alter system set recyclebin=off scope=spfile;
alter system set db_file_multiblock_read_count=128 scope=spfile;

shutdown immediate
startup
exit
EOF

sqlplus /nolog @${sqlfile}

