--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'


select t.order_date, t.sum_q,						    --[6]
-- avg(t.sum_q) over (order by t.order_date) as moving,
avg(t.sum_q) over(order by t.order_date rows between 6 preceding and current row)as moving     --[7]
from 										    --[5]
    (select distinct o.order_date,						    --[3]
    sum(i.quantity) over(partition by o.order_date) as sum_q --günlük satýþ miktarý  [4] 
    from sale.orders o join sale.order_item i on o.order_id=i.order_id   --[1]
    where o.order_date between '2018-03-12' and '2018-04-12') as t       --[2]

-- Her satýrda aþaðý inen / harektli (hep 7 günü gösteren)  bir window frame oluþturmamýz isteniyor. 
-- “Rows between” ile bunu saðlýyoruz. Order By’ý default býraksaydýk (rows.. yazmasaydýk) kümülatif olarak sýralamaya devam ederdi.
-- Sorguyu oluþturma sýrasý [köþeli parantez içinde gösterilmiþtir]
-- avg() iþlemini sum()’ýn olduðu window frame içine yazarsak hata verir.