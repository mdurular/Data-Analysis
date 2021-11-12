
--HAVING, GROUPBY �LE KULLANILMAK ZORUNDADIR.
--HAVING, GROUP BY �LE OLU�TURULAN GRUPLARI, BEL�RLENEN �ARTLARA G�RE F�LTRELER.
--WHERE �LE KULLANILDI�INDA; SORGU �NCE WHERE'DEK� �ARTA G�RE F�LTRE YAPAR, 
--HAVING BU F�LTRELENM�� YEN� ALANDA AYNI SORGU ��ER�S�NDE �K�NC� B�R F�LTRELEME YAPAR.

---product tablosunda herhangi bir product id' nin �oklay�p �oklamad���n� kontrol ediniz.

SELECT		product_id, COUNT (*) CNT_ROW FROM	product.product
GROUP BY	product_id
HAVING		COUNT (*) > 1

--maximum list price' � 4000' in �zerinde olan veya minimum list price' � 500' �n alt�nda olan categori id' leri getiriniz

SELECT		category_id, MAX(list_price) AS MAX_PRICE, MIN (list_price) MIN_PRICE 
FROM		product.product
GROUP BY	category_id
HAVING		MAX(list_price) > 4000 OR MIN (list_price) < 500

--An aggregate may not appear in the WHERE clause unless it is 
-- in a subquery contained in a HAVING clause or a select list, and the column being aggregated is an outer reference.
--BU NEDENLE A�A�IDAK� SORGU �ALI�MAZ.

--SELECT	category_id, MAX(list_price) AS MAX_PRICE, MIN (list_price) MIN_PRICE 
--FROM		product.product
--WHERE		MAX(list_price) > 4000 OR MIN (list_price) < 500
--GROUP BY	category_id

--Markalara ait ortalama �r�n fiyatlar�n� bulunuz.
--ortalama fiyatlara g�re azalan s�rayla g�steriniz.

SELECT		B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM		product.product A, product.brand B
WHERE		A.brand_id = B.brand_id
GROUP BY	B.brand_id, B.brand_name
ORDER BY 	avg_price DESC

---ortalama �r�n fiyat� 1000' den y�ksek olan MARKALARI getiriniz

SELECT		B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM		product.product A, product.brand B
WHERE		A.brand_id = B.brand_id
GROUP BY	B.brand_id, B.brand_name
HAVING		AVG(A.list_price) > 1000
ORDER BY 	avg_price DESC

--bir sipari�in toplam net tutar�n� getiriniz. (m��terinin sipari� i�in �dedi�i tutar)
--discount' � ve quantity' yi ihmal etmeyiniz.

SELECT		order_id, SUM(quantity * list_price * (1-discount)) as net_price
FROM		sale.order_item
GROUP BY 	order_id
-- (list_price-list_price*discount) olarak da yaz�labilirdi.



