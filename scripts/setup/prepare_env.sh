#!/bin/bash

set -eu

export ORACLE_SID=FREE
export PDB_NAME=FREEPDB1
export ORACLE_HOME=/opt/oracle/product/23ai/dbhomeFree
export NLS_LANG=Japanese_Japan.AL32UTF8

export PATH=${ORACLE_HOME}/bin:${PATH}
export PYTHON=${ORACLE_HOME}/python/bin/python

cd $(dirname $BASH_SOURCE)
export TEMP_DIR=$(pwd)/temp

rm -fr ${TEMP_DIR}
mkdir -p ${TEMP_DIR}

cat << 'EOF'
**********************************
(1/6) DBのパラメーター変更
**********************************
EOF
bash ./subscripts/01_set_params.sh

cat << 'EOF'
**********************************
(2/6) DBユーザーの作成
**********************************
EOF
bash ./subscripts/02_create_user.sh

cat << 'EOF'
**********************************
(3/6) データの生成
**********************************
EOF
${PYTHON} subscripts/03_generate_csv.py

cat << 'EOF'
**********************************
(4/6) データロード
**********************************
EOF
bash ./subscripts/04_load_data.sh

cat << 'EOF'
**********************************
(5/6) インデックスの作成
**********************************
EOF
bash ./subscripts/05_create_indexs.sh

cat << 'EOF'
**********************************
(6/6) オプティマイザ統計情報の収集
**********************************
EOF
bash ./subscripts/06_gather_stats.sh

cat << 'EOF'
**********************************
環境準備が完了しました
**********************************
EOF

rm -fr ${TEMP_DIR}
