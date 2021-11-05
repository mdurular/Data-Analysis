




--1. Tüm bisikletler arasýnda en ucuz bisikletin adý (FIRST_VALUE fonksiyonunu kullanýnýz)



SELECT DISTINCT FIRST_VALUE(product_name) OVER(ORDER BY list_price) AS F_V
FROM product.product


--2. Herbir kategorideki en ucuz bisikletin adý (FIRST_VALUE fonksiyonunu kullanýnýz)


SELECT	DISTINCT category_id,
		FIRST_VALUE(product_name) OVER(PARTITION BY category_id ORDER BY list_price) AS F_V
FROM product.product


--3. 1. maddeyi LAST_VALUE fonksiyonu kullanarak yapýnýz


SELECT DISTINCT 
		last_value(product_name) OVER(ORDER BY list_price DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS F_V
FROM product.product



SELECT DISTINCT 
		last_value(product_name) OVER(ORDER BY list_price DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS F_V
FROM product.product



--SELECT DISTINCT 
--		last_value(product_name) OVER(ORDER BY list_price DESC RANGE BETWEEN 1 PRECEDING AND 4 FOLLOWING) AS F_V
--FROM product.product



--1. Herbir personelin bir önceki satýþýnýn sipariþ tarihini yazdýrýnýz (LAG fonksiyonunu kullanýnýz)


SELECT *
FROM sale.staff A


SELECT *
FROM sale.orders A


SELECT B.staff_id, B.first_name, B.last_name, A.order_id, A.order_date,
		LAG(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id)
FROM sale.orders A , sale.staff B
WHERE A.staff_id = B.staff_id



-------------


--2. Herbir personelin bir sonraki satýþýnýn sipariþ tarihini yazdýrýnýz (LEAD fonksiyonunu kullanýnýz)


SELECT B.staff_id, B.first_name, B.last_name, A.order_id, A.order_date,
		LEAD(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) AS NEXT_ORDER_DATE
FROM sale.orders A , sale.staff B
WHERE A.staff_id = B.staff_id



-----

--1. Herbir kategori içinde bisikletlerin fiyat sýralamasýný yapýnýz (artan fiyata göre 1'den baþlayýp birer birer artacak)


SELECT	category_id, list_price, ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price)
FROM	product.product




----------/////

-- Ayný soruyu ayný fiyatlý bisikletler ayný sýra numarasýný alacak þekilde yapýnýz (RANK fonksiyonunu kullanýnýz)


SELECT	category_id, list_price, 
		ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM	product.product



--AYNI SORU DENSE_RANK()

SELECT	category_id, list_price, 
		ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM	product.product



---------------

--Müþterilerin sipariþ ettikleri ürün sayýlarýnýn kümülatif daðýlýmýný gösteriniz


SELECT *
FROM	SALE.orders

SELECT *
FROM	SALE.order_item


WITH T1 AS
(
SELECT	A.customer_id, SUM(quantity) product_quantity
FROM	SALE.orders A, SALE.order_item B
WHERE	 A.order_id = B.order_id
GROUP BY A.customer_id
) 
SELECT DISTINCT product_quantity, ROUND(CUME_DIST() OVER (ORDER BY product_quantity) , 2)CUM_DIST
FROM	T1
ORDER BY 1



--Müþterilerin sipariþ ettikleri ürün sayýlarýnýn göreceli pozisyonunu gösteriniz


WITH T1 AS
(
SELECT	A.customer_id, SUM(quantity) product_quantity
FROM	SALE.orders A, SALE.order_item B
WHERE	 A.order_id = B.order_id
GROUP BY A.customer_id
) 
SELECT DISTINCT product_quantity, 
		ROUND(PERCENT_RANK() OVER (ORDER BY product_quantity) , 2) PERCENT_RANK_
FROM	T1
ORDER BY 1





-------



SELECT A.customer_id, SUM(quantity) product_quantity
FROM sale.orders A, sale.order_item B
where A.order_id= B.order_id
GROUP BY A.customer_id
ORDER BY 2



with t1 as
(
SELECT A.customer_id, SUM(quantity) product_quantity
FROM sale.orders A, sale.order_item B
where A.order_id= B.order_id
GROUP BY A.customer_id
)
select customer_id, ntile(5) over ( order by product_quantity DESC ) group_dist
from t1
order by 1;



--Aþaðýdakilerin her ikisini de döndüren bir sorgu yazýn:
--Sipariþlerin ortalama ürün fiyatý.
--Ortalama net tutar.



SELECT	*, list_price*quantity*(1-discount)
FROM	SALE.order_item



SELECT	distinct order_id, 
		AVG(list_price) OVER (PARTITION BY order_id) AVG_LIST_PRICE,
		AVG(list_price*quantity*(1-discount)) OVER () AVG_NET_PRICE
FROM	SALE.order_item



--Ortalama ürün fiyatýnýn ortalama net tutardan yüksek olduðu sipariþleri listeleyin.


WITH T1 AS 
(
SELECT	distinct order_id, 
		AVG(list_price) OVER (PARTITION BY order_id) AVG_LIST_PRICE,
		AVG(list_price*quantity*(1-discount)) OVER () AVG_NET_PRICE
FROM	SALE.order_item
) 
SELECT *
FROM	T1
WHERE	AVG_LIST_PRICE > AVG_NET_PRICE
ORDER BY 1




---------------

--maðazalarýn 2018 yýlýna ait haftalýk kümülatif sipariþ sayýlarýný hesaplayýnýz



SELECT	DISTINCT b.store_id, b.store_name, a.order_date, DATEPART(WEEK, A.order_date) weeks
FROM	sale.orders A, SALE.store B
WHERE	A.store_id = B.store_id
AND		YEAR(order_date) = 2018



SELECT	DISTINCT b.store_id, b.store_name, DATEPART(WEEK, A.order_date) weeks,
		COUNT (*) OVER (PARTITION BY B.store_id, DATEPART(WEEK, A.order_date)) cnt_order_per_week,
		COUNT (*) OVER (PARTITION BY B.store_id ORDER BY DATEPART(WEEK, A.order_date)) cnt_cumulative
FROM	sale.orders A, SALE.store B
WHERE	A.store_id = B.store_id
AND		YEAR(order_date) = 2018





SELECT	DISTINCT b.store_id, b.store_name, DATEPART(WEEK, A.order_date) weeks,
		COUNT (*) OVER (PARTITION BY B.store_id ORDER BY DATEPART(WEEK, A.order_date)) cnt_cumulative
FROM	sale.orders A, SALE.store B
WHERE	A.store_id = B.store_id
AND		YEAR(order_date) = 2018

------------------




--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.


WITH T1 AS 
(
SELECT	DISTINCT order_date, SUM(quantity) OVER (PARTITION BY order_date) sum_quantity
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		B.order_date BETWEEN '2018-03-12' AND '2018-04-12'
)
SELECT	order_date,  sum_quantity,
		AVG(sum_quantity) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) sales_moving_average_7
FROM	T1
























