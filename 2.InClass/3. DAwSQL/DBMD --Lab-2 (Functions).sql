






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


INSERT ORDER_DELIVERY VALUES (9, NULL )

SELECT * FROM ORDER_TBL

SELECT * FROM  ORDER_DELIVERY



--Sipariþleri, tahmini teslim tarihleri ve gerçekleþen teslim tarihlerini kýyaslayarak
--'Late','Early' veya 'On Time' olarak sýnýflandýrmak istiyorum.
--Eðer sipariþin ORDER_TBL tablosundaki EST_DELIVERY_DATE' i (tahmini teslim tarihi) 
--ORDER_DELIVERY tablosundaki DELIVERY_DATE' ten (gerçekleþen teslimat tarihi) küçükse
--Bu sipariþi 'LATE' olarak etiketlemek,
--Eðer EST_DELIVERY_DATE>DELIVERY_DATE ise Bu sipariþi 'EARLY' olarak etiketlemek,
--Eðer iki tarih birbirine eþitse de bu sipariþi 'ON TIME' olarak etiketlemek istiyorum.



--order_id
--etiket/statü
--tahmini teslim tarihi ile gerçekleþen teslim tarihi arasýndaki iliþki


CREATE FUNCTION dbo.fn_statuoforders (@order_id INT)

RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @ORDER_STATUS VARCHAR(10)
	DECLARE @EST_DEL_DATE DATE
	DECLARE @DEL_DATE DATE

	
	SELECT	@EST_DEL_DATE = EST_DELIVERY_DATE
	FROM	ORDER_TBL
	WHERE	ORDER_ID = @order_id


	SELECT	@DEL_DATE = DELIVERY_DATE
	FROM	ORDER_DELIVERY
	WHERE	ORDER_ID = @order_id


	IF @EST_DEL_DATE < @DEL_DATE
		BEGIN
			SET @ORDER_STATUS = 'LATE'
		END
	ELSE IF @EST_DEL_DATE > @DEL_DATE
		BEGIN
			SET @ORDER_STATUS = 'EARLY'
		END
	ELSE
		BEGIN
			SET @ORDER_STATUS = 'ON TIME'
		END

	RETURN @ORDER_STATUS
END

---------------------

SELECT *, dbo.fn_statuoforders(ORDER_ID) FROM ORDER_DELIVERY


SELECT * FROM ORDER_TBL WHERE dbo.fn_statuoforders(ORDER_ID) = 'ON TIME'




CREATE TABLE ON_TIME_TABLE
(
ORDER_ID INT,
ORDER_STATUS VARCHAR(10) ,
CONSTRAINT check_status CHECK (dbo.fn_statuoforders(ORDER_ID) = 'ON TIME')
)


SELECT * FROM ON_TIME_TABLE


SELECT * FROM ORDER_TBL

INSERT ON_TIME_TABLE VALUES (6, 'ON TIME')




---TABLE VALUED FUNCTION


--Zamanýnda teslim edilen sipariþlerin order_tbl tablosundaki bilgilerini döndüren bir fonksiyon yazýnýz.

CREATE FUNCTION dbo.fn_on_time_orders (	@ORDER_ID INT )
RETURNS @table1 TABLE
(
ORDER_ID TINYINT,
CUSTOMER_ID TINYINT ,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE
)
AS
	BEGIN
		IF EXISTS (SELECT 1 FROM ON_TIME_TABLE WHERE ORDER_ID = @ORDER_ID)
			BEGIN
				INSERT @table1
				SELECT * FROM ORDER_TBL WHERE ORDER_ID = @ORDER_ID
			END
	RETURN
END



SELECT * FROM ON_TIME_TABLE

SELECT * FROM dbo.fn_on_time_orders(2)







