------ INNER JOIN ------

SELECT		A.product_name, B.category_id, B.category_name
FROM		product.product AS A
INNER JOIN	product.category AS B ON A.category_id = B.category_id

SELECT		A.first_name, A.last_name, B.store_name
FROM		sale.staff A
INNER JOIN	sale.store B ON A.store_id = B.store_id

SELECT A.product_id, A.product_name
FROM product.product A
INNER JOIN (
			SELECT	A.product_id
			FROM	sale.order_item A, sale.orders B
			WHERE	A.order_id = B.order_id
			AND		B.order_date BETWEEN '2019-01-01' AND '2019-12-31'
			) B
ON	A.product_id = B.product_id

-- JOIN YAPMADAN ÇÖZÜMÜ:
SELECT	COUNT (DISTINCT A.product_id)
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		B.order_date LIKE '2019%'

------ LEFT JOIN ------
-- Maðaza çalýþanlarýný yaptýklarý satýþlar ile birlikte listeleyin

SELECT		A.staff_id, A.first_name, B.order_id, B.staff_id 
FROM		sale.staff A 
LEFT JOIN	SALE.orders B ON A.staff_id = B.staff_id
ORDER BY	B.order_id 

-- Write a query that returns products that have never been ordered

SELECT		A.product_id, A.product_name, B.order_id
FROM		product.product A LEFT JOIN	sale.order_item B ON A.product_id = B.product_id
WHERE		B.order_id IS NULL

--Report the stock status of the products that product id greater than 310 in the stores.

SELECT		A.product_id, A.product_name, B.store_id, B.quantity
FROM		product.product A 
LEFT JOIN	product.stock B  ON A.product_id = B.product_id
WHERE		A.product_id > 310
ORDER BY	store_id

------ RIGHT JOIN ------

SELECT		A.product_id, B.product_name, A.store_id, A.quantity
FROM		product.stock A 
RIGHT JOIN	product.product B  ON A.product_id = B.product_id
WHERE		B.product_id > 310
ORDER BY	store_id

---Report the orders information made by all staffs.

SELECT COUNT (DISTINCT A.staff_id)
FROM	sale.staff A INNER JOIN sale.orders B ON A.staff_id = B.staff_id

SELECT	A.staff_id, A.first_name, A.last_name, B.order_id
FROM	sale.staff A LEFT JOIN sale.orders B ON A.staff_id = B.staff_id

------ FULL OUTER JOIN ------
--Write a query that returns stock and order information together for all products . (TOP 20)

SELECT	top 20*
FROM	SALE.order_item A FULL OUTER JOIN product.stock B ON A.product_id = B.product_id
ORDER BY	B.product_id, A.order_id

-- SELF JOIN
-- Write a query that returns the staff with their managers.

SELECT * 
FROM sale.staff AS A
JOIN sale.staff AS B
ON A.manager_id = B.staff_id

-- CROSS JOIN  (THERE IS NO "ON" WITH CROSS JOIN)
-- Write a query that returns all brand x category possibilities.

SELECT A.brand_id, A.brand_name, B.category_id, B.category_name
FROM product.brand AS A
CROSS JOIN product.category AS B

-- Write a query that returns the table to be used to add products that are in the Product table but not in the stock table to the stocks table with quantity = 0. 
-- (Do not forget to add products to all stores.)
-- some of products are not in the stocks table, 
-- Number of items not on stock list but on product list
-- To understand question, let's check
SELECT * FROM product.stock
SELECT * FROM product.product

SELECT * FROM product.product AS A
WHERE A.product_id NOT IN (SELECT product_id FROM product.stock);

-- We find which product_id in stores but not in stocks

SELECT B.store_id, A.product_id, A.product_name, 0 quantity
FROM product.product AS A
CROSS JOIN sale.store AS B
WHERE A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id

