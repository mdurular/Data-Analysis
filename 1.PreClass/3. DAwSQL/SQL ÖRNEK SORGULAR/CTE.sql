-- Sharyn Hopkins isimli müþterinin son sipariþinden önce sipariþ vermiþ 
--ve San Diego þehrinde ikamet eden müþterileri listeleyin.

WITH T1 AS
(
SELECT	max(order_date) last_purchase
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id
AND		A.first_name = 'Sharyn'
AND		A.last_name = 'Hopkins'
) 
SELECT	DISTINCT A.order_date, A.order_id, B.customer_id, B.first_name, B.last_name, B.city
FROM	sale.orders A, sale.customer B, T1
WHERE	A.customer_id = B.customer_id
AND		A.order_date < T1.last_purchase
AND		B.city = 'San Diego'

-- Abby	Parks isimli müþterinin alýþveriþ yaptýðý tarihte/tarihlerde alýþveriþ yapan tüm müþterileri listeleyin.
-- Müþteri adý, soyadý ve sipariþ tarihi bilgilerini listeleyin.

WITH T1 AS
(
SELECT	order_date
FROM	sale.customer A, sale.orders B
WHERE	A.customer_id = B.customer_id
AND		A.first_name = 'Abby'
AND		A.last_name = 'Parks'
)
SELECT	A.order_date, A.order_id, B.first_name, B.last_name
FROM	sale.orders A, sale.customer B, T1
WHERE	A.customer_id  = B.customer_id 
AND		A.order_date = T1.order_date