




---------- 28.10.2021 DAwSQL Session-6 (Date & String Functions)


--DATEDIFF

SELECT	A_time, A_date, GETDATE(),
		DATEDIFF(MINUTE, A_time, GETDATE()) AS MINUTE_DIFF,
		DATEDIFF(WEEK, A_date, '2021-11-30') AS WEEK_DIFF
FROM t_date_time


---


SELECT	ABS(DATEDIFF(DAY, shipped_date, order_date)) DATE_DIFF, order_date, shipped_date
FROM	sale.orders



SELECT	DATEDIFF(DAY, order_date, shipped_date) DATE_DIFF, order_date, shipped_date
FROM	sale.orders



----DATEADD


SELECT	ORDER_DATE, 
		DATEADD(YEAR , 5 , order_date) YEAR_ADD,
		DATEADD(DAY, 10 , order_date) DAY_ADD,
FROM	sale.orders



SELECT GETDATE(), DATEADD(HOUR, 5, GETDATE())



---------------

--EOMONTH


SELECT EOMONTH(GETDATE()), EOMONTH(GETDATE(), 2)


---------


SELECT ISDATE('2021-10-01')


SELECT ISDATE('SELECT')


-------


--Orders tablosuna sipariþlerin teslimat hýzýyla ilgili bir alan ekleyin.
--Bu alanda eðer teslimat gerçekleþmemiþse 'Not Shipped',
--Eðer sipariþ günü teslim edilmiþse 'Fast',
--Eðer sipariþten sonraki iki gün içinde teslim edilmiþse 'Normal'
--2 günden geç teslim edilenler ise 'Slow'
--olarak her bir sipariþi etiketleyin.



WITH T1 AS
(
SELECT *, 
		DATEDIFF(DAY, order_date, shipped_date) DIFF_SHIPPED_AND_ORDER
FROM	sale.orders
)
SELECT ORDER_DATE,
		shipped_date,
		CASE WHEN DIFF_SHIPPED_AND_ORDER IS NULL THEN 'Not Shipped'
			 WHEN DIFF_SHIPPED_AND_ORDER = 0 THEN 'Fast'
			 WHEN DIFF_SHIPPED_AND_ORDER <= 2 THEN 'Normal'
			 WHEN DIFF_SHIPPED_AND_ORDER > 2 THEN 'Slow'
		END AS Order_Label 
FROM	T1




--2 günden geç teslim edilen sipariþlerin bilgilerini getiriniz.

SELECT *, 
		DATEDIFF(DAY, order_date, shipped_date) DIFF_SHIPPED_AND_ORDER
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2



--Yukarýdaki sipariþlerin haftanýn günlerine göre daðýlýmýný hesaplayýnýz.


SELECT	CASE WHEN DATENAME(WEEKDAY, order_date) = 'Monday' THEN 1 ELSE 0 END MONDAY
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2



SELECT	COUNT (CASE WHEN DATENAME(WEEKDAY, order_date) = 'Monday' THEN 1 ELSE 0 END) CNT
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2



SELECT	SUM (CASE WHEN DATENAME(WEEKDAY, order_date) = 'Monday' THEN 1 ELSE 0 END) CNT
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2



SELECT	SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Monday' THEN 1 END) MONDAY,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Tuesday' THEN 1 END) Tuesday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Wednesday' THEN 1 END) Wednesday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Thursday' THEN 1 END) Thursday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Friday' THEN 1 END) Friday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Saturday' THEN 1 END) Saturday,
		SUM(CASE WHEN DATENAME(WEEKDAY, order_date) = 'Sunday' THEN 1 END) Sunday
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2




----/////////////////////////////-------------

----/////////////////////////////-------------

----/////////////////////////////-------------

----/////////////////////////////-------------


--------------String Functions


--LEN

SELECT LEN(1231354658)

SELECT LEN ('WELCOME')


----



--CHARINDEX

SELECT CHARINDEX('C', 'CHARACTER')

SELECT CHARINDEX('C', 'CHARACTER', 2)



SELECT CHARINDEX('CT%', 'CHARACT%ER')



--PATINDEX



SELECT PATINDEX('R' , 'CHARACTER')


SELECT PATINDEX('R%' , 'CHARACTER')



SELECT PATINDEX('%R%' , 'CHARACTER')


SELECT PATINDEX('%R' , 'CHARACTER')


SELECT PATINDEX('___R%' , 'CHARACTER')


SELECT PATINDEX('%E%' , 'CHARACTER')



SELECT PATINDEX('%E_' , 'CHARACTER')



---LEFT

SELECT LEFT ('CHARACTER', 3)

SELECT LEFT (' CHARACTER', 3)



---RIGHT

SELECT RIGHT ('CHARACTER' , 1 )


SELECT RIGHT ('CHARACTER ' , 3 )




---SUBSTRING

SELECT SUBSTRING('CHARACTER', 1, 3)


SELECT SUBSTRING('CHARACTER', -1, 3)


SELECT SUBSTRING('CHARACTER', 0, 1)


---LOWER

SELECT LOWER('CHARACTER')


---UPPER

SELECT UPPER('character')

select 'Character'


---



SELECT UPPER(LEFT('character',1)) + LOWER(SUBSTRING('character',2,LEN('character')))



SELECT UPPER(LEFT('character',1))


SELECT LEFT('character',1)


select 'a' + 'b'



SELECT LOWER(SUBSTRING('character',2,LEN('character')))



SELECT SUBSTRING('character',2,LEN('character'))


SELECT LEN('character')





-------------


--STRING_SPLIT

SELECT value FROM string_split('ALÝ,MEHMET,AYÞE' , ',')


------

--TRIM, LTRIM, RTRIM

SELECT TRIM(' CHARA CTER ')

SELECT TRIM('     CHARA CTER ')


SELECT TRIM(' %&' FROM 'CHARACTER %&')


SELECT LTRIM('     CHARA CTER ')


SELECT RTRIM('     CHARA CTER ')














