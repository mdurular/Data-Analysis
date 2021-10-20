

-----///    2021-10-20 DAwSQL Session 3 (Organize Complex Queries)


--- FROM THE LAST SESSION

--Summary Table


SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year


--
-- ROLLUP

--brand, category, model_year sütunlarý için Rollup kullanarak total sales hesaplamasý yapýn.
--üç sütun için 4 farklý gruplama varyasyonu üretmek istiyoruz.



SELECT	brand, Category, Model_Year, SUM(total_sales_price) total_price
FROM	sale.sales_summary
GROUP BY
		ROLLUP (brand, Category, Model_Year)



--brand, category, model_year sütunlarý için cube kullanarak total sales hesaplamasý yapýn.

--üç sütun için 8 farklý gruplama varyasyonu oluþturuyor	



SELECT	brand, Category, Model_Year, SUM(total_sales_price) total_price
FROM	sale.sales_summary
GROUP BY
		CUBE (brand, Category, Model_Year)
ORDER BY
		brand, Category


-----/////////////--------


--------- PIVOT ----------

--kategorilere ve model yýlýna göre toplam sales miktarýný summary tablosu üzerinden hesaplayýn




SELECT Category, Model_Year, SUM(total_sales_price) TOTAL_SALES
FROM	SALE.sales_summary
GROUP BY
		Category, Model_Year
ORDER BY 1,2


---------------------

	SELECT Category, Model_Year, SUM (total_sales_price)
	FROM	SALE.sales_summary
	GROUP BY 
			Category, Model_Year





SELECT *
FROM
	(
	SELECT Category, Model_Year, total_sales_price
	FROM	SALE.sales_summary
	) A
PIVOT
	(
	SUM(total_sales_price)
	FOR Category
	IN (
		[Children Bicycles], 
		[Comfort Bicycles], 
		[Cruisers Bicycles], 
		[Cyclocross Bicycles], 
		[Electric Bikes], 
		[Mountain Bikes], 
		[Road Bikes]
		)
	) AS P1


-----------


----SUBQUERIES



--order id' lere göre toplam list price larý hesaplayýn.


SELECT	order_id,
		(SELECT SUM(list_price) FROM sale.order_item B)
FROM	sale.order_item A

---CORRELATED


SELECT	DISTINCT order_id,
		(SELECT SUM(list_price) FROM sale.order_item B WHERE A.order_id = B.order_id) SUM_PRICE
FROM	sale.order_item A

---


-- Maria Cussona'nýn çalýþtýðý maðazadaki tüm personelleri listeleyin.


SELECT	first_name, last_name
FROM	sale.staff 
WHERE	store_id = (
						SELECT	store_id
						FROM	SALE.staff
						WHERE	first_name = 'Maria' AND last_name = 'Cussona'
					)


---/////////////


-- Jane	Destrey'ýn yöneticisi olduðu personelleri listeleyin.


SELECT *
FROM	sale.staff
WHERE	manager_id = (
						SELECT	staff_id
						FROM	sale.staff
						WHERE	first_name = 'Jane' AND last_name = 'Destrey'
						)


---------


SELECT	first_name, last_name
from	sale.staff
where	manager_id in (select staff_id from sale.staff where first_name= 'Jane')



-- Holbrook þehrinde oturan müþterilerin sipariþ tarihlerini listeleyin.



SELECT	customer_id, order_id, order_date
FROM	SALE.orders
WHERE	customer_id IN (
						SELECT	customer_id
						FROM	SALE.customer
						WHERE	city = 'Holbrook'
						)


-- Abby	Parks isimli müþterinin alýþveriþ yaptýðý tarihte/tarihlerde alýþveriþ yapan tüm müþterileri listeleyin.
-- Müþteri adý, soyadý ve sipariþ tarihi bilgilerini listeleyin.


SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE order_date IN (
					SELECT order_date
					FROM Sale.customer A
					JOIN Sale.orders B
					ON A.customer_id = B.customer_id
					WHERE first_name = 'Abby' AND last_name = 'Parks'
					)


-----

SELECT	C.first_name, C.last_name, A.order_id, A.order_date
FROM	sale.orders A 
INNER JOIN (
			SELECT	A.first_name, A.last_name, B.customer_id, B.order_id, B.order_date
			FROM	sale.customer A INNER JOIN sale.orders B ON A.customer_id = B.customer_id
			WHERE	A.last_name = 'Parks' AND A.first_name = 'Abby'
			) B 
ON A.order_date = B.order_date
INNER JOIN sale.customer C ON A.customer_id = C.customer_id




---///

-- Bütün elektrikli bisikletlerden pahalý olan bisikletleri listelyin.
-- Ürün adý, model_yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru sýralayýnýz.


SELECT	list_price
FROM	product.product A INNER JOIN product.category B ON A.category_id = B.category_id
WHERE	B.category_name = 'Electric Bikes'
ORDER BY 
		1



SELECT	product_name, list_price
FROM	product.product 
WHERE	list_price > ALL (
							SELECT	list_price
							FROM	product.product A INNER JOIN product.category B ON A.category_id = B.category_id
							WHERE	B.category_name = 'Electric Bikes'
							)
AND		model_year = 2020


--


SELECT	product_name, list_price
FROM	product.product 
WHERE	list_price > ANY (
							SELECT	list_price
							FROM	product.product A INNER JOIN product.category B ON A.category_id = B.category_id
							WHERE	B.category_name = 'Electric Bikes'
							)
AND		model_year = 2020





---------



SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE EXISTS (
					SELECT 1
					FROM Sale.customer A
					JOIN Sale.orders B
					ON A.customer_id = B.customer_id
					WHERE first_name = 'Abby' AND last_name = 'Parks'
					)

---CORRELATED



SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE EXISTS (
					SELECT 1
					FROM Sale.customer C
					JOIN Sale.orders D
					ON C.customer_id = D.customer_id
					WHERE first_name = 'Abby' AND last_name = 'Parks'
					AND		A.order_date = D.order_date
					)



---

SELECT DISTINCT B.first_name, B.last_name, A.order_date
FROM Sale.orders A
JOIN Sale.customer B
ON A.customer_id = B.customer_id
WHERE NOT EXISTS (
					SELECT 1
					FROM Sale.customer A
					JOIN Sale.orders B
					ON A.customer_id = B.customer_id
					WHERE first_name = 'Abbay' AND last_name = 'Parks'
					)








