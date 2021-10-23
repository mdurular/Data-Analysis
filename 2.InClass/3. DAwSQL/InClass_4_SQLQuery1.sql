SELECT DISTINCT state
FROM sale.customer X
WHERE NOT EXISTS (

SELECT a.product_id, a.product_name, b.product_id, b.order_id, c.order_id, c.customer_id, d.*
FROM product.product A,  sale.order_item B,  sale.orders C,  sale.customer D
WHERE A.product_id = b.product_id
AND B.order_id = C.order_id
AND C.customer_id = D.customer_id
AND A.product_name = 'Trek Remedy 9.8 - 2019'
AND X.state = D.state
)

---VÝEW

CREATE VIEW NEW_PRODUCTS AS
SELECT A.*
FROM product.product A
WHERE A.model_year = 2019


DROP VIEW NEW_PRODUCTS


---CTE

WITH T1 AS
(
SELECT	max(order_date) last_purchase
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id
AND		A.first_name = 'Sharyn'
AND		A.last_name = 'Hopkins'
)
SELECT	DISTINCT A.order_date, A.order_id, B.customer_id, B.first_name, B.last_name, B.city
FROM	sale.orders A, sale.customer B, T1
WHERE	A.customer_id = B.customer_id
AND		A.order_date < T1.last_purchase
AND		B.city = 'San Diego'


WITH T2 AS
(
SELECT	B.order_date AS orderdate
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id
AND		A.first_name = 'Abby'
AND		A.last_name = 'Parks'
)
SELECT	DISTINCT A.order_date, A.order_id, B.customer_id, B.first_name, B.last_name, B.city
FROM	sale.orders A, sale.customer B, T2
WHERE	A.customer_id = B.customer_id
AND		A.order_date IN T2.orderdate

----- Abby	Parks isimli müþterinin alýþveriþ yaptýðý tarihte/tarihlerde alýþveriþ yapan tüm müþterileri listeleyin.
-- Müþteri adý, soyadý ve sipariþ tarihi bilgilerini listeleyin.
WITH T2 AS
(
SELECT	B.order_date AS orderdate
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id
AND		A.first_name = 'Abby'
AND		A.last_name = 'Parks'
)
SELECT	B.first_name, B.last_name,A.order_date
FROM	sale.orders A, sale.customer B, T2
WHERE	A.customer_id = B.customer_id
AND		A.order_date IN (T2.orderdate)


WITH T1 AS
(
SELECT 1 AS NUM
UNION ALL
SELECT NUM + 1
FROM T1
WHERE NUM < 9
)
SELECT *
FROM T1

---SET OPERATORS
----UNION AND UNION ALL

SELECT last_name
FROM sale.customer
WHERE city = 'Sacramento'

UNION ALL

SELECT last_name
FROM sale.customer
WHERE city = 'Monroe'
ORDER BY last_name

-----
SELECT last_name
FROM sale.customer
WHERE city = 'Sacramento'

UNION 

SELECT last_name
FROM sale.customer
WHERE city = 'Monroe'
ORDER BY last_name

----

SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Carter'
UNION ALL
SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Carter'

----

SELECT COUNT(*)
FROM
(SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Carter'
UNION ALL
SELECT first_name, last_name
FROM sale.customer
WHERE last_name = 'Carter') A

---INTERSECT

SELECT B.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id=B.brand_id AND A.model_year = 2018 
INTERSECT
SELECT B.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id=B.brand_id AND A.model_year = 2019 


----

SELECT b.first_name, B.last_name	
FROM sale.orders A, sale.customer B
WHERE A.customer_id=B.customer_id AND a.order_date BETWEEN '2018-01-01' AND '2018-12-31'
INTERSECT
SELECT b.first_name, B.last_name
FROM sale.orders A, sale.customer B
WHERE A.customer_id=B.customer_id AND a.order_date BETWEEN '2019-01-01' AND '2019-12-31'
INTERSECT
SELECT b.first_name, B.last_name
FROM sale.orders A, sale.customer B
WHERE A.customer_id=B.customer_id AND a.order_date BETWEEN '2020-01-01' AND '2020-12-31'

-------
SELECT	customer_id, first_name, last_name
FROM	sale.customer
WHERE	customer_id IN	(
						SELECT	customer_id
						FROM	SALE.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	SALE.orders
						WHERE	order_date BETWEEN '2019-01-01' AND '2019-12-31'
						INTERSECT
						SELECT	customer_id
						FROM	SALE.orders
						WHERE	order_date BETWEEN '2020-01-01' AND '2020-12-31'
						)