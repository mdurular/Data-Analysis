 



---- 16.10.2021 Session-2 (Advanced Grouping Operations) ---------


---Join

-- Maðaza çalýþanlarýný yaptýklarý satýþlar ile birlikte listeleyin

SELECT	A.staff_id, A.first_name, B.order_id, B.staff_id 
FROM	sale.staff A LEFT JOIN SALE.orders B ON A.staff_id = B.staff_id
ORDER BY B.order_id 



SELECT	COUNT (DISTINCT A.staff_id) , COUNT (DISTINCT B.staff_id)
FROM	sale.staff A INNER JOIN SALE.orders B ON A.staff_id = B.staff_id



SELECT	COUNT (DISTINCT A.staff_id) , COUNT (DISTINCT B.staff_id)
FROM	sale.staff A 
EFT JOIN SALE.orders B ON A.staff_id = B.staff_id



------ CROSS JOIN ------

-- Hangi markada hangi kategoride kaçar ürün olduðu bilgisine ihtiyaç duyuluyor

SELECT B.brand_id, B.brand_name, A.category_name, A.category_id
FROM product.category A 
CROSS JOIN product.brand B
ORDER BY B.brand_name, A.category_name;


SELECT B.brand_id, B.brand_name, A.category_name, A.category_id
FROM product.brand B
CROSS JOIN product.category A 
ORDER BY A.category_name, B.brand_name;

----///////////----


------ SELF JOIN ------

-- Personelleri ve þeflerini listeleyin
-- Çalýþan adý ve yönetici adý bilgilerini getirin

SELECT A.first_name, A.last_name, B.first_name AS Manager_name 
FROM sale.staff A 
JOIN sale.staff B ON A.manager_id = B.staff_id



--------Advanced Grouping Operations

----product tablosunda herhangi bir product id' nin çoklayýp çoklamadýðýný kontrol ediniz.


SELECT	product_id, COUNT (*) CNT_ROW
FROM	product.product
GROUP BY	product_id
HAVING	COUNT (*) > 1



-----///

--maximum list price' ý 4000' in üzerinde olan veya minimum list price' ý 500' ün altýnda olan categori id' leri getiriniz
--category name' e gerek yok.

--SELECT	category_id, list_price
--FROM	product.product
--ORDER BY 1,2




SELECT	category_id, MAX(list_price) AS MAX_PRICE, MIN (list_price) MIN_PRICE 
FROM	product.product
GROUP BY	category_id
HAVING	MAX(list_price) > 4000 OR MIN (list_price) < 500



SELECT	category_id, MAX(list_price) AS MAX_PRICE, MIN (list_price) MIN_PRICE 
FROM	product.product
GROUP BY	category_id
HAVING	MAX(list_price) > 4000 AND MIN (list_price) < 500



------------////////////////-------------


--Markalara ait ortalama ürün fiyatlarýný bulunuz.
--ortalama fiyatlara göre azalan sýrayla gösteriniz.

SELECT	B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
GROUP BY
		B.brand_id, B.brand_name
ORDER BY 
		avg_price DESC


---ortalama ürün fiyatý 1000' den yüksek olan MARKALARI getiriniz



SELECT	B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
GROUP BY
		B.brand_id, B.brand_name
HAVING	AVG(A.list_price) > 1000
ORDER BY 
		avg_price DESC



--bir sipariþin toplam net tutarýný getiriniz. (müþterinin sipariþ için ödediði tutar)
--discount' ý ve quantity' yi ihmal etmeyiniz.

SELECT order_id, sum((quantity*list_price)*(1-discount)) as total_order_price
FROM sale.order_item
GROUP BY order_id




-------------------///////////////////






--SELECT ... INTO FROM ...

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year




-----GROUPING SETS



-----------//////////////////

SELECT *
FROM	sale.sales_summary



----1. Toplam sales miktarýný hesaplayýnýz.


SELECT	SUM(total_sales_price)
FROM	sale.sales_summary


--2. Markalarýn toplam sales miktarýný hesaplayýnýz


SELECT	brand, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	brand


--3. Kategori bazýnda yapýlan toplam sales miktarýný hesaplayýnýz



SELECT	Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	Category


--4. Marka ve kategori kýrýlýmýndaki toplam sales miktarýný hesaplayýnýz


SELECT	brand, Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	brand, Category
ORDER BY brand



----

SELECT	brand, category, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY
		GROUPING SETS (
				(brand, category),
				(brand),
				(category),
				()
				)
ORDER BY
	brand, category


-------brand, category, model_year sütunlarý için Rollup kullanarak total sales hesaplamasý yapýnýz.
--üç sütun için 4 farklý gruplama varyasyonu incelemeye çalýþýnýz.

SELECT	brand, category, Model_year, SUM(total_sales_price) AS total_sales_price
FROM	sale.sales_summary
GROUP BY
		ROLLUP(brand,category,Model_Year)
ORDER BY
	brand, category, Model_Year

