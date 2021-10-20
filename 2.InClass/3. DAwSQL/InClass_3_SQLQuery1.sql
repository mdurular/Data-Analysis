-- ROLL UP

SELECT brand, category, model_year, SUm(total_sales_price) AS total_price
FROM  sale.sales_summary
GROUP BY
    ROLLUP (brand, category, model_year);


--CUBE
SELECT brand, category, model_year, SUm(total_sales_price) AS total_price
FROM  sale.sales_summary
GROUP BY
    CUBE (brand, category, model_year)
ORDER BY brand, category;

-- PIVOT
SELECT Category, Model_Year , SUM(total_sales_price)
FROM sale.sales_summary
GROUP BY Category, Model_Year
ORDER BY 1,2


----------------------
SELECT *
FROM
	(
	SELECT Category, Model_Year, total_sales_price
	FROM	SALE.sales_summary
	) A
PIVOT
	(
	SUM(total_sales_price)
	FOR Category
	IN (
	[Children Bicycles],
    [Comfort Bicycles],
    [Cruisers Bicycles],
    [Cyclocross Bicycles],
    [Electric Bikes],
    [Mountain Bikes],
    [Road Bikes]
		)
	) AS P1

	---------------------

	select * from
(
SELECT category, model_year, total_sales_price
from sale.sales_summary
) as A
PIVOT (
    sum(total_sales_price)
    for model_year in ([2018], [2019], [2020])
) as pivottable


--subquery
--CORRELATED

SELECT order_id , SUM(list_price) AS SUM_PRICE
FROM sale.order_item
GROUP BY order_id;


SELECT DISTINCT order_id , (SELECT SUM(list_price) FROM sale.order_item B WHERE A.Order_id=B.Order_id) AS SUM_PRICE
FROM sale.order_item A

------
 SELECT *
 FROM sale.staff
 WHERE store_id = (SELECT store_id FROM sale.staff WHERE first_name = 'Maria' and last_name= 'Cussona')

 -----
 SELECT*
 FROM sale.staff
 WHERE manager_id = (SELECT staff_id FROM sale.staff WHERE first_name = 'Jane' and last_name= 'Destrey')

 -----
 SELECT customer_id, order_date
 FROM sale.orders
 WHERE customer_id IN (SELECT customer_id  FROM sale.customer WHERE city = 'Holbrook')

 ------ Abby	Parks isimli müþterinin alýþveriþ yaptýðý tarihte/tarihlerde alýþveriþ yapan tüm müþterileri listeleyin.
------- Müþteri adý, soyadý ve sipariþ tarihi bilgilerini listeleyin.

 SELECT B.first_name, B.last_name, A.order_date
 FROM sale.orders A INNER JOIN sale.customer B on A.customer_id=B.customer_id
 WHERE A.order_date 
 IN  (SELECT order_date  FROM sale.orders WHERE customer_id 
 IN (SELECT customer_id FROM sale.customer WHERE first_name = 'Abby' and last_name= 'Parks'))

 -----
 SELECT *
 FROM product.product
 WHERE list_price > ALL (SELECT A.list_price
 FROM product.product A INNER JOIN product.category B ON A.category_id = B.category_id
 WHERE B.category_name ='Electric Bikes') AND model_year =2020
 ORDER BY list_price DESC

 -------
