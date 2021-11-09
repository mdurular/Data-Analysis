--0.Answer the following questions according to bikestore database

-- What is the sales quantity of product according to the brands and sort them highest-lowest
-- (Markalara göre ürünün satýþ miktarý nedir ve bunlarý en yüksek-en düþük olarak sýralayýnýz.)

SELECT B.brand_name ,SUM (C.quantity) AS QUANTÝTY_OF_PRODUCT
FROM product.product A
INNER JOIN product.brand B on A.brand_id = B.brand_id
INNER JOIN sale.order_item C on A.product_id= C.product_id
GROUP BY B.brand_name
ORDER BY QUANTÝTY_OF_PRODUCT DESC;


-- Select the top 5 most expensive products

SELECT TOP 5 product_name,list_price 
FROM product.product
ORDER BY list_price DESC


-- What are the categories that each brand has
(Her markanýn sahip olduðu kategoriler nelerdir?)

SELECT DISTINCT B.brand_name,C.category_name
FROM product.product A 
INNER JOIN product.brand b ON  A.brand_id = B.brand_id
INNER JOIN product.category C ON A.category_id=C.category_id

-- Select the avg prices according to brands and categories

SELECT C.category_name,B.brand_name,  AVG(A.list_price) AS AVG_PRÝCE_ACCORDÝNG_TO_BRANDS
FROM product.product A 
INNER JOIN product.brand b ON  A.brand_id = B.brand_id
INNER JOIN product.category C ON A.category_id=C.category_id
GROUP BY C.category_name,B.brand_name



-- Select the annual amount of product produced according to brands

SELECT  B.brand_name, A.model_year, count(C.quantity) as annual_amount_of_product
FROM product.product A 
INNER JOIN product.brand B on A.brand_id = B.brand_id
INNER JOIN product.stock C on A.product_id= C.product_id
GROUP By  B.brand_name, A.model_year
order by B.brand_name DESC;



-- Select the least 3 products in stock according to stores.

SELECT TOP 3 C.store_name, A.product_name, SUM (B.quantity) AS stock_according_to_stores
FROM product.product A
INNER JOIN product.stock B ON A.product_id=B.product_id
INNER JOIN sale.store C ON B.store_id=C.store_id
GROUP BY C.store_name, A.product_name
ORDER BY stock_according_to_stores


-- Select the store which has the most sales quantity in 2018(

    select top 1  A.store_name , SUM(C.quantity ) as most_sales_quantity
	from sale.store A, sale.orders B, sale.order_item C
	where A.store_id =B.store_id and B.order_id=C.order_id 
	and order_date between '2018-01-01' and '2018-12-31'
    group by  A.store_name
	order by most_sales_quantity desc;


-- Select the store which has the most sales amount in 2018

select top 1  A.store_name , sum((C.quantity*C.list_price)*(1-C.discount)) as most_amount
	from sale.store A, sale.orders B, sale.order_item C
	where A.store_id =B.store_id and B.order_id=C.order_id  and year(B.order_date)= 2018
    group by  A.store_name
	order by most_amount desc;



-- Select the personnel which has the most sales amount in 2018

    select top 1 A.first_name, A.last_name , sum((C.quantity*C.list_price)*(1-C.discount)) as most_amount
	from sale.staff A, sale.orders B, sale.order_item C  
	where A.staff_id =B.staff_id and B.order_id=C.order_id  and year(B.order_date)= 2018
    group by A.first_name, A.last_name
	order by most_amount desc;


  -- Select the least 3 sold products in 2018 and 2019 according to city.


 SELECT TOP 3 D.city ,A.product_name, SUM(B.quantity) AS least3
 FROM product.product A, sale.order_item B, sale.orders C, sale.store D
 WHERE A.product_id=B.product_id AND B.order_id = C.order_id AND C.store_id=D.store_id AND (YEAR (c.order_date)=2018 OR YEAR(c.order_date)=2019)
 GROUP BY D.city, A.product_name
 ORDER BY least3

 




---////////////////////////////////////////////////////////////////////////////////////
---1. Find the customers who placed at least two orders per year.

select b.first_name, b.last_name , COUNT(a.order_date) as least_two ,year(a.order_date)
from sale.orders A 
INNER JOIN sale.customer B 
on a.customer_id = b.customer_id
GROUP BY A.customer_id, b.first_name, b.last_name, year(a.order_date)
having COUNT(a.order_date) > 1



---2. Find the total amount of each order which are placed in 2018. Then categorize them according to limits stated below.(You can use case when statements here)

select a.order_id,  sum((A.quantity*A.list_price)*(1-A.discount)) as total_amount,
	case
		 when sum((A.quantity*A.list_price)*(1-A.discount)) < 500 then 'very low'
	     when sum((A.quantity*A.list_price)*(1-A.discount)) >= 500  and sum((A.quantity*A.list_price)*(1-A.discount)) < 1000    then  'low'
		 when sum((A.quantity*A.list_price)*(1-A.discount)) >=  1000 and sum((A.quantity*A.list_price)*(1-A.discount)) < 5000   then  'medium'
		 when sum((A.quantity*A.list_price)*(1-A.discount)) >=  5000 and sum((A.quantity*A.list_price)*(1-A.discount)) < 10000  then  'medium'
		 else  'very high' end as total_amount
	from sale.order_item  A, sale.orders B
	where A.order_id =B.order_id and year(B.order_date)= 2020
    group by  A.order_id
	

select a.order_id,  sum((A.quantity*A.list_price)*(1-A.discount)) as total_amount,
	case
		 when sum((A.quantity*A.list_price)*(1-A.discount)) < 500 then 'very low'
	     when sum((A.quantity*A.list_price)*(1-A.discount)) >500    then  'low'
		 when sum((A.quantity*A.list_price)*(1-A.discount)) >1000   then  'medium'
		 when sum((A.quantity*A.list_price)*(1-A.discount)) >=  5000 and sum((A.quantity*A.list_price)*(1-A.discount)) < 10000  then  'medium'
		 else  'very high' end as total_amount
	from sale.order_item  A, sale.orders B
	where A.order_id =B.order_id and year(B.order_date)= 2020
    group by  A.order_id



--3. By using Exists Statement find all customers who have placed more than two orders.


select b.first_name, b.last_name , COUNT(a.order_date) as least_two 
from sale.orders A 
INNER JOIN sale.customer B 
on a.customer_id = b.customer_id
GROUP BY A.customer_id, b.first_name, b.last_name
having COUNT(a.order_date) > 2


SELECT first_name, last_name, customer_id
FROM sale.customer a 
WHERE exists(
            select COUNT(*)
            FROM sale.orders b WHERE b.customer_id = a.customer_id
            HAVING COUNT(*) > 2
            )
ORDER BY first_name, last_name;









--4. Show all the products and their list price, that were sold with more than two units in a sales order.

select DISTINCT A.product_id, A.product_name, B.list_price, b.quantity
from product.product A, sale.order_item B
WHERE A.product_id = B.product_id AND b.quantity >= 2





--5. Show the total count of orders per product for all times. (Every product will be shown in one line and the total order count will be shown besides it)

select  A.product_id, COUNT(DISTINCT C.order_id) AS total
from product.product A, sale.order_item B, sale.orders C
WHERE A.product_id = B.product_id AND C.order_id = B.order_id
GROUP BY A.product_id





--6. Find the products whose list prices are more than the average list price of products of all brands