select
	c.customer_id,
	o.order_id,
	o.item_id
from
	customers c
inner join
	orders o on (c.customer_id = o.customer_id)
where
	c.customer_name like 'cust\_name\_1000001%' escape '\'
and
	o.order_id = (
		select
			max(o1.order_id)
		from
			orders o1
		where
			o1.customer_id = c.customer_id
		)
order by
	c.customer_id
;