#!/bin/bash

set -eu

sqlfile=${TEMP_DIR}/04.sql

cat << EOF > ${sqlfile}
@subscripts/profile.sql

conn / as sysdba

alter session set container = $PDB_NAME;
alter session set current_schema = sqltune;

create or replace directory test_dir as '${TEMP_DIR}';

drop table if exists ext_customers;

create table ext_customers (
    customer_id   integer,
    customer_name varchar2(100) not null,
    address_1     varchar2(100) not null,
    address_2     varchar2(100) not null,
    tel_number    varchar2(11) not null,
    birthday      date not null,
    prefecture_cd integer not null,
    region_cd     varchar2(6) not null
)
organization external (
    type oracle_loader
    default directory test_dir
    access parameters (
        records delimited by '\n'
        fields terminated by '\t' (
            customer_id,
            customer_name,
            address_1,
            address_2,
            tel_number,
            birthday char(10) date_format date mask 'YYYY-MM-DD',
            prefecture_cd,
            region_cd
        )
    )
    location ('customers.csv')
);

drop table if exists ext_items;

create table ext_items (
    item_id          integer,
    item_name        varchar2(100) not null,
    item_category_id number(10) not null,
    supplier_id      number(10) not null
)
organization external (
    type oracle_loader
    default directory test_dir
    access parameters (
        records delimited by '\n'
        fields terminated by '\t' (
            item_id,
            item_name,
            item_category_id,
            supplier_id
        )
    )
    location ('items.csv')
);

drop table if exists ext_orders;

create table ext_orders (
    order_id       integer,
    order_date     date not null,
    customer_id    integer not null,
    item_id        integer not null,
    order_quantity integer not null,
    order_amount   integer not null
)
organization external (
    type oracle_loader
    default directory test_dir
    access parameters (
        records delimited by '\n'
        fields terminated by '\t' (
            order_id,
            order_date char(10) date_format date mask 'YYYY-MM-DD',
            customer_id,
            item_id,
            order_quantity,
            order_amount
        )
    )
    location ('orders.csv')
);

create table customers nologging as select * from ext_customers;
create table items nologging as select * from ext_items;
create table orders nologging as select * from ext_orders;

drop table ext_customers;
drop table ext_items;
drop table ext_orders;
drop directory test_dir;
exit
EOF

sqlplus /nolog @${sqlfile}