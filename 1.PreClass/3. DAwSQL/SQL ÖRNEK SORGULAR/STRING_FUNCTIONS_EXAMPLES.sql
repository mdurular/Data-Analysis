--------------STRING FUNCTIONS
select MAX(LEN(product_name)) 
from product.product					>>> 53	

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

SELECT * FROM string_split('cat,bat,hat', ',')   >>>
cat
bat
hat

-- How many yahoo mails in customer’s email column?

SELECT SUM(CASE WHEN PATINDEX('%yahoo%',email)> 0 THEN 1 ELSE 0 END) num_of_domain
FROM sale.customer

SELECT COUNT(*) FROM sale.customer WHERE email like '%yahoo.com'

SELECT SUM(CASE WHEN PATINDEX('%yahoo%',email)> 0 THEN 1 ELSE 0 END) num_of_domain
FROM sale.customer

select email, PATINDEX('%yahoo%',email) FROM sale.customer

-- return the characters before the '.' character in the email column.

SELECT email,  LEFT(email,CHARINDEX('.',email)-1) FROM sale.customer

---Add a new column to the customers table that contains the customers' contact information. 
--If the phone is available, the phone information will be printed, if not, the email information will be printed.

SELECT *, COALESCE(phone,email) contact FROM sale.customer

---Write a query that returns streets. 
--The third character of the streets is numerical.

SELECT street, SUBSTRING(street,3,1) FROM sale.customer
WHERE SUBSTRING(street,3,1) LIKE '[0-9]'

SELECT street, SUBSTRING(street,3,1) FROM sale.customer
WHERE SUBSTRING(street,3,1) NOT LIKE '[^0-9]'

SELECT street, SUBSTRING(street,3,1) FROM sale.customer
WHERE ISNUMERIC(SUBSTRING(street,3,1)) = 1

--Split the values in the mail column into two parts with '@'

SELECT email, SUBSTRING(email,1,CHARINDEX('@',email)-1) as leftPart,
RIGHT(email,LEN(email)-CHARINDEX('@',email)) as rightPart
FROM sale.customer

SELECT email, SUBSTRING(email,1,CHARINDEX('@',email)-1) as leftPart,
SUBSTRING(email,CHARINDEX('@',email)+1,LEN(email)) as rightPart
FROM sale.customer


SELECT UPPER(LEFT('character',1)) + LOWER(SUBSTRING('character',2,LEN('character')))
SELECT UPPER(LEFT('character',1))
SELECT LEFT('character',1)
select 'a' + 'b'
SELECT LOWER(SUBSTRING('character',2,LEN('character')))
SELECT SUBSTRING('character',2,LEN('character'))
SELECT LEN('character')
