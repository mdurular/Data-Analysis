


/* WINDOW FUNCTIONS */



-- 3. ANALYTIC NUMBERING FUNCTIONS --

	
--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()



--Assign an ordinal number to the bike prices for each category in ascending order
--1. Herbir kategori içinde bisikletlerin fiyat sıralamasını yapınız (artan fiyata göre 1'den başlayıp birer birer artacak)

SELECT	category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) Row_num
FROM	product.product
;


---/////


-- Lets try previous query again using RANK() function.

-- Aynı soruyu aynı fiyatlı bisikletler aynı sıra numarasını alacak şekilde yapınız (RANK fonksiyonunu kullanınız)





SELECT	category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) Row_num,
		RANK() OVER(PARTITION BY category_id ORDER BY list_price) Rank_num
FROM	product.product
;


----//////



-- Lets try previous query again using DENSE_RANK() function.


SELECT	category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) Row_num,
		RANK() OVER(PARTITION BY category_id ORDER BY list_price) Rank_num,
		DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) Dence_rank_num
FROM	product.product
;




--/////


-- Write a query that returns the cumulative distribution of sum of product quantity customers ordered.

WITH T1 AS
		(
		SELECT	customer_id, SUM (quantity) product_quantity
		FROM	sale.orders A, sale.order_item B
		WHERE	A.order_id = B.order_id
		GROUP BY customer_id
		)
SELECT	DISTINCT product_quantity, 
		ROUND (CUME_DIST() OVER (ORDER BY product_quantity) , 3) AS CUM_DIST
FROM	T1
ORDER BY 1
;




---//////////////////


-- Write a query that returns the relative standing of the sum of product quantity customers ordered.

WITH T1 AS
		(
		SELECT	customer_id, SUM (quantity) product_quantity
		FROM	sale.orders A, sale.order_item B
		WHERE	A.order_id = B.order_id
		GROUP BY customer_id
		)
SELECT	DISTINCT product_quantity, 
		ROUND (PERCENT_RANK() OVER (ORDER BY product_quantity) , 3) AS PERCENT_RNK
FROM	T1
ORDER BY 1
;



----//////////


--Divide customers into 3 groups based on the quantity of product they order.


WITH T1 AS
		(
		SELECT	customer_id, SUM (quantity) product_quantity
		FROM	sale.orders A, sale.order_item B
		WHERE	A.order_id = B.order_id
		GROUP BY customer_id
		)
SELECT	customer_id,
		NTILE(5) OVER (ORDER BY product_quantity) AS GROUP_BY_QUANTITIY
FROM	T1
ORDER BY 1
;

-----------///////////////


--Write a query that returns both of the followings:
--The average product price of orders.
--Average net amount.


--Aşağıdakilerin her ikisini de döndüren bir sorgu yazın:
--Siparişlerin ortalama ürün fiyatı.
--Ortalama net tutar.



SELECT	DISTINCT 
		order_id, 
		AVG(list_price) OVER (PARTITION BY order_id) Avg_price,
		AVG(quantity*list_price*(1-discount)) OVER () Avg_net_amount
FROM	SALE.order_item



----///////////////


--List orders for which the average product price is higher than the average net amount.
--Ortalama ürün fiyatının ortalama net tutardan yüksek olduğu siparişleri listeleyin.


WITH T1 AS
(
SELECT	DISTINCT 
		order_id, 
		AVG(list_price) OVER (PARTITION BY order_id) Avg_price,
		AVG(quantity*list_price*(1-discount)) OVER () Avg_net_amount
FROM	SALE.order_item
) 
SELECT * 
FROM	T1
WHERE	Avg_price > Avg_net_amount
ORDER BY 2



--------///////

--Calculate the stores' weekly cumulative number of orders for 2016


--mağazaların 2018 yılına ait haftalık kümülatif sipariş sayılarını hesaplayınız


SELECT	DISTINCT B.store_id, B.store_name, Datepart(WK, A.order_date) week_of_year, 
		COUNT(*) OVER (PARTITION BY A.store_id, Datepart(WK, A.order_date)) weeks_order,
		COUNT(*) OVER (PARTITION BY A.store_id ORDER BY Datepart(WK, A.order_date)) cume_total_order
FROM	sale.orders A, sale.store B
WHERE	A.store_id = B.store_id
AND		YEAR(A.order_date)  = 2018
ORDER BY b.store_id, WEEK_OF_YEAR


-----/////


--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' arasında satılan ürün sayısının 7 günlük hareketli ortalamasını hesaplayın.




WITH T1 AS 
(
SELECT	DISTINCT order_date, SUM(quantity) OVER (PARTITION BY order_date) sum_quantity
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		B.order_date BETWEEN '2018-03-12' AND '2018-04-12'
)
SELECT	order_date,  sum_quantity,
		AVG(sum_quantity) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW ) sales_moving_average_7
FROM	T1














