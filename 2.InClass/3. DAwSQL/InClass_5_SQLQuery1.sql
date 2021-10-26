select *
from product.brand
where brand_id in (
select brand_id
from product.product
where model_year = 2018
except
select brand_id
from product.product
where model_year = 2019)


SELECT product_id, product_name
FROM product.product 
WHERE product_id IN (
			SELECT	A.product_id
			FROM	sale.order_item A, sale.orders B
			WHERE	A.order_id = B.order_id
			AND		YEAR(B.order_date) = '2019' 
			EXCEPT
			SELECT	A.product_id
			FROM	sale.order_item A, sale.orders B
			WHERE	A.order_id = B.order_id
			AND		YEAR(B.order_date) != '2019' 
			) 

---- CASE WHEN

SELECT *, 
	CASE order_status
		WHEN '1' THEN 'Pending'
		WHEN '2' THEN 'Processing'
		WHEN '3' THEN 'Rejected'
		WHEN '4' THEN 'Completed'
	END AS Status_order
FROM sale.orders
	
/*Staff tablosuna çalýþanlarýn maðaza isimlerini ekleyin.
1 = sacramento bikes, 2: buffalo bikes, 3: san angelo bikes */

SELECT first_name, last_name, store_id,
		CASE store_id
			WHEN '1' THEN 'SAcramento Bikes'
			WHEN '2' THEN 'Buffalo Bikes'
			WHEN '3' THEN 'San Angeleo Bikes'
		END AS store_name
FROM sale.staff

-----
select first_name, last_name,store_id,
	case
		when store_id = 1 then 'Sacramento Bikes'
		when store_id = 2 then 'Buffalo Bikes'
		when store_id = 3 then 'San Angelo Bikes'
	end as Store_name
from sale.staff

-----Müþterilerin e-mail adreslerindeki servis
----- saðlayýcýlarýný yeni bir sütun oluþturarak belirtiniz.


SELECT	email,
		CASE	
			WHEN email LIKE '%@yahoo%' THEN 'Yahoo'
			WHEN email LIKE '%@gmail%' THEN 'Gmail'
			WHEN email LIKE '%@hotmail%' THEN 'Hotmail'
			WHEN email IS NOT NULL THEN 'Others'
		END Email_providers
FROM	sale.customer

------ Ayný sipariþte hem Electric Bikes, hem Comfort Bicycles hem de Children Bicycles 
-----  ürünlerini sipariþ veren müþterileri bulunuz.