---------DATEDIFF
SELECT	A_time, A_date, GETDATE(),
		DATEDIFF(MINUTE, A_time, GETDATE()) AS MINUTE_DIFF,
		DATEDIFF(WEEK, A_date, '2021-11-30') AS WEEK_DIFF
FROM t_date_time



SELECT DATEDIFF ( day, order_date, shipped_date) DATE_DIFF, order_date, Shipped_date
FROM sale.orders

-------- DATEADD
SELECT Order_date,
		DATEADD(YEAR,-5,Order_date),
		DATEADD(DAY,10,Order_date)
FROM sale.orders

SELECT GETDATE(), DATEADD(HOUR,5,GETDATE())

--EOMONTH
SELECT EOMONTH(GETDATE()), EOMONTH(GETDATE(), 2)

----ISDATE
SELECT ISDATE ('2021-10-01')

SELECT ISDATE ('SELECT')

--Orders tablosuna sipariþlerin teslimat hýzýyla ilgili bir alan ekleyin.
--Bu alanda eðer teslimat gerçekleþmemiþse 'Not Shipped',
--Eðer sipariþ günü teslim edilmiþse 'Fast',
--Eðer sipariþten sonraki iki gün içinde teslim edilmiþse 'Normal'
--2 günden geç teslim edilenler ise 'Slow'
--olarak her bir sipariþi etiketleyin.

select  order_id,  DATEDIFF ( day, order_date, shipped_date) DATE_DIFF,
		CASE 
		WHEN shipped_date is null THEN 'Not Shipped'
		WHEN DATEDIFF ( day, order_date, shipped_date) = 0 THEN 'Fast'
		WHEN DATEDIFF ( day, order_date, shipped_date) <3 THEN 'Normal'
		WHEN DATEDIFF ( day, order_date, shipped_date) > 2 THEN 'Slow'
		END AS Labels
from sale.orders  


-------2 günden geç teslim edilen sipariþlerin bilgilerini getiriniz.

select *, DATEDIFF ( day, order_date, shipped_date) DATE_DIFF
from sale.orders  
WHERE DATEDIFF ( day, order_date, shipped_date) >2

-----
select  count(CASE
		WHEN datename(weekday, order_Date) = 'Monday' THEN 1
		END) AS MONDAY,
		 count(CASE
		WHEN datename(weekday, order_Date) = 'Tuesday' THEN 1
		END) AS Thuesday,
		 count(CASE
		WHEN datename(weekday, order_Date) = 'Wednesday' THEN 1
		END) AS Wednesday,
		 count(CASE
		WHEN datename(weekday, order_Date) = 'Thursday' THEN 1
		END) AS Thursday,
		 count(CASE
		WHEN datename(weekday, order_Date) = 'Friday' THEN 1
		END) AS Friday,
		 count(CASE
		WHEN datename(weekday, order_Date) = 'Saturday' THEN 1
		END) AS Saturday,
		 count(CASE
		WHEN datename(weekday, order_Date) = 'Sunday' THEN 1
		END) AS Sunday
from sale.orders  
WHERE DATEDIFF (day, order_date, shipped_date) >2


----- STRING FUNCTIONS
---LEN
SELECT LEN(1234567890)

SELECT LEN ('WELCOME')

---CHARINDEX

SELECT CHARINDEX('C' , 'CHARACTER')

SELECT CHARINDEX('C' , 'CHARACTER',2)


SELECT CHARINDEX('CT' , 'CHARACTER')

SELECT CHARINDEX('CT' , 'CHARACTER')

---PATINDEX

SELECT PATINDEX ('R%', 'CHARACTER')

SELECT PATINDEX ('%R%', 'CHARACTER')

SELECT PATINDEX ('%R', 'CHARACTER')

SELECT PATINDEX ('___R%', 'CHARACTER')

SELECT PATINDEX ('%E%', 'CHARACTER')

SELECT PATINDEX ('%E_', 'CHARACTER')

-- LEFT RIGHT SUBSTRING
SELECT LEFT ('CHARACTER',3)

SELECT RIGHT ('CHARACTER',3)

SELECT SUBSTRING ('CHARACTER', -2, 4)

SELECT SUBSTRING ('CHARACTER', 1, 1)

-- LOWER UPPER STRING_SPLIT

SELECT LOWER ('CHARACTER')

SELECT UPPER ('character',)

SELECT UPPER(LEFT('character',1))+LOWER(SUBSTRING('character',2,LEN('character')))

SELECT * FROM string_split ('ALÝ,MEHMET,AYÞE',',')

-----TRIM LTRIM  RTRIM

SELECT TRIM ('  CHARACTER   ')

SELECT TRIM(' %&' FROM 'CHARACTER %&')

SELECT LTRIM('  CHARACTER   ')

SELECT RTRIM('            CHARACTER   ')