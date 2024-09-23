#!/bin/bash

set -eu

sqlfile=${TEMP_DIR}/05.sql

cat << EOF > ${sqlfile}
@subscripts/profile.sql

conn / as sysdba

alter session set container = $PDB_NAME;
alter session set current_schema = sqltune;

alter table customers add constraint pk_customers primary key (customer_id) using index nologging;
alter table items add constraint pk_itemss primary key (item_id) using index nologging;
alter table orders add constraint pk_orders primary key (order_id) using index nologging;
exit
EOF

sqlplus /nolog @${sqlfile}

