select
	o.order_id,
	o.order_date,
	o.item_id,
	o.order_amount
from
	orders o
inner join
	customers c on (o.customer_id = c.customer_id)
where
	c.customer_name = 'cust_name_10064248'
order by
	o.order_id
;