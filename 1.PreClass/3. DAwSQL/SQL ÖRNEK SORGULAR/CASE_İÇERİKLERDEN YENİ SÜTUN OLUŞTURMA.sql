--Order_Status isimli alandaki de�erlerin ne anlama geldi�ini i�eren yeni bir alan olu�turun.
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
SELECT  order_id, order_status,
		CASE order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			ELSE 'Completed'
		END AS mean_of_status
FROM	SALE.orders
ORDER BY order_status

---staff tablosuna �al��anlar�n ma�aza isimlerini ekleyiniz.
SELECT first_name, last_name, store_id,
	CASE store_id	
		WHEN 1 THEN 'Sacremento Bikes'
		WHEN 2 THEN 'Buffalo Bikes'
		ELSE 'San Angelo Bikes'
	END AS Store_name
FROM sale.staff

SELECT first_name, last_name,store_id,
		CASE
			WHEN store_id = 1 then 'Sacramento Bikes'
			WHEN store_id = 2 then 'Buffalo Bikes'
			WHEN store_id = 3 then 'San Angelo Bikes'
		END as Store_name
FROM sale.staff

--M��terilerin e-mail adreslerindeki servis sa�lay�c�lar�n� yeni bir s�tun olu�turarak belirtiniz.
SELECT	email,
		CASE	
			WHEN email LIKE '%@yahoo%' THEN 'Yahoo'
			WHEN email LIKE '%@gmail%' THEN 'Gmail'
			WHEN email LIKE '%@hotmail%' THEN 'Hotmail'
			WHEN email IS NOT NULL THEN 'Others'
		END Email_providers
FROM	sale.customer

--Orders tablosuna "TESL�M_DURUMU" (Not Shipped, Fast, Normal, Slow) ekleyin.

WITH T1 AS(SELECT *, DATEDIFF(DAY, order_date, shipped_date) AS TESL�M_S�RES�_G�N FROM sale.orders)

SELECT ORDER_DATE, shipped_date,
		CASE WHEN TESL�M_S�RES�_G�N IS NULL THEN 'Not Shipped'
			WHEN TESL�M_S�RES�_G�N = 0 THEN 'Fast'
			WHEN TESL�M_S�RES�_G�N <= 2 THEN 'Normal'
			WHEN TESL�M_S�RES�_G�N > 2 THEN 'Slow'
		END AS TESL�M_DURUMU
FROM	T1

---2 g�nden ge� teslim edilen sipari�lerin bilgileri.

SELECT *, DATEDIFF(DAY, order_date, shipped_date) AS TESL�M_S�RES�_G�N
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2

---Ge� teslim edilen sipari�lerin haftan�n g�nlerine g�re da��l�m�.

SELECT	SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Monday' THEN 1 END) MONDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Tuesday' THEN 1 END) Tuesday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Wednesday' THEN 1 END) Wednesday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Thursday' THEN 1 END) Thursday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Friday' THEN 1 END) Friday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Saturday' THEN 1 END) Saturday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Sunday' THEN 1 END) Sunday
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2