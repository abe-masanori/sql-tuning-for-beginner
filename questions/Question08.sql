select
	o.order_id,
	o.order_date,
	o.item_id,
	o.order_quantity
from
	orders o
where
	o. customer_id = 10000128
order by
	o.order_date desc
fetch first 50 rows only
;