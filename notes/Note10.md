### 相関副問い合わせにインデックスを活用するケース

```c.customer_name like 'cust\_name\_1000001%' escape '\'``` に該当する ```customers``` テーブルのレコード件数は 10 件のみだが、それに紐付く ```orders``` テーブルのレコード件数は 1.2 万件以上あり、結合キーのインデックスを作成する Question06 と同じアプローチだとまだ遅い。

そこで ```o.order_id = (select ...)``` という条件も活用して効率よくデータを絞り込む必要がある。副問い合わせの中身は該当する ``` customer_id``` に対して ```order_id``` の最大値を取るロジックのため、Question08 の先頭 N 件取得の応用で ```customer_id``` と ```order_id``` の複合インデックスを作成することで高速化ができる。

ちなみに、相関副問い合わせで MIN/MAX を取得するこのパターンは履歴管理を行うテーブルに対して最新のレコードを取得するといったケースでよく見られる。 今回の問題の SQL 文も顧客ごとの最新の注文レコードを取得するというのが意図（本当は ```order_date``` で MAX を取るべきだが、データの都合上 ```order_id``` で判定している）。