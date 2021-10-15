SELECT TOP 10 P.product_id, P.product_name, C.category_id, C.category_name
FROM product.product AS P 
INNER JOIN product.category AS C ON P.category_id = C.category_id


SELECT TOP 10 A.first_name, A.last_name, B.store_name
FROM sale.staff AS A join sale.store AS B ON A.store_id = B.store_id


SELECT A.product_id, A.product_name, B.order_id
FROM product.product A
LEFT JOIN sale.order_item B ON A.product_id = B.product_id 
WHERE B.order_id IS NULL


SELECT A.product_id, A.product_name, B.store_id, B.quantity
FROM product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id 
WHERE A.product_id>310

SELECT A.product_id, A.product_name, B.store_id, B.quantity
FROM product.product A
RIGHT JOIN product.stock B ON A.product_id = B.product_id 
WHERE A.product_id>310

SELECT B.staff_id, B.first_name,B.last_name,A.*
FROM sale.orders A
RIGHT JOIN sale.staff B ON A.staff_id =B.staff_id
ORDER BY order_id

SELECT TOP 20 B.product_id AS B_product_id, B.store_id, B.quantity, A.product_id AS A_product_id, A.order_id, A.list_price
FROM sale.order_item A
FULL OUTER JOIN product.stock B ON A.product_id = B.product_id 
ORDER BY  B.product_id, A.product_id
