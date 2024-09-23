select
    i.item_id,
    i.item_name
from
    items i
where
    i.item_category_id = 30230
and
    i.supplier_id = 40620
;
