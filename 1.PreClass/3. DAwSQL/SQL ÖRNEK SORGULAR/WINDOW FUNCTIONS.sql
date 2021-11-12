--******* WINDOW FUNCTIONS �OVER� �LE KULLANILIR ****** 
--* AGG() + OVER() AS 
--* AGG() + OVER(OREDER BY.....) AS 
--* AGG() + OVER(PARTITION BY.....) AS 
--* AGG() + OVER(PARTITION BY.... OREDER BY.....) AS

--Sipari�lerin ortalama �r�n fiyat� ve ortalama net tutar.

SELECT	distinct order_id, 
		AVG(list_price) OVER (PARTITION BY order_id) AVG_LIST_PRICE,
		AVG(list_price*quantity*(1-discount)) OVER () AVG_NET_PRICE
FROM	SALE.order_item

-- MODEL YILINA G�RE B�S�KLET SATI� TUTARLARI
select product_id, model_year, list_price, 
sum(list_price) over() as total_price, 
sum(list_price) over(partition by model_year) as price_by_year, 
sum(list_price) over(partition by model_year order by product_id) as cumulative, 
sum(list_price) over(partition by model_year order by product_id rows between 1 preceding and 1 following) as ��_SATIR_TOPLAMI 
from product.product;

--Herbir kategorideki en ucuz bisikletin fiyat�
SELECT	DISTINCT category_id, MIN(list_price) OVER (PARTITION BY category_id)
FROM	product.product

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

--ma�azalar�n 2018 y�l�na ait haftal�k k�m�latif sipari� say�lar�

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