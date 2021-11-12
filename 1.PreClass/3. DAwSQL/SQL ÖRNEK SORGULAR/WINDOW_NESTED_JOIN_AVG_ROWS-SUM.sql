--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'


select t.order_date, t.sum_q,						    --[6]
-- avg(t.sum_q) over (order by t.order_date) as moving,
avg(t.sum_q) over(order by t.order_date rows between 6 preceding and current row)as moving     --[7]
from 										    --[5]
    (select distinct o.order_date,						    --[3]
    sum(i.quantity) over(partition by o.order_date) as sum_q --g�nl�k sat�� miktar�  [4] 
    from sale.orders o join sale.order_item i on o.order_id=i.order_id   --[1]
    where o.order_date between '2018-03-12' and '2018-04-12') as t       --[2]

-- Her sat�rda a�a�� inen / harektli (hep 7 g�n� g�steren)  bir window frame olu�turmam�z isteniyor. 
-- �Rows between� ile bunu sa�l�yoruz. Order By�� default b�raksayd�k (rows.. yazmasayd�k) k�m�latif olarak s�ralamaya devam ederdi.
-- Sorguyu olu�turma s�ras� [k��eli parantez i�inde g�sterilmi�tir]
-- avg() i�lemini sum()��n oldu�u window frame i�ine yazarsak hata verir.