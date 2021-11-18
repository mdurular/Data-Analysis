




---  17-11-2021 DBMD Session 4 (SQL Programming)


CREATE PROCEDURE sp_sample1 
AS
BEGIN
	
	SELECT 'HELLO WORLD' col1

END


sp_sample1

EXEC sp_sample1

EXECUTE sp_sample1

-------------------------

ALTER PROCEDURE sp_sample1 
AS
BEGIN
	
	SELECT 'HELLO THERE' col1

END

sp_sample1


--------------------------------

TRUNCATE TABLE ORDER_TBL


CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);



INSERT ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 7, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 8, 'Johnson',GETDATE(), GETDATE()+5 )


SELECT * FROM ORDER_TBL



CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);



SET NOCOUNT ON
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )


SELECT * FROM ORDER_DELIVERY



--------


CREATE PROC sp_cnt_order AS
BEGIN
	SELECT  COUNT (ORDER_ID) TOTAL_ORDER FROM ORDER_TBL 
END


sp_cnt_order


----

CREATE PROC sp_cnt_order1 (@DATE DATE)
AS
BEGIN

DECLARE @CUST_ID

	SELECT  COUNT (ORDER_ID) TOTAL_ORDER 
	FROM ORDER_TBL 
	WHERE ORDER_DATE = @DATE

END


sp_cnt_order1 '2021-11-17' 



--------------------------------


DECLARE @P1 INT , @P2 INT, @SUM INT

SET @P1 = 3

SELECT @P2 = 7

SET @SUM = @P1 +@P2

SELECT @SUM AS TOTAL

--------------

SELECT @P1 = 3, @P2 = 7 , @SUM = @P1 +@P2

----------

DECLARE @P3 INT =5 , @P4 INT = 7


PRINT @P3 +@P4 
-----------------


DECLARE @CUSTOMER varchar(100)

set @CUSTOMER = 'Smith'

SELECT *
FROM ORDER_TBL
WHERE CUSTOMER_NAME = @CUSTOMER


----


---IF - ELSE


DECLARE @CUST INT

SET @CUST = 5

IF @CUST = 3
	BEGIN
		SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID = @CUST
	END
ELSE IF @CUST = 4
	BEGIN
		SELECT * FROM ORDER_TBL WHERE CUSTOMER_ID = @CUST
	END
ELSE
	PRINT('The number not equal to 3 or 4')



---WHILE

DECLARE @NUM INT = 1

WHILE @NUM < 50
	BEGIN
		SELECT @NUM

		SET @NUM += 1
	END



----------


--SCALAR VALUED FUNCTIONS

CREATE FUNCTION fn_uppertext1 
(
@inputtext VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN

	RETURN UPPER(@inputtext)

END



SELECT dbo.fn_uppertext1('welcome')


SELECT dbo.fn_uppertext1(CUSTOMER_NAME) FROM ORDER_TBL




CREATE FUNCTION fn_date_info (@DATE DATE)
RETURNS TABLE
AS
	RETURN SELECT * FROM ORDER_TBL WHERE ORDER_DATE = @DATE
;


SELECT * FROM fn_date_info('2021-11-17')


--------------------









