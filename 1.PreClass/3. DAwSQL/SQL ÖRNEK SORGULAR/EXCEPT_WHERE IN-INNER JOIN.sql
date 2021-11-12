--EXCEPT
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
