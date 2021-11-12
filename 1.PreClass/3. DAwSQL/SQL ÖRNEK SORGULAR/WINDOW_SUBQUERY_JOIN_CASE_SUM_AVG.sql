-- Is there store-level differences in the shopping attiudes of the customers who drive more to buy bicycles than drive less
-- [distance, store_state, store_name, total_sum_by_distance, avg_by_store, total_sum_by_store]

select distinct t.close_to_store, t.store_state, t.store_name,
sum(t.list_price) over(partition by t.close_to_store, t.store_name) as drive_level_sum,
avg(t.list_price) over(partition by t.close_to_store, t.store_name) as drive_level_avg,
sum(t.list_price) over(partition by t.store_name) as store_level
from
(select o.order_id, c.zip_code as zip_home, c.state as home_state, st.zip_code as zip_store, st.state as store_state, p.list_price, st.store_name,
case when c.zip_code = st.zip_code then 1 else 0 end as close_to_store
from sale.customer c join sale.orders o on c.customer_id=o.customer_id join sale.store st on st.store_id=o.store_id
join sale.order_item oo on o.order_id=oo.order_id join product.product p on p.product_id=oo.product_id) as t
order by t.store_state, t.store_name;


--group by versiyonu
select t.close_to_store, t.store_name, sum(t.list_price), avg(t.list_price)
from
(select o.order_id, c.zip_code as zip_home, c.state as home_state, st.zip_code as zip_store, st.state as store_state, p.list_price, st.store_name,
case when c.zip_code = st.zip_code then 1 else 0 end as close_to_store
from sale.customer c join sale.orders o on c.customer_id=o.customer_id join sale.store st on st.store_id=o.store_id
join sale.order_item oo on o.order_id=oo.order_id join product.product p on p.product_id=oo.product_id) as t
group by t.close_to_store, t.store_name