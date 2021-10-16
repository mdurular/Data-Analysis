SELECT product_id, COUNT(product_id) AS nums_of_rows
FROM product.product A
GROUP BY product_id
ORDER BY nums_of_rows



SELECT product_id, COUNT(product_id)
FROM product.product
GROUP BY product_id
HAVING COUNT(product_id) > 1


SELECT A.category_id, MAX(A.list_price) AS max_price, MIN(A.list_price) AS min_price 
FROM product.product A
GROUP BY A.category_id
HAVING MAX(A.list_price)>4000 OR MIN(A.list_price)<500


SELECT A.brand_name, AVG(B.list_price) AS avg_list_price
FROM product.brand A 
INNER JOIN product.product B ON A.brand_id = B.brand_id
GROUP BY A.brand_name
ORDER BY avg_list_price DESC

--ortalama ürün fiyatý 1000' den yüksek olan MARKALARI getiriniz
SELECT A.brand_name, AVG(B.list_price) AS avg_list_price
FROM product.brand A 
INNER JOIN product.product B ON A.brand_id = B.brand_id
GROUP BY A.brand_name
HAVING AVG(B.list_price) > 1000
ORDER BY avg_list_price 



SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary
FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year



SELECT Brand, SUM(total_sales_price) AS total_price
FROM sale.sales_summary
GROUP BY Brand


SELECT Category, SUM(total_sales_price) AS total_category
FROM sale.sales_summary
GROUP BY Category

SELECT Brand, Category, SUM(total_sales_price) AS total_sales
FROM sale.sales_summary
GROUP BY Brand, Category 
ORDER BY brand



SELECT Brand, Category, SUM(total_sales_price) AS total_sales
FROM sale.sales_summary
GROUP BY 
		GROUPING SETS(
		(Brand),
		(Category),
		(Brand, Category),
		()) 
ORDER BY brand, category



