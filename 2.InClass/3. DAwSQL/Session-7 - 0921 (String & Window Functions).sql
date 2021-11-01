






--Replace

SELECT REPLACE('CHARACTER STRING', ' ', '/')


SELECT REPLACE(123123123555, 123, 88)



--STR

SELECT STR(5454)


SELECT STR(5454, 4)



SELECT STR(5454.475, 7)

SELECT STR(5454.475, 7, 3)




select replace(1232435464, 123, 'aha') + 1

select replace(1232435464, 123, 123) + 1


select isnumeric(replace(1232435464, 123, 222))

select isnumeric(replace(1232435464, 123, 'aha'))



--Cast


SELECT CAST(123135 AS VARCHAR)


SELECT CAST(0.3333333 AS NUMERIC(3,2))

SELECT CAST(0.3333333 AS DECIMAL(3,2))

--Convert


SELECT CONVERT(INT , 30.48)

SELECT CONVERT(DATETIME , '2021-10-10')


SELECT CONVERT (nvarchar , '2021-10-10' , 6)



---------------


--Coalesce


SELECT COALESCE(NULL, NULL, 'Ahmet', NULL)



---NULLIF

SELECT NULLIF (10, 9)




---ROUND


SELECT ROUND(432.368, 2)



SELECT ROUND(432.368, 3)

SELECT ROUND(432.368, 2, 1)


SELECT ROUND(432.364, 2)


SELECT ROUND(432.364, 1)


SELECT ROUND(432.364, 1, 1)


-----


----Müþterilerin mailleri arasýndan kaç tanesi yahoo mailidir?


select
sum(case when patindex('%@yahoo%', email) <> 0 and patindex('%@yahoo%', email) is not null then 1 else 0 end) as yahoo
from sale.customer



SELECT	count(*)
FROM	sale.customer
WHERE	email LIKE '%@yahoo%'



SELECT SUM(CASE WHEN PATINDEX ('%@yahoo%', email) > 0 THEN 1 ELSE 0 END) 
FROM sale.customer




-------------


SELECT email, LEFT(email, CHARINDEX('.', email)-1)
FROM sale.customer


-----------


---/////////////

--her müþteriye ulaþabileceðim telefon veya email bilgisini istiyorum.
--Müþterinin telefon bilgisi varsa email bilgisine gerek yok.
--telefon bilgisi yoksa email adresi iletiþim bilgisi olarak gelsin.
--beklenen sütunlar: customer_id, first_name, last_name, contact


SELECT	*, COALESCE(phone, nullif(email, 'emily.brooks@yahoo.com'), 'a') contact
FROM	sale.customer



--street sütununda soldan üçüncü karakterin rakam olduðu kayýtlarý getiriniz.



SELECT	street, SUBSTRING(street, 3, 1)
FROM	sale.customer
WHERE	ISNUMERIC(SUBSTRING(street, 3, 1)) = 1


----

SELECT	street, SUBSTRING(street, 3, 1)
FROM	sale.customer
WHERE	SUBSTRING(street, 3, 1) LIKE '[0-9]'


SELECT	street, SUBSTRING(street, 3, 1)
FROM	sale.customer
WHERE	SUBSTRING(street, 3, 1) NOT LIKE '[a-z]'


SELECT	street, SUBSTRING(street, 3, 1)
FROM	sale.customer
WHERE	SUBSTRING(street, 3, 1) NOT LIKE '[^0-9]'



--------------


------///////////////////////-------------
------///////////////////////-------------
------///////////////////////-------------
------///////////////////////-------------


---WINDOW FUNCTIONS

--ürünlerin stock sayýlarýný bulunuz


SELECT	product_id, SUM(quantity) CNT_STOCK
FROM	product.stock
GROUP BY product_id
ORDER BY 1



SELECT	product_id
FROM	product.stock
GROUP BY product_id




----


SELECT distinct product_id, SUM(quantity) OVER (PARTITION BY product_id) total_stock
FROM	product.stock



---window frames


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id  ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id



-------------------



--1. Tüm bisikletler arasýnda en ucuz bisikletin fiyatý


SELECT	MIN(list_price) OVER ()
FROM	product.product


--2. Herbir kategorideki en ucuz bisikletin fiyatý

SELECT	DISTINCT category_id, MIN(list_price) OVER (PARTITION BY category_id)
FROM	product.product



