
--2. Answer the following SQL questions according to SampleSales database

-- Select the annual amount of product produced according to brands

SELECT  B.brand_name, A.model_year, count(C.quantity) as annual_amount_of_product
FROM product.product A 
INNER JOIN product.brand B on A.brand_id = B.brand_id
INNER JOIN product.stock C on A.product_id= C.product_id
GROUP By  B.brand_name, A.model_year
order by B.brand_name DESC;



-- Select the store which has the most sales quantity in 2018

	select top 1  A.store_name , COUNT(C.quantity ) as most_sales_quantity
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




--Select the personnel which has the most sales amount in 2018

    select top 1 A.first_name, A.last_name , sum((C.quantity*C.list_price)*(1-C.discount)) as most_amount
	from sale.staff A, sale.orders B, sale.order_item C  
	where A.staff_id =B.staff_id and B.order_id=C.order_id  and year(B.order_date)= 2018
    group by A.first_name, A.last_name
	order by most_amount desc;





	




