


-------------- 14.10.2021 Combine Your Tables ----------------



use SampleSales

----------------////////////////////------------


------ INNER JOIN ------

-- List products with category names
-- Select product ID, product name, category ID and category names


SELECT	A.product_name, B.category_id
FROM	product.product AS A
INNER JOIN	product.category AS B ON A.category_id = B.category_id




--///////


--List employees of stores with their store information
--Select employee name, surname, store names


SELECT		A.first_name, A.last_name, B.store_name
FROM		sale.staff A
INNER JOIN	sale.store B ON A.store_id = B.store_id



------ LEFT JOIN ------

-- Write a query that returns products that have never been ordered
--Select product ID, product name, orderID
--(Use Left Join)


SELECT		A.product_id, A.product_name, B.order_id
FROM		product.product A LEFT JOIN	sale.order_item B ON A.product_id = B.product_id
WHERE		B.order_id IS NULL


------////////

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity



SELECT		A.product_id, A.product_name, B.store_id, B.quantity
FROM		product.product A LEFT JOIN product.stock B  ON A.product_id = B.product_id
WHERE		A.product_id > 310
ORDER BY	store_id



------ RIGHT JOIN ------

--Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores.



SELECT		A.product_id, B.product_name, A.store_id, A.quantity
FROM		product.stock A RIGHT JOIN product.product B  ON A.product_id = B.product_id
WHERE		B.product_id > 310
ORDER BY	store_id





--//////

---Report the orders information made by all staffs.
--Expected columns: Staff_id, first_name, last_name, all the information about orders



SELECT *
FROM	SALE.staff



SELECT COUNT (staff_id)
FROM	SALE.staff



SELECT COUNT (DISTINCT A.staff_id)
FROM	sale.staff A INNER JOIN sale.orders B ON A.staff_id = B.staff_id



SELECT	A.staff_id, A.first_name, A.last_name, B.order_id
FROM	sale.staff A LEFT JOIN sale.orders B ON A.staff_id = B.staff_id


------ FULL OUTER JOIN ------

--Write a query that returns stock and order information together for all products . (TOP 20)
--Expected columns: Product_id, store_id, quantity, order_id, list_price



SELECT	top 20*
FROM	SALE.order_item A FULL OUTER JOIN product.stock B ON A.product_id = B.product_id
ORDER BY	B.product_id, A.order_id


















