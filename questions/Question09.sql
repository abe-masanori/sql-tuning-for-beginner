select
	o.order_date,
	sum(o.order_quantity),
	sum(o.order_amount)
from
	orders o
where
	o.item_id = 20000301
group by
	o.order_date
;