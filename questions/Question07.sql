select
	o.order_id,
	c.customer_name,
	i.item_name
from
	orders o
inner join
	customers c on (o.customer_id = c.customer_id)
inner join
	items i on (o.item_id = i.item_id)
where
	c.prefecture_cd = 14
and
	i.item_name like 'item\_ABCDEFGHIJKLMNOP\_2299999%' escape '\'
;