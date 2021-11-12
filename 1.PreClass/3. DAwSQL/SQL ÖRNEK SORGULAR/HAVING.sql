
--HAVING, GROUPBY ÝLE KULLANILMAK ZORUNDADIR.
--HAVING, GROUP BY ÝLE OLUÞTURULAN GRUPLARI, BELÝRLENEN ÞARTLARA GÖRE FÝLTRELER.
--WHERE ÝLE KULLANILDIÐINDA; SORGU ÖNCE WHERE'DEKÝ ÞARTA GÖRE FÝLTRE YAPAR, 
--HAVING BU FÝLTRELENMÝÞ YENÝ ALANDA AYNI SORGU ÝÇERÝSÝNDE ÝKÝNCÝ BÝR FÝLTRELEME YAPAR.

---product tablosunda herhangi bir product id' nin çoklayýp çoklamadýðýný kontrol ediniz.

SELECT		product_id, COUNT (*) CNT_ROW FROM	product.product
GROUP BY	product_id
HAVING		COUNT (*) > 1

--maximum list price' ý 4000' in üzerinde olan veya minimum list price' ý 500' ün altýnda olan categori id' leri getiriniz

SELECT		category_id, MAX(list_price) AS MAX_PRICE, MIN (list_price) MIN_PRICE 
FROM		product.product
GROUP BY	category_id
HAVING		MAX(list_price) > 4000 OR MIN (list_price) < 500

--An aggregate may not appear in the WHERE clause unless it is 
-- in a subquery contained in a HAVING clause or a select list, and the column being aggregated is an outer reference.
--BU NEDENLE AÞAÐIDAKÝ SORGU ÇALIÞMAZ.

--SELECT	category_id, MAX(list_price) AS MAX_PRICE, MIN (list_price) MIN_PRICE 
--FROM		product.product
--WHERE		MAX(list_price) > 4000 OR MIN (list_price) < 500
--GROUP BY	category_id

--Markalara ait ortalama ürün fiyatlarýný bulunuz.
--ortalama fiyatlara göre azalan sýrayla gösteriniz.

SELECT		B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM		product.product A, product.brand B
WHERE		A.brand_id = B.brand_id
GROUP BY	B.brand_id, B.brand_name
ORDER BY 	avg_price DESC

---ortalama ürün fiyatý 1000' den yüksek olan MARKALARI getiriniz

SELECT		B.brand_id, B.brand_name, AVG(A.list_price) avg_price
FROM		product.product A, product.brand B
WHERE		A.brand_id = B.brand_id
GROUP BY	B.brand_id, B.brand_name
HAVING		AVG(A.list_price) > 1000
ORDER BY 	avg_price DESC

--bir sipariþin toplam net tutarýný getiriniz. (müþterinin sipariþ için ödediði tutar)
--discount' ý ve quantity' yi ihmal etmeyiniz.

SELECT		order_id, SUM(quantity * list_price * (1-discount)) as net_price
FROM		sale.order_item
GROUP BY 	order_id
-- (list_price-list_price*discount) olarak da yazýlabilirdi.



