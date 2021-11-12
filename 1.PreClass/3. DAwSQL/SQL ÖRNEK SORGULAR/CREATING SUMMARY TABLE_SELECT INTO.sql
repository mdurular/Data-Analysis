-------- CREATING SUMMARY TABLE INTO OUR EXISTING TABLE -------

SELECT cols
INTO NEW_TABLE_NAME       -- INTO SATIRINDAKÝ TABLO ÝSMÝ ÝLE YENÝ BÝR TABLO OLUÞTURUYORUZ.
FROM SOURCE_TABLEs_NAMEs  -- FROM'DAN SONRASI KAYNAK TABLOMUZ
WHERE Condition 
-----------
SELECT		C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
			ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO		sale.sales_summary
FROM		sale.order_item A, product.product B, product.brand C, product.category D
WHERE		A.product_id = B.product_id
AND			B.brand_id = C.brand_id
AND			B.category_id = D.category_id
GROUP BY	C.brand_name, D.category_name, B.model_year

--!!!! DÝKKAT.. DAHA ÖNCE BU KOD ÇALIÞTIRILDIÐI VE sales_summary ÝSMÝNDE TABLO OLUÞTURULDUÐU ÝÇÝN TEKRAR ÇALIÞTIRIRSAN HATA ALIRSIN!
-- Tablo oluþturma WHERE yerine aþaðýdaki gibi JOIN iþlemi ile de yapýlabilir.

SELECT		C.brand_name as Brand, D.category_name as Category,B.model_year as Model_Year, 
ROUND		(SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO		sale.sales_summary  -- Creates New table
FROM		sale.order_item A  -- total sales
JOIN		product.product B  ON A.product_id = B.product_id-- model year
JOIN		product.brand C ON  C.brand_id = B.brand_id -- brand name
JOIN		product.category D ON D.category_id = B.category_id -- category names
GROUP BY	C.brand_name, D.category_name,B.model_year ;







SELECT * FROM sale.sales_summary order by 1,2,3

