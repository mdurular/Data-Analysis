
--group by satýrýnda gruplandýrdýðýmýz sütunlar SELECT'te aynen olmalý!!
--aþaðýdaki 4 iþlemi birden GROUP BY GROUPING SETS((...),(...),(...)) ile yapacaðýz.

SELECT *
FROM	sale.sales_summary

----1. Toplam sales miktarýný hesaplayýnýz.

SELECT	SUM(total_sales_price) FROM	sale.sales_summary

--2. Markalarýn toplam sales miktarýný hesaplayýnýz

SELECT	brand, SUM(total_sales_price) total_sales
FROM	sale.sales_summary GROUP BY	brand

--3. Kategori bazýnda yapýlan toplam sales miktarýný hesaplayýnýz

SELECT	Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary GROUP BY	Category

--4. Marka ve kategori kýrýlýmýndaki toplam sales miktarýný hesaplayýnýz

SELECT	brand, Category, SUM(total_sales_price) total_sales
FROM	sale.sales_summary GROUP BY	brand, Category ORDER BY brand
----------------
SELECT	brand, category, SUM(total_sales_price) 
FROM	sale.sales_summary
GROUP BY	GROUPING SETS ((brand, category),(brand),(category),())
ORDER BY	brand, category
-----------------
SELECT		brand, category,model_year, SUM(total_sales_price) as Total_Sales
FROM		sale.sales_summary
GROUP BY	GROUPING SETS ((brand,category,model_year),(brand,category),(brand),())
ORDER BY	Brand, Category;

---Same result can be achieved by ROLLUP

SELECT		brand, category,model_year, SUM(total_sales_price) as Total_Sales
FROM		sale.sales_summary
GROUP BY	ROLLUP (brand,category, model_year)
ORDER BY	Brand, Category, model_year;

-- GROUPS:
-- c1,c2,c3
-- c1,c2,Null
-- c1,Null,Null
-- Null,Null,Null

--CUBE
--Generate different grouping variations that can be produced with the brand and category columns using 'CUBE'.

SELECT		brand, category, model_year, SUM(total_sales_price) 
FROM		sale.sales_summary
GROUP BY	CUBE (brand,category, model_year)
ORDER BY	brand, category;
-- GROUPS:
-- c1,c2,c3
-- c1,c2,Null
-- c1,c3,Null
-- c2,c3,Null
-- c1,Null,Null
-- c2,Null,Null
-- c3,Null,Null
-- Null,Null,Null


