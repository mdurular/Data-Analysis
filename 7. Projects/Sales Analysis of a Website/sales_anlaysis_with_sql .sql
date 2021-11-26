
--1. How many rows in the sales dataset?

SELECT count(*) FROM sales

--1.1. How many columns in the sales dataset?

SELECT count(COLUMN_NAME)
FROM   sales.INFORMATION_SCHEMA.COLUMNS
where table_name='sales'

--2. What is the total number of seller?

SELECT count(distinct seller_id)
FROM sales

--3. What is the total value of sales in EUR?
--update  currency_rates
--set [date]=convert(date, date)

--update  sales
--set [date]=convert(date ,date)

--select *
--from currency_rates

--select *
--from sales


select  sum(cast(a.price as float)/cast(b.rate as float)) as total
from sales a
inner join currency_rates b
on a.currency = b.currency
and a.date = b.date;

--4. Which brand has the highest number of purchases during the period?
update sales set brand= 'Unknown' WHERE brand = ' '

select TOP 1 brand,count(brand) from sales
WHERE brand != 'Unknown'
group by brand
order by count(brand) desc

--5. How many items in the "Jewellery" category have no brand assciateed with them?
SELECT count(Distinct product_code)
FROM sales
WHERE category = 'Jewellery'
AND brand = 'Unknown'

--6. How many brands have between 35 and 55 transactions (inclusive)? 

select count(a.brand) as brands_count
from (select brand
from sales
group by brand
having count(product_code) between 35 and 55) a

--7. How many pairs of shoes were purchased by Australian (AU) buyers?
select count(product_code)
from sales
where buyer_country = 'AU' and
category = 'Shoes'

--8. Which brand has the highest average transaction value? Bring all values in Euros. 
----iþlem sayýsý olarak en fazla olan
select TOP 1 brand,count(brand) from sales
WHERE brand != 'Unknown'
group by brand
order by count(brand) desc

--tutara göre en fazla olan
select top 1  a.brand, avg(cast(a.price as float)/cast(b.rate as float)) as total 
from sales a
inner join currency_rates b
on a.currency = b.currency
and a.date = b.date
group by a.brand
order by total desc;

--9. What is the total value of items purchased by GB buyers from GB sellers?
select  sum(cast(price as float)/cast(rate as float)) as total 
from sales a
inner join currency_rates b
on a.currency = b.currency
and a.date = b.date
where a.seller_country = 'GB' and
a.buyer_country = 'GB'

--10. What percentage of US sellers' transactions were purchased by US buyers?
----alýþ veriþ sayýsý olarak
select 
(select count(product_code)*100
from sales
where seller_country = 'US' and buyer_country = 'US')
/
(select count(product_code)
from sales
where seller_country = 'US') percentage_count


--11. Which country made the highest value of international purchases?
select  top 1 buyer_country, sum(cast(price as float)/cast(rate as float)) as total 
from sales a
inner join currency_rates b
on a.currency = b.currency
and a.date = b.date
where seller_country != buyer_country
group by buyer_country
order by total desc

--12. Which day has the highest value of purchases?
select top 1 a.date, sum(cast(price as float)/cast(rate as float)) as total 
from sales a
inner join currency_rates b
on a.currency = b.currency
and a.date = b.date
group by a.date
order by total desc

--13. Which category has 2,324 transactions on 7 August?
select category, count(product_code)
from sales
where date = '2020-08-07'
group by category
having count(product_code) = 2324


--14. What percentage of global sales value on 4 August came from US sellers?

select round((select  sum(cast(price as float)/cast(rate as float))*100 as total 
from sales a
inner join currency_rates b
on a.currency = b.currency
and a.date = b.date
where a.date = '2020-08-04' and 
seller_country = 'US')
/
(select  sum(cast(price as float)/cast(rate as float)) as total 
from sales a
inner join currency_rates b
on a.currency = b.currency
and a.date = b.date
where a.date = '2020-08-04'),2) as percentage

--15. How many sellers in the US has more than 75 sales?
select count(a.seller_id)
from (select distinct seller_id
from sales
where seller_country = 'US'
group by seller_id
having count(seller_id) > 75) a

--16. Which seller in the US sold the most in terms of value?
select top 1 seller_id, sum(cast(price as float)/cast(rate as float)) as total
from sales a
inner join currency_rates b
on a.currency = b.currency
and a.date = b.date
where seller_country = 'US'
group by seller_id
order by total desc

--17. Which brand had the largest absolute € difference in average transaction value between domestic and international?
create view domestic as (select  brand, avg(cast(price as float)/cast(rate as float)) domestic 
from sales a
inner join currency_rates b
on a.currency = b.currency
and a.date = b.date
where buyer_country = seller_country and
brand != 'Unknown'
group by brand)

create view international as (select brand, avg(cast(price as float)/cast(rate as float)) international 
from sales a
inner join currency_rates b
on a.currency = b.currency
and a.date = b.date
where buyer_country != seller_country
and brand != 'Unknown'
group by brand)

select top 1 a.brand, abs(a.domestic - b.international) diffirence
from domestic a
inner join international b
on a.brand = b.brand
order by diffirence desc

