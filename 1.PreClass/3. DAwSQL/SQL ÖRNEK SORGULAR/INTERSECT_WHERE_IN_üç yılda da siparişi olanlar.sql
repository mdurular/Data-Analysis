---2018,2019 VE 2020 YILLARININ HEPSÝNDE SÝPARÝÞÝ OLAN MÜÞTERÝLERÝN ÝSÝM VE SOYÝSMÝNÝ GETÝRÝNÝZ

SELECT	customer_id, first_name, last_name FROM	sale.customer
WHERE	customer_id IN	(
						SELECT	customer_id FROM	SALE.orders
						WHERE	order_date BETWEEN '2018-01-01' AND '2018-12-31'

						INTERSECT
						SELECT	customer_id	FROM	SALE.orders
						WHERE	order_date BETWEEN '2019-01-01' AND '2019-12-31'

						INTERSECT
						SELECT	customer_id	FROM	SALE.orders
						WHERE	order_date BETWEEN '2020-01-01' AND '2020-12-31'
						)
----------
SELECT A.customer_id, A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2018-01-01' AND '2018-12-31'

INTERSECT

SELECT A.customer_id, A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2019-01-01' AND '2019-12-31'

INTERSECT

SELECT A.customer_id, A.first_name, A.last_name
FROM sale.customer A, sale.orders B
WHERE A.customer_id=B.customer_id AND B.order_date BETWEEN '2020-01-01' AND '2020-12-31'