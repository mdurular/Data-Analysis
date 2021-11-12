--- **** ORTAK S�TUNU OLMAYAN TABLOLARI B�RLE�T�RME ****---
-- S�PAR��LER� �K� ATLAYARAK HER ��TE B�R�N� YAZDIRMA

with recur as 
(
    select 1 as num 
    union all 
    select num + 3
    from recur 
    where num < 100
)
select num, t.order_id, t.order_date, t.shipped_date 
from recur join (select * from sale.orders) as t on recur.num=t.order_id