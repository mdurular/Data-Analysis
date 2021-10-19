--- 1.What is the sales quantity of product according to the brands and sort them highest-lowest
--solution 1
SELECT A.brand_name, SUM (O.quantity) AS Total_Quantity
FROM (select P.product_id, B.* from product.product P JOIN product.brand B ON P.brand_id = B.brand_id) AS A
JOIN sale.order_item  O ON A.product_id = O.product_id
GROUP BY A.brand_name
ORDER BY Total_Quantity DESC;

-- solution 2
SELECT   B.brand_name, count(C.quantity) total_quantity
FROM  product.product A INNER JOIN product.brand B on A.brand_id = B.brand_id
INNER JOIN sale.order_item C on A.product_id = c.product_id
group by B.brand_name
order by total_quantity desc;

------------------------/////////////////////-////////////////-///////////////////////-///////////////////////////////////-/////////////////////////------------------

---2.Select the top 5 most expensive products

SELECT TOP 5*
FROM product.product
ORDER BY list_price DESC;


------------------------/////////////////////-////////////////-///////////////////////-///////////////////////////////////-/////////////////////////------------------

---3.What are the categories that each brand has

SELECT DISTINCT B.brand_name,c.category_name 
FROM  product.product A INNER JOIN product.brand B on A.brand_id = B.brand_id
INNER JOIN  product.category C on A.category_id= C.category_id
group by B.brand_name,c.category_name ;


------------------------/////////////////////-////////////////-///////////////////////-///////////////////////////////////-/////////////////////////------------------
---4.-Select the avg prices according to brands and categories
SELECT DISTINCT B.brand_name,c.category_name, AVG(A.list_price) As list_price
FROM  product.product A INNER JOIN product.brand B on A.brand_id = B.brand_id
INNER JOIN  product.category C on A.category_id= C.category_id
group by B.brand_name,c.category_name ;
