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