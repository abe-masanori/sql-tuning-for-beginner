
select
   count(*)
from
   customers c
where
   to_char(c.birthday, 'YYYYMM') = '200101'
;
