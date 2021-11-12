--------------STRING FUNCTIONS
select email,
SUBSTRING(email,CHARINDEX('@',email)+1,LEN(email)-CHARINDEX('@',email))as emailDomain
from sale.customer 

email						emailDomain
emily.brooks@yahoo.com		yahoo.com
katie.toodei@yahoo.com		yahoo.com

select top 1 email from sale.customer			>>>  'emily.brooks@yahoo.com'

select email, TRIM('.com' FROM email) as nodotcom
from sale.customer

--'character' >>> Character   (sadece ilk harfini büyük yap)
SELECT UPPER(LEFT('character',1)) + RIGHT('character', LEN('character')-1)
	
--STRING_SPLIT

SELECT * FROM string_split('cat,bat,hat',',')   >>>
cat
bat
hat

--LEN
SELECT LEN(1231354658)
SELECT LEN ('WELCOME')
select MAX(LEN(product_name)) from product.product		
--CHARINDEX
SELECT CHARINDEX('RA','CHARACTER')		>>> 4  (sýfýrdan deðil 1'den baþalar, ilk bulduðunu verir)
SELECT CHARINDEX('C', 'CHARACTER', 2)	>>> 6  (ikinci karakterden baþlayarak ilk C'nin indeksini verir)
SELECT CHARINDEX('C', 'CHARACTER', 1)	>>> 1  (birinci C'nin indeksini verir)
SELECT CHARINDEX('C', 'CHARACTERC',3)	>>> 6  (üçüncü karakterden baþlayarak ilk C'nin indeksini verir)
SELECT CHARINDEX('@','sheetal.instructor@gmail.com')	>>> 19
--PATINDEX
SELECT PATINDEX('R' , 'CHARACTER')    0
SELECT PATINDEX('R%' , 'CHARACTER')
SELECT PATINDEX('%R%' , 'CHARACTER')
SELECT PATINDEX('%R' , 'CHARACTER')
SELECT PATINDEX('___R%' , 'CHARACTER')
SELECT PATINDEX('%E%' , 'CHARACTER')
SELECT PATINDEX('%E_' , 'CHARACTER')
---LEFT
SELECT LEFT ('CHARACTER', 3)   CHA
SELECT LEFT (' CHARACTER', 3)
---RIGHT
SELECT RIGHT ('CHARACTER' , 1 )
SELECT RIGHT ('CHARACTER ' , 3 )
---SUBSTRING
SELECT SUBSTRING('CHARACTER', 1, 3)
SELECT SUBSTRING('CHARACTER', -1, 3)   C
SELECT SUBSTRING('CHARACTER', 0, 1)
---LOWER
SELECT LOWER('CHARACTER')
---UPPER
SELECT UPPER('character')
select 'Character'
SELECT UPPER(LEFT('character',1)) + LOWER(SUBSTRING('character',2,LEN('character')))
SELECT UPPER(LEFT('character',1))
SELECT LEFT('character',1)
select 'a' + 'b'
SELECT LOWER(SUBSTRING('character',2,LEN('character')))
SELECT SUBSTRING('character',2,LEN('character'))
SELECT LEN('character')
--STRING_SPLIT
SELECT value FROM string_split('ALÝ,MEHMET,AYÞE' , ',')
--TRIM, LTRIM, RTRIM
SELECT TRIM(' CHARA CTER ')
SELECT TRIM('     CHARA CTER ')           (ortadaki boþluðu almaz)
SELECT TRIM(' %&' FROM 'CHARACTER %&')
SELECT LTRIM('     CHARA CTER ')
SELECT RTRIM('CHARACTER     ')
--REPLACE
SELECT REPLACE('CHARACTER STRING', ' ','/')
select REPLACE('CHARACTER STRING','CHARACTER STRING','OCTOBER')
--STR
SELECT STR(12345)
SELECT STR(2345266976907)
SELECT STR(5454,5)
SELECT '$' + STR(5454,10,2)
SELECT STR(133215.456456, 6)
SELECT STR(133215.456456, 10,3)
--CAST, CONVERT
SELECT CAST(12345 AS CHAR)
SELECT SUBSTRING(CAST(12345 AS CHAR),1,3)
SELECT CAST(123.45 AS INT)
SELECT CONVERT (int, 30.67)
SELECT CONVERT(VARCHAR(10),'2021-10-28')
SELECT CONVERT (DATETIME, '2021-10-28')
SELECT CONVERT (CHAR(15), GETDATE(),103)
SELECT GETDATE()
--COALESCE
SELECT COALESCE(NULL, NULL,'Hi','Hello', NULL) result;
SELECT COALESCE (NULL,NULL,NULL,1);
--NULLIF
SELECT NULLIF(1,1)
SELECT NULLIF(1,0)
--ROUND
SELECT ROUND(432.345, 2)
SELECT ROUND(432.345, 2, 0)
SELECT ROUND(432.345, 2, 1)
SELECT ROUND(432.345, 3, 0)
SELECT ROUND(432.34545, 2, 1)


