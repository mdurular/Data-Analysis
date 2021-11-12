--'Trek Remedy 9.8 - 2019' ürününün sipariþ verilmediði state/state'leri getiriniz.

SELECT *
FROM	SALE.orders

SELECT DISTINCT state
FROM sale.customer X
WHERE	NOT EXISTS
					(
					SELECT A.product_id, A.product_name, B.product_id, B.order_id, C.order_id, C.customer_id, D.*
					FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
					WHERE	A.product_id = B.product_id
					AND		B.order_id = C.order_id
					AND		C.customer_id = D.customer_id
					AND		A.product_name = 'Trek Remedy 9.8 - 2019'
					AND		X.state = D.state
					)