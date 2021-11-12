-- Write a query that returns both of the followings:
-- - The average product price of orders
-- - Average net amounts of orders

select distinct o.order_id, p.list_price,
avg(p.list_price) over(partition by o.order_id) as avg_price,
avg(p.list_price * oo.quantity * (1-oo.discount)) over () as avg_net_amount
from sale.orders o join sale.order_item oo on o.order_id=oo.order_id 
join product.product p on p.product_id=oo.product_id