--Order_Status isimli alandaki deðerlerin ne anlama geldiðini içeren yeni bir alan oluþturun.
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

---staff tablosuna çalýþanlarýn maðaza isimlerini ekleyiniz.
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

--Müþterilerin e-mail adreslerindeki servis saðlayýcýlarýný yeni bir sütun oluþturarak belirtiniz.
SELECT	email,
		CASE	
			WHEN email LIKE '%@yahoo%' THEN 'Yahoo'
			WHEN email LIKE '%@gmail%' THEN 'Gmail'
			WHEN email LIKE '%@hotmail%' THEN 'Hotmail'
			WHEN email IS NOT NULL THEN 'Others'
		END Email_providers
FROM	sale.customer

--Orders tablosuna "TESLÝM_DURUMU" (Not Shipped, Fast, Normal, Slow) ekleyin.

WITH T1 AS(SELECT *, DATEDIFF(DAY, order_date, shipped_date) AS TESLÝM_SÜRESÝ_GÜN FROM sale.orders)

SELECT ORDER_DATE, shipped_date,
		CASE WHEN TESLÝM_SÜRESÝ_GÜN IS NULL THEN 'Not Shipped'
			WHEN TESLÝM_SÜRESÝ_GÜN = 0 THEN 'Fast'
			WHEN TESLÝM_SÜRESÝ_GÜN <= 2 THEN 'Normal'
			WHEN TESLÝM_SÜRESÝ_GÜN > 2 THEN 'Slow'
		END AS TESLÝM_DURUMU
FROM	T1

---2 günden geç teslim edilen sipariþlerin bilgileri.

SELECT *, DATEDIFF(DAY, order_date, shipped_date) AS TESLÝM_SÜRESÝ_GÜN
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2

---Geç teslim edilen sipariþlerin haftanýn günlerine göre daðýlýmý.

SELECT	SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Monday' THEN 1 END) MONDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Tuesday' THEN 1 END) Tuesday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Wednesday' THEN 1 END) Wednesday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Thursday' THEN 1 END) Thursday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Friday' THEN 1 END) Friday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Saturday' THEN 1 END) Saturday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Sunday' THEN 1 END) Sunday
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2