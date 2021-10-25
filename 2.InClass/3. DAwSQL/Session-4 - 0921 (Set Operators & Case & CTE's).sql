


--- 23.10.2021 DAwSQL Session-4 Set Operators & Case Expression

---Exists

--'Trek Remedy 9.8 - 2019' ürününün sipariþ verilmediði state/state' leri getiriniz.


SELECT *
FROM	SALE.orders




SELECT DISTINCT state
FROM sale.customer X
WHERE	NOT EXISTS
					(
					SELECT A.product_id, A.product_name, B.product_id, B.order_id, C.order_id, C.customer_id, D.*
					FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
					WHERE	A.product_id = B.product_id
					AND		B.order_id = C.order_id
					AND		C.customer_id = D.customer_id
					AND		A.product_name = 'Trek Remedy 9.8 - 2019'
					AND		X.state = D.state
					)



---Views


-- 2019 yýlýndan sonra üretilen ürünlerin bulunduðu bir 'NEW_PRODUCTS' view' i oluþturun



create view new_view as
select product_id, model_year
from product.product
where model_year > 2018



DROP VIEW new_view

SELECT * FROM new_view



---CTE's

-- Sharyn Hopkins isimli müþterinin son sipariþinden önce sipariþ vermiþ 
--ve San Diego þehrinde ikamet eden müþterileri listeleyin.



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



-----//////////

-- Abby	Parks isimli müþterinin alýþveriþ yaptýðý tarihte/tarihlerde alýþveriþ yapan tüm müþterileri listeleyin.
-- Müþteri adý, soyadý ve sipariþ tarihi bilgilerini listeleyin.


WITH T1 AS
(
SELECT	order_date
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id
AND		A.first_name = 'Abby'
AND		A.last_name = 'Parks'
)
SELECT	A.order_date, A.order_id, B.first_name, B.last_name
FROM	sale.orders A, sale.customer B, T1
WHERE	A.customer_id  = B.customer_id 
AND		A.order_date = T1.order_date


-------------------------



WITH T1 AS
(
SELECT 0 AS NUM
UNION ALL
SELECT NUM + 2 
FROM	T1
WHERE	NUM < 9
)
SELECT *
FROM T1
;

-----------

---Set Operators

-- Sacramento þehrindeki müþteriler ile Monroe þehrindeki müþterilerin soyisimlerini listeleyin


SELECT	last_name
FROM	sale.customer
WHERE	city = 'Sacramento'

UNION ALL

SELECT	last_name
FROM	sale.customer
WHERE	city = 'Monroe'
ORDER BY last_name

-----UNION


SELECT	last_name
FROM	sale.customer
WHERE	city = 'Sacramento'

UNION 

SELECT	last_name
FROM	sale.customer
WHERE	city = 'Monroe'
ORDER BY last_name

----

--adý carter veya soyadý carter olan müþterileri listeleyin (or kullanmayýnýz)



select first_name, last_name
from sale.customer
where first_name= 'Carter'
UNION ALL
select first_name, last_name
from sale.customer
where last_name= 'Carter'

----


select first_name, last_name, customer_id
from sale.customer
where first_name= 'Carter'

UNION ALL

select first_name, last_name, customer_id
from sale.customer
where last_name= 'Carter'



---
-- Write a query that returns brands that have products for both 2018 and 2019.
--hem 2018 yýlýnda hem de 2019 yýlýnda ürünü olan markalarý getiriniz


SELECT	B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
AND		A.model_year = 2018

INTERSECT

SELECT	B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
AND		A.model_year = 2019


----/////////

---2018,2019 VE 2020 YILLARININ HEPSÝNDE SÝPARÝÞÝ OLAN MÜÞTERÝLERÝN ÝSÝM VE SOYÝSMÝNÝ GETÝRÝNÝZ




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

-----------

SELECT	*
FROM	SALE.orders
WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'


----------

SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2018-01-01' AND '2018-12-31'

INTERSECT

SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2019-01-01' AND '2019-12-31'

INTERSECT

SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2020-01-01' AND '2020-12-31'













