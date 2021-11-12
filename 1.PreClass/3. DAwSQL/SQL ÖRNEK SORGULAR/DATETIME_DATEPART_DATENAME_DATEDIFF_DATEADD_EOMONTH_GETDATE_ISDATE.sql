---FUNCTIONS FOR RETURN DATE OR TIME PARTS
SELECT	A_date,
		DATENAME(WEEKDAY, A_date) [DAYNAME],
		DAY (A_date) [DAYNO],
		MONTH(A_date) [month],
		YEAR (A_date) [year],
		DATEPART(WEEK , A_DATE) WEEKNO,
		A_Time,
		DATEPART (NANOSECOND, A_time)
FROM	t_date_time

---DATEDIFF
SELECT	A_time, A_date, GETDATE(),
		DATEDIFF(MINUTE, A_time, GETDATE()) AS MINUTE_DIFF,
		DATEDIFF(WEEK, A_date, '2021-11-30') AS WEEK_DIFF
FROM t_date_time
---
SELECT	ABS(DATEDIFF(DAY, shipped_date, order_date)) DATE_DIFF, order_date, shipped_date
FROM	sale.orders

SELECT	DATEDIFF(DAY, order_date, shipped_date) DATE_DIFF, order_date, shipped_date
FROM	sale.orders

---DATEADD
SELECT	ORDER_DATE, 
		DATEADD(YEAR , 5 , order_date) YEAR_ADD,
		DATEADD(DAY, 10 , order_date) DAY_ADD,
FROM	sale.orders

SELECT GETDATE(), DATEADD(HOUR, 5, GETDATE())

---EOMONTH
SELECT EOMONTH(GETDATE()), EOMONTH(GETDATE(), 2)
SELECT ISDATE('2021-10-01')
SELECT ISDATE('SELECT')
