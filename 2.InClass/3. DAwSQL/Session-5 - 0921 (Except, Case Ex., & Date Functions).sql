




-------25.10.2021 Session 5 (Except, Case Ex., Date & String Functions)

--Except

-- 2018 model bisiklet markalarýndan hangilerinin 2019 model bisikleti yoktur?
-- brand_id ve brand_name deðerlerini listeleyin




SELECT	brand_id, brand_name
FROM	product.brand
WHERE	brand_id IN (
					SELECT	brand_id
					FROM	product.product
					WHERE	model_year = 2018

					EXCEPT

					SELECT	brand_id
					FROM	product.product
					WHERE	model_year = 2019
					)



SELECT	DISTINCT model_year
FROM	product.product
WHERE	brand_id = 5



------



--Sadece 2019 yýlýnda sipariþ verilen diðer yýllarda sipariþ verilmeyen ürünleri getiriniz.





SELECT A.product_id, A.product_name
FROM product.product A 
INNER JOIN (
			SELECT	A.product_id
			FROM	sale.order_item A, sale.orders B
			WHERE	A.order_id = B.order_id
			AND		B.order_date BETWEEN '2019-01-01' AND '2019-12-31'

			EXCEPT

			SELECT	A.product_id
			FROM	sale.order_item A, sale.orders B
			WHERE	A.order_id = B.order_id
			AND		B.order_date NOT BETWEEN '2019-01-01' AND '2019-12-31'
			) B
ON A.product_id = B.product_id


----LIKE

SELECT	COUNT (DISTINCT A.product_id)
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		B.order_date LIKE '2019%'






SELECT A.product_id, A.product_name
FROM product.product A
INNER JOIN (
			SELECT	A.product_id
			FROM	sale.order_item A, sale.orders B
			WHERE	A.order_id = B.order_id
			AND		B.order_date BETWEEN '2019-01-01' AND '2019-12-31'
			) B
ON	A.product_id = B.product_id


--Case Expressions

--Simple Case Expression


--Order_Status isimli alandaki deðerlerin ne anlama geldiðini içeren yeni bir alan oluþturun.

-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed



SELECT  order_id, order_status,
		CASE order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			ELSE 'Completed'
		END AS mean_of_status
FROM	SALE.orders
ORDER BY order_status


----------------------

---staff tablosuna çalýþanlarýn maðaza isimlerini ekleyiniz.


--simple case ex

SELECT first_name, last_name, store_id,
	CASE store_id	
		WHEN 1 THEN 'Sacremento Bikes'
		WHEN 2 THEN 'Buffalo Bikes'
		ELSE 'San Angelo Bikes'
		
	END AS Store_name
FROM sale.staff



--searched case ex.

SELECT first_name, last_name,store_id,
		CASE
			WHEN store_id = 1 then 'Sacramento Bikes'
			WHEN store_id = 2 then 'Buffalo Bikes'
			WHEN store_id = 3 then 'San Angelo Bikes'
		END as Store_name
FROM sale.staff




--Müþterilerin e-mail adreslerindeki servis saðlayýcýlarýný yeni bir sütun oluþturarak belirtiniz.


SELECT	email,
		CASE	
			WHEN email LIKE '%@yahoo%' THEN 'Yahoo'
			WHEN email LIKE '%@gmail%' THEN 'Gmail'
			WHEN email LIKE '%@hotmail%' THEN 'Hotmail'
			WHEN email IS NOT NULL THEN 'Others'
		END Email_providers
FROM	sale.customer


-----///////////


--HOMEWORK DON'T LOOK TO THE SOLUTION :)
-- Ayný sipariþte hem Electric Bikes, hem Comfort Bicycles hem de Children Bicycles ürünlerini sipariþ veren müþterileri bulunuz.


SELECT	A.first_name, A.last_name
FROM	sales.customers A, sales.orders B
WHERE	A.customer_id = B.customer_id AND
		B.order_id IN	(
						SELECT	A.order_id
						FROM	sales.order_items A, production.products B
						WHERE	A.product_id = B.product_id AND
								B.category_id = (SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Electric Bikes')
						INTERSECT
						SELECT	A.order_id
						FROM	sales.order_items A, production.products B
						WHERE	A.product_id = B.product_id AND
								B.category_id = (SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Comfort Bicycles')
						INTERSECT
						SELECT	A.order_id
						FROM	sales.order_items A, production.products B
						WHERE	A.product_id = B.product_id AND
								B.category_id = (SELECT	category_id
												FROM	production.categories
												WHERE	category_name = 'Children Bicycles')
						)



-----------------------////////////////////////


--Date Functions

-- Data Types

CREATE TABLE t_date_time 
	(
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)


SELECT *
FROM	t_date_time


SELECT Getdate() as [now]


INSERT t_date_time 
VALUES (Getdate(), Getdate(), Getdate(), Getdate(), Getdate(), Getdate())



SELECT Getdate() as [now]

SELECT *
FROM	t_date_time


-------convert a date to varchar 
SELECT Getdate() as [now]


SELECT CONVERT(varchar , GETDATE() , 10)



----convert a varchar to date


SELECT CONVERT(DATE , '25 Oct 21', 1)



---------------



---Functions for return date or time parts

SELECT	A_date,
		DATENAME(WEEKDAY, A_date) [weekDAY],
		DAY (A_date) [DAY2],
		MONTH(A_date) [month],
		YEAR (A_date) [year],
		DATEPART(WEEK , A_DATE) WEEKDAY2,
		A_Time,
		DATEPART (NANOSECOND, A_time)
FROM	t_date_time




















