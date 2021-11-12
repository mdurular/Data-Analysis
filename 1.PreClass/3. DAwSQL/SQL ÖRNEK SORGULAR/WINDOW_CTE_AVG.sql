--Ortalama �r�n fiyat�n�n ortalama net tutardan y�ksek oldu�u sipari�ler

WITH T1 AS 
(
SELECT	distinct order_id, 
		AVG(list_price) OVER (PARTITION BY order_id) AVG_LIST_PRICE,
		AVG(list_price*quantity*(1-discount)) OVER () AVG_NET_PRICE
FROM	SALE.order_item
) 
SELECT *
FROM	T1
WHERE	AVG_LIST_PRICE > AVG_NET_PRICE
ORDER BY 1

--'2018-03-12' ve '2018-04-12' aras�nda sat�lan �r�n say�s�n�n 7 g�nl�k hareketli ortalamas�n� hesaplay�n.


WITH T1 AS 
(
SELECT	DISTINCT order_date, SUM(quantity) OVER (PARTITION BY order_date) sum_quantity
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
AND		B.order_date BETWEEN '2018-03-12' AND '2018-04-12'
)
SELECT	order_date,  sum_quantity,
		AVG(sum_quantity) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) sales_moving_average_7
FROM	T1

--M��terilerin sipari� ettikleri �r�n say�lar�n�n k�m�latif da��l�m�

WITH T1 AS
(SELECT	A.customer_id, SUM(quantity) AS Quantity
FROM	SALE.orders A, SALE.order_item B
WHERE	 A.order_id = B.order_id
GROUP BY A.customer_id) 

SELECT DISTINCT customer_id, Quantity, ROUND(CUME_DIST() OVER (ORDER BY Quantity), 2) AS CUM_DIST
FROM T1
ORDER BY 1

--M��terilerin sipari� ettikleri �r�n say�lar�n�n g�receli pozisyonu

WITH T1 AS
(SELECT	A.customer_id, SUM(quantity) AS Quantity
FROM	SALE.orders A, SALE.order_item B
WHERE	 A.order_id = B.order_id
GROUP BY A.customer_id) 

SELECT DISTINCT customer_id, Quantity, ROUND(PERCENT_RANK() OVER (ORDER BY Quantity), 2) AS PERC_RANK
FROM T1 ORDER BY 1

--M��terilerin sipari� ettikleri �r�n say�lar�n�n e�it gruplar halinde da��l�m�
WITH T1 AS
(SELECT	A.customer_id, SUM(quantity) AS Quantity
FROM	SALE.orders A, SALE.order_item B
WHERE	 A.order_id = B.order_id
GROUP BY A.customer_id) 

SELECT customer_id, Quantity, NTILE(5) OVER (ORDER BY Quantity DESC) group_dist
FROM T1 ORDER BY 1
