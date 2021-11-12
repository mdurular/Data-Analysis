-- Find the weekly order count for the city of San Angelo for the last 52 weeks, 
--and also the cumulative total.

-- !!! Haftalarý integer olarak sayýp sýraya sokabilmek için CAST ile integer’a çevirdik.
select distinct cast(datename(week, o.order_date) as integer) as week_number,
count(o.order_id) over(partition by cast(datename(week, o.order_date) as integer)) as total,
count(o.order_id) over(order by cast(datename(week, o.order_date) as integer)) as weekly_cumulative
from sale.orders o join sale.store ss on o.store_id=ss.store_id
where ss.city = 'San Angelo' and
o.order_date between dateadd(year, -1, (select max(order_date) from sale.orders)) and (select max(order_date) from sale.orders);

-- Calculate the stores' weekly cumulative number of orders for 2018

select distinct s.store_id, s.store_name, datepart(week, o.order_date) as week,
count(o.order_id) over (partition by s.store_id, datepart(week, o.order_date)) as weekly_sum,
count(o.order_id) over (partition by s.store_id order by datepart(week, o.order_date)) as cum_sum
from sale.orders o join sale.store s on o.store_id=s.store_id
where year(o.order_date) = 2018
order by s.store_id, week