CREATE TABLE t_date_time 
	(
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

SELECT Getdate() as [now]
INSERT t_date_time 
VALUES (Getdate(), Getdate(), Getdate(), Getdate(), Getdate(), Getdate())
SELECT Getdate() as [now]