



---- 16.10.2021 Session-2 (Advanced Grouping Operations) ---------


---Join

-- Ma�aza �al��anlar�n� yapt�klar� sat��lar ile birlikte listeleyin

SELECT	A.staff_id, A.first_name, B.order_id, B.staff_id 
FROM	sale.staff A LEFT JOIN SALE.orders B ON A.staff_id = B.staff_id
ORDER BY B.order_id 



SELECT	COUNT (DISTINCT A.staff_id) , COUNT (DISTINCT B.staff_id)
FROM	sale.staff A INNER JOIN SALE.orders B ON A.staff_id = B.staff_id



SELECT	COUNT (DISTINCT A.staff_id) , COUNT (DISTINCT B.staff_id)
FROM	sale.staff A LEFT JOIN SALE.orders B ON A.staff_id = B.staff_id



------ CROSS JOIN ------

-- Hangi markada hangi kategoride ka�ar �r�n oldu�u bilgisine ihtiya� duyuluyor





----///////////----


------ SELF JOIN ------

-- Personelleri ve �eflerini listeleyin
-- �al��an ad� ve y�netici ad� bilgilerini getirin



---------------- 



--------Advanced Grouping Operations

----product tablosunda herhangi bir product id' nin �oklay�p �oklamad���n� kontrol ediniz.


SELECT	product_id, COUNT (*) CNT_ROW
FROM	product.product
GROUP BY	product_id
HAVING	COUNT (*) > 1



-----///

--maximum list price' � 4000' in �zerinde olan veya minimum list price' � 500' �n alt�nda olan categori id' leri getiriniz
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


--Markalara ait ortalama �r�n fiyatlar�n� bulunuz.
--ortalama fiyatlara g�re azalan s�rayla g�steriniz.

SELECT	B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
GROUP BY
		B.brand_id, B.brand_name
ORDER BY 
		avg_price DESC


---ortalama �r�n fiyat� 1000' den y�ksek olan MARKALARI getiriniz



SELECT	B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id
GROUP BY
		B.brand_id, B.brand_name
HAVING	AVG(A.list_price) > 1000
ORDER BY 
		avg_price DESC



--bir sipari�in toplam net tutar�n� getiriniz. (m��terinin sipari� i�in �dedi�i tutar)
--discount' � ve quantity' yi ihmal etmeyiniz.






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



----1. Toplam sales miktar�n� hesaplay�n�z.


SELECT	SUM(total_sales_price)
FROM	sale.sales_summary


--2. Markalar�n toplam sales miktar�n� hesaplay�n�z


SELECT	brand, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	brand


--3. Kategori baz�nda yap�lan toplam sales miktar�n� hesaplay�n�z



SELECT	Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary
GROUP BY	Category


--4. Marka ve kategori k�r�l�m�ndaki toplam sales miktar�n� hesaplay�n�z


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


-------brand, category, model_year s�tunlar� i�in Rollup kullanarak total sales hesaplamas� yap�n�z.
--�� s�tun i�in 4 farkl� gruplama varyasyonu incelemeye �al���n�z.



