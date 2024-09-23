### 結合順序を意識する必要があるケース

今回の SQL 文は3テーブルを結合しているが、

- ```customers``` ⇒ ```orders``` ⇒ ```items``` の順番で結合する
- ```items``` ⇒ ```orders``` ⇒ ```customers``` の順番で結合する

のどちらが適切かを意識した上で、最低限必要なインデックスを作成してほしい。

```item_name``` カラムはカーディナリティー（値の種類）が高い一方、```prefecture_cd``` カラムはカーディナリティーが低いため、```items``` テーブルから開始した方がより速くデータを絞り込めるという点に気付いてほしい（厳密には、```orders``` テーブルでの絞り込みの程度に注目する）。

ちなみに、```prefecture_cd = 14``` は ISO 都道府県コード = 14 で人口が多い神奈川県を指していたりする（つまりこの条件では絞り込み率はさらに低い）。