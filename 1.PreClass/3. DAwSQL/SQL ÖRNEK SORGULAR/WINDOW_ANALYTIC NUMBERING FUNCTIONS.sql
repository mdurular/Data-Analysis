
-- OREDER BY kullanmak zorunlu, PARTITION BY kullanmak optional
FIRST_VALUE()
SELECT DISTINCT FIRST_VALUE(col1) OVER(ORDER BY col2) AS 
SELECT DISTINCT col1, FIRST_VALUE(col2) OVER(PARTITION BY col1 ORDER BY col3) 

LAST_VALUE()
SELECT DISTINCT LAST_VALUE(col1) 
OVER(ORDER BY col2 DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)

SELECT DISTINCT LAST_VALUE(col1) 
OVER(ORDER BY col2 DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS 

select list_price, 
first_value(list_price) over(order by list_price) as first_value_by_listprice, 
-- first_value(list_price) over(partition by model_year order by list_price) as first_value_by_modelyear, 
last_value(list_price) over(order by list_price) as last_price_by_listprice, 
first_value(list_price) over(order by list_price rows between 3 preceding and 3 following) first_by_3window, 
last_value(list_price) over(order by list_price rows between 3 preceding and 3 following) as last_by_3window 
from product.product;

select list_price, 
first_value(list_price) over(partition by model_year order by list_price) as first_value_by_modelyear,
last_value(list_price) over(partition by model_year order by list_price) as last_price_by_listprice, 
first_value(list_price) over(partition by model_year order by list_price rows between 3 preceding and 3 following) first_by_3window, 
last_value(list_price) over(partition by model_year order by list_price rows between 3 preceding and 3 following) as last_by_3window 
from product.product;

LAG(ÖNCEKÝ SATIRLARA)
SELECT B.staff_id, B.first_name, B.last_name, A.order_id, A.order_date,
LAG(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) AS BÝR_ÖNCEKÝ_SÝPARÝÞ

LEAD(SONRAKÝ SATIRLARA)
SELECT B.staff_id, B.first_name, B.last_name, A.order_id, A.order_date,
LEAD(order_date) OVER (PARTITION BY A.staff_id ORDER BY order_id) AS NEXT_ORDER_DATE

select product_id, list_price,
sum(list_price) over() as total,
sum(list_price) over(order by product_id) as cumulative,
lag(list_price, 2) over(order by product_id) as iki_oncesi,
lead(list_price, 3) over(order by product_id) as bir_sonrasi,
sum(list_price) over(order by product_id rows between 1 preceding and 1 following) as uclu
from product.product
order by product_id;

ROW_NUMBER(), RANK(), DENSE_RANK() --SIRA NUMARASI VER
-- RANK(AYNI DEÐERLERÝN HEPSÝNE ÝLKÝNÝN ÝNDEKS NUMARASINI VERÝRKEN; SAYAÇ ARKADA ÇALIÞIR)
-- DENSE_RANK(SAYAÇ KALDIÐI YERDEN DEVAM EDER)
-- ORDER BY yapýlan sütuna göre sýralandýrýr
-- OREDER BY kullanmak zorunlu, PARTITION BY kullanmak optional
SELECT	category_id, list_price, 

ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY list_price) AS,
RANK() OVER (PARTITION BY category_id ORDER BY list_price) AS,
DENSE_RANK() OVER (PARTITION BY category_id ORDER BY list_price) AS

select product_id, model_year, list_price, 
row_number() over(order by product_id) as row_1,
row_number() over(partition by model_year order by product_id) as row_2
from product.product

select model_year, list_price,
rank() over(order by list_price) as ranked,
dense_rank() over(order by list_price) as dense_ranked
from product.product

CUME_DIST(), PERCENT_RANK(), NTILE()
-- CUME_DIST(TOPLAM SATIR SAYISINA BÖLER)
-- PERCENT_RANK(TOPLAM SATIR SAYISI-1’E BÖLER)
-- NTILE(INT) : EÞÝT GRUPLARA BÖLER

select product_id,
cume_dist() over(order by product_id) as cume_disted,
percent_rank() over(order by product_id) as p_ranked
from product.product

select product_id, list_price, model_year,
ntile(10) over(partition by model_year order by list_price desc) as tiled
from product.product

SELECT DISTINCT product_quantity, ROUND(CUME_DIST() OVER (ORDER BY product_quantity), 2)
SELECT DISTINCT product_quantity, ROUND(PERCENT_RANK() OVER (ORDER BY product_quantity), 2)
SELECT customer_id, NTILE(5) OVER (ORDER BY product_quantity DESC)