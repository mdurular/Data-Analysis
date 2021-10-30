




WITH T1 AS
(
SELECT *
FROM  (VALUES
		(1,'A', 'Left'),
		(2,'A', 'Order'),
		(3,'B', 'Left'),
		(4,'A', 'Order'),
		(5,'A', 'Review'),
		(6,'A', 'Left'),
		(7,'B', 'Left'),
		(8,'B', 'Order'),
		(9,'B', 'Review'),
		(10,'A', 'Review')
		) A (visitor_id, adv_type, [action])
)
SELECT *,
		CASE WHEN [action] = 'Order' THEN 1 ELSE 0 END AS cnt_order
FROM T1





WITH T1 AS
(
SELECT *
FROM  (VALUES
		(1,'A', 'Left'),
		(2,'A', 'Order'),
		(3,'B', 'Left'),
		(4,'A', 'Order'),
		(5,'A', 'Review'),
		(6,'A', 'Left'),
		(7,'B', 'Left'),
		(8,'B', 'Order'),
		(9,'B', 'Review'),
		(10,'A', 'Review')
		) A (visitor_id, adv_type, [action])
), T2 AS
(
SELECT	adv_type, 
		COUNT (*) total_count,
		SUM (CASE WHEN [action] = 'Order' THEN 1 ELSE 0 END) AS cnt_order
FROM T1
GROUP BY adv_type
)
SELECT	adv_type, CONVERT(NUMERIC(3,2)  , 1.0 * cnt_order / total_count) conversion_rate
FROM	T2





-----------

--Ayný sipariþte Children Bicycle ve Comfort Bicycle categorisinde bisiklet sipariþ veren müþterileri getiriniz.



product.category
product.product
sale.order_item
sale.orders
sale.customer




SELECT	c.order_id,
		Sum(CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END) AS comfort_bike,
		SUM(CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END) AS children_bike
FROM	product.category A, product.product B, sale.order_item C
WHERE	category_name IN ('Children Bicycles' , 'Comfort Bicycles')
AND		A.category_id = B.category_id
AND		B.product_id = C.product_id
GROUP BY c.order_id
HAVING
		Sum(CASE WHEN A.category_name = 'Comfort Bicycles' THEN 1 ELSE 0 END) >= 1
AND		SUM(CASE WHEN A.category_name = 'Children Bicycles' THEN 1 ELSE 0 END) >= 1








