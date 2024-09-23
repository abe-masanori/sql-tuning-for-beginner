select
	count(*)
from
	orders o
where
	o.order_date between
        to_date('2023-04-01', 'YYYY-MM-DD') and
        to_date('2023-06-30', 'YYYY-MM-DD')
and
	o.item_id = 20000034
;