-- In the street column, clear the string characters that were accidentally added to the end of the initial numeric expression.

select t1.street, 
case when isnumeric(right(t1.subs, 1)) = 0 then substring(t1.subs, 1, len(t1.subs) - 1) else t1.subs end as [target],
case when isnumeric(right(t1.subs, 1)) = 0 then substring(t1.subs, 1, len(t1.subs) - 1) else t1.subs end
 + ' ' + substring(street, charindex(' ', street) + 1, len(street)) as new_street_name
from 
	(select street, substring(street, 1, charindex(' ', street) - 1) as subs
	from sale.customer) as t1
-- where isnumeric(right(t1.subs, 1)) = 0
---------------------

-- email adreslerini; isim-soyisim sýrasýný ve domain'lerini deðiþtirerek yeniden düzenleme:
-- yahoo to hotmail; gmail to yahoo; hotmail to gmail; ohererwise to clarusway

select email,
substring(substring(email, 1, charindex('@', email) - 1), 1, charindex('.', substring(email, 1, charindex('@', email) - 1)) - 1) as first,
substring(substring(email, 1, charindex('@', email) - 1), charindex('.', substring(email, 1, charindex('@', email) - 1)) + 1, 
len(substring(email, 1, charindex('@', email) - 1))) as last,
substring(substring(email, 1, charindex('@', email) - 1), charindex('.', substring(email, 1, charindex('@', email) - 1)) + 1, 
len(substring(email, 1, charindex('@', email) - 1))) + '.' + 
substring(substring(email, 1, charindex('@', email) - 1), 1, charindex('.', substring(email, 1, charindex('@', email) - 1)) - 1) + '@' +
case 
when patindex('%@yahoo%', email) <> 0 then 'hotmail.com'
when patindex('%@gmail%', email) <> 0 then 'yahoo.com'
when patindex('%@hotmail%', email) <> 0 then 'gmail.com' 
else 'clarusway.com' end as newmail
from sale.customer