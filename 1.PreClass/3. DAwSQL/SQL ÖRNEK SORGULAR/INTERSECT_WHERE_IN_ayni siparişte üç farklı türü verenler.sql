-- Ayný sipariþte hem Electric Bikes, hem Comfort Bicycles hem de Children Bicycles ürünlerini sipariþ veren müþterileri bulunuz.
SELECT	A.first_name, A.last_name
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id AND
		B.order_id IN	(
					SELECT	A.order_id
					FROM	sale.order_item A, product.product B
					WHERE	A.product_id = B.product_id AND
							B.category_id = (SELECT	category_id
										FROM	product.category
										WHERE	category_name = 'Electric Bikes')
						INTERSECT
						SELECT	A.order_id
						FROM	sale.order_item A, product.product B
						WHERE	A.product_id = B.product_id AND
								B.category_id = (SELECT	category_id
											FROM	product.category
										WHERE	category_name = 'Comfort Bicycles')
						INTERSECT
						SELECT	A.order_id
						FROM	sale.order_item A, product.product B
						WHERE	A.product_id = B.product_id AND
								B.category_id = (SELECT	category_id
										FROM	product.category
										WHERE	category_name = 'Children Bicycles')
						)