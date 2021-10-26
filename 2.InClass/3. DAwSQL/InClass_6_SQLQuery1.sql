--- DATE FUNCTIONS
CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

SELECT GETDATE() as [now]

SELECT CURRENT_TIMESTAMP as [now]


insert t_date_time
VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

select* from t_date_time

SELECT CONVERT (VARCHAR, Getdate(),6)

SELECT CONVERT (DATE, '25 Oct 21')

SELECT DATENAME(DAY, getdate())
SELECT DATEPART(DAY, getdate())


SELECT	A_date,
		DATENAME(WEEKDAY, A_date) [weekDAY],
		DAY (A_date) [DAY2],
		MONTH(A_date) [month],
		YEAR (A_date) [year],
		A_time,
		DATEPART (NANOSECOND, A_time) [ nano],
		DATEPART (MONTH, A_date) [month]
FROM	t_date_time


	
		