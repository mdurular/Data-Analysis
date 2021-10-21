
SELECT C.brand_name as Brand, D.category_name as Category,B.model_year as Model_Year, 
ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO sale.sales_summary  -- Creates New table
FROM sale.order_item A  -- total sales
JOIN product.product B  ON A.product_id = B.product_id-- model year
JOIN product.brand C ON  C.brand_id = B.brand_id -- brand name
JOIN product.category D ON D.category_id = B.category_id -- category names
GROUP BY C.brand_name, D.category_name,B.model_year ;


select * from sale.sales_summary

--1. Calculate the total sales price.

SELECT SUM(total_sales_price) as TotalSalePrice
FROM sale.sales_summary

--Calculate the total sales price by categories
SELECT Category , SUM(total_sales_price) as TotalSalePrice
FROM sale.sales_summary
GROUP BY Category

SELECT Brand, SUM(total_sales_price) as TotalSalePrice
FROM sale.sales_summary
GROUP BY Brand

-- group by category and brand
SELECT category, brand,  SUM(total_sales_price) as TotalSalePrice
FROM sale.sales_summary
GROUP BY
	Brand, Category
ORDER BY 1,2

--GROUPING SETS
--Perform the above variations in a single query using 'Grouping Sets'.
SELECT	brand, category, SUM(total_sales_price) as Total_Sales
FROM	sale.sales_summary
GROUP BY
	GROUPING SETS (
					(brand,category),
					(brand),
					(Category),
					()
					)
ORDER BY Brand, Category;

--ROLLUP
SELECT	brand, category,model_year, SUM(total_sales_price) as Total_Sales
FROM	sale.sales_summary
GROUP BY
	GROUPING SETS (
					(brand,category,model_year),
					(brand,category),
					(brand),
					()
					)
ORDER BY Brand, Category;

--Same result can be achieved by ROLLUP

SELECT	brand, category,model_year, SUM(total_sales_price) as Total_Sales
FROM	sale.sales_summary
GROUP BY
	ROLLUP (brand,category,model_year)
ORDER BY Brand, Category;

--CUBE
--Generate different grouping variations that can be produced with the brand and category columns using 'CUBE'.
SELECT	  category, brand, model_year, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		CUBE (brand,category, model_year)
ORDER BY
	 category, brand;

----------------------------------------------------------------
--PIVOT---
----------------------------------------------------------------
--1. Create a Derived Table
--2. Create the PIVOT
--3. Create SELECT

SELECT  *
FROM
(SELECT brand, total_sales_price ,model_year
FROM sale.sales_summary) A

PIVOT (
	 sum(total_sales_price)  -- aggregation
	 FOR brand            -- spreading
		IN (	
	[Trek] /* 
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes]*/ )
	) AS PIVOT_TABLE
	------------------------------------------

	SELECT  *
FROM
(SELECT category, total_sales_price ,model_year
FROM sale.sales_summary) A

PIVOT (
	 sum(total_sales_price)  -- aggregation
	 FOR category            -- spreading
		IN (	
	[Children Bicycles], 
    [Comfort Bicycles], 
    [Cruisers Bicycles], 
    [Cyclocross Bicycles], 
    [Electric Bikes], 
    [Mountain Bikes], 
    [Road Bikes])
	) AS PIVOT_TABLE

--Session : 3:
--SUBQUERIES

--Show difference between product price and average product price

select avg(list_price)
from product.product

SELECT P.product_name, list_price - (select avg(list_price)from product.product) as DiffereceFromAverage
FROM product.product P

--Subquery in SELECT Statement

--Write a query that returns the total list price by each order ids.
--NOTE: This is actually also a correlated subquery so we will revisit later

SELECT SUM(list_price)
FROM sale.order_item A /* ....to be completed later*/
---------------------------------------------------------------
---------------------------------------------------------------

/* ORGANIZED COMPLEX QUERIES */

--Bring all the personnels from the store that Maria Cussona works

SELECT *
FROM sale.staff 
WHERE store_id = (SELECT store_id
				  FROM sale.staff
				  WHERE first_name = 'Maria' AND last_name = 'Cussona')

-- List the staff that  Jane Destreyis the manager of.

SELECT *
FROM sale.staff
WHERE manager_id = (SELECT staff_id
				    FROM sale.staff
					WHERE first_name = 'Jane' AND last_name = 'Destrey') /* Subquery that returns Jane's staff_id*/

-- Write a query that returns customers in the city where the 'Sacramento Bikes' or 'Buffalo Bikes' store is located.

SELECT first_name, last_name, city
FROM sale.customer
WHERE city in (SELECT distinct city
			  FROM sale.store
			  WHERE store_name = 'Sacramento Bikes' OR store_name = 'Buffalo Bikes') 

--List bikes with product_id, product name, brand name, category name, list price that are more expensive than the 'Trek CrossRip+ - 2020' bike.
SELECT * ---  A.product_id, A.product_name, B.brand_name, C.category_name, A.list_price
FROM product.product A INNER JOIN
 product.brand B on A.brand_id = B.brand_id INNER  JOIN
 product.category C ON A.category_id = C.category_id
 WHERE A.list_price  > (SELECT list_price
						FROM product.product
						WHERE product_name = 'Trek CrossRip+ - 2020')
 ORDER BY 5 DESC

 -- List customers whose order dates are before Arla Ellis.

 --First let's find Arla's Order date
 SELECT A.first_name, A.last_name, B.order_date
 FROM sale.customer A
	JOIN sale.orders B ON A.customer_id = B.customer_id
 WHERE B.order_date <  (SELECT B.order_date
					    FROM	sale.customer A
						JOIN sale.orders B ON A.customer_id = B.customer_id
						WHERE A.first_name = 'Arla' AND A.last_name = 'Ellis')

--List order dates for customers residing in the Holbrook city.
SELECT  A.order_date
FROM sale.orders A 
  ---JOIN sale.customer B ON A.customer_id = B.customer_id
WHERE A.customer_id IN (SELECT customer_id
						FROM  sale.customer
						WHERE city = 'Holbrook')

-- List all customers who orders on the same dates as Abby Parks.
SELECT B.customer_id, B.first_name, B.last_name, A.order_date
FROM sale.orders A 
	JOIN sale.customer B ON A.customer_id = B.customer_id
WHERE A.order_date IN (SELECT B.order_date
						FROM sale.customer A JOIN
						sale.orders B on A.customer_id = B.customer_id
						WHERE A.first_name = 'Abby' AND A.last_name = 'Parks')

--List products in categories other than Cruisers Bicycles, Mountain Bikes, or Road Bikes in 2018.
SELECT product_id, product_name
FROM product.product
WHERE category_id NOT IN (
SELECT category_id
FROM product.category
WHERE category_name IN( 
	'Cruisers Bicycles', 
	'Mountain Bikes', 
	'Road Bikes'))
AND 
model_year = 2018

-- List bikes that model year equal to 2020 and its prices more than ALL electric bikes.
SELECT product_name, model_year, list_price
FROM product.product
WHERE list_price > ALL  (SELECT A.list_price
						FROM product.product A 
						JOIN product.category B ON A.category_id = B.category_id
						WHERE B.category_name = 'electric bikes')
AND model_year = 2020

-- List bikes that model year equal to 2020 and its prices more than ANY electric bikes.

SELECT product_name, model_year, list_price
FROM product.product
WHERE list_price > ANY  (SELECT A.list_price
						FROM product.product A 
						JOIN product.category B ON A.category_id = B.category_id
						WHERE B.category_name = 'electric bikes')
AND model_year = 2020

SELECT * 
FROM sale.customer
WHERE EXISTS (SELECT * from product.product WHERE 1 = 0)

---------CORRELATED SUBQUERIES

--EXISTS / NOT EXISTS

--Write a query that returns State where 'Trek Remedy 9.8 - 2019' proudct is not ordered
SELECT distinct state
FROM
sale.customer X
WHERE NOT EXISTS
(
SELECT	1
FROM	product.product A 
		JOIN sale.order_item B ON A.product_id = B.product_id 
		JOIN sale.orders C ON B.order_id = C.order_id
		JOIN sale.customer D ON C.customer_id = D.customer_id
WHERE	
	A.product_name = 'Trek Remedy 9.8 - 2019'
AND		D.STATE = X.STATE
) 
