
--2. Answer the following SQL questions according to SampleSales database

-- Select the annual amount of product produced according to brands



(SELECT  B.brand_name, A.model_year, sum(C.quantity) as annual_amount_of_product
FROM product.product A 
INNER JOIN product.brand B on A.brand_id = B.brand_id
INNER JOIN product.stock C on A.product_id= C.product_id
GROUP By  B.brand_name, A.model_year
order by B.brand_name DESC)


(select b.brand_name, p.model_year, sum(o.quantity) as toplam
from product.brand b join product.product p on b.brand_id=p.brand_id 
join sale.order_item o on o.product_id=p.product_id
group by b.brand_name, p.model_year
order by b.brand_name, model_year)




-- Select the store which has the most sales quantity in 2018

	select top 1 A.store_name , sum(C.quantity ) as most_sales_quantity
	from sale.store A, sale.orders B, sale.order_item C
	where A.store_id =B.store_id and B.order_id=C.order_id  and year(B.order_date)= 2018
    group by  A.store_name
	order by most_sales_quantity desc;


-- Select the store which has the most sales amount in 2018

	select top 1  A.store_name , sum((C.quantity*C.list_price)*(1-C.discount)) as most_amount
	from sale.store A, sale.orders B, sale.order_item C
	where A.store_id =B.store_id and B.order_id=C.order_id  and year(B.order_date)= 2018
    group by  A.store_name
	order by most_amount desc;


select top 1 so.store_id, s.store_name, sum(o.quantity * (1 - o.discount) * o.list_price) as amount
from sale.order_item o join sale.orders so on o.order_id=so.order_id 
join sale.store s on so.store_id=s.store_id
where so.order_date between '2018-01-01' and '2018-12-31'
group by so.store_id, s.store_name
order by amount desc



--Select the personnel which has the most sales amount in 2018

    select top 1 A.first_name, A.last_name , sum((C.quantity*C.list_price)*(1-C.discount)) as most_amount
	from sale.staff A, sale.orders B, sale.order_item C  
	where A.staff_id =B.staff_id and B.order_id=C.order_id  and year(B.order_date)= 2018
    group by A.first_name, A.last_name
	order by most_amount desc;


	select *
from sale.staff
where staff_id = 
    (select staff_id
    from sale.orders
    where order_id =
        (select new.order_id
        from
        (select top 1 oo.order_id, sum(oo.list_price * (1 - oo.discount) * oo.quantity) as amount
        from sale.staff s join sale.orders o on s.staff_id=o.staff_id
        join sale.order_item oo on oo.order_id=o.order_id
        where o.order_date between '2018-01-01' and '2018-12-31'
        group by oo.order_id
        order by amount desc) as new))


	




