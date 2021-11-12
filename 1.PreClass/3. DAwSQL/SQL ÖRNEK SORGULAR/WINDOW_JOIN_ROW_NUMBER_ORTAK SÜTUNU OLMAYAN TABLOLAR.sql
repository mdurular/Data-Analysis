-- GÜNLÜK SÝPARÝÞ DURUMU

select t.order_id, t.product_name, t.order_date, t.indexing, t.list_price
from
    (select o.order_id, p.product_name, o.order_date, p.list_price, 
    row_number() over(partition by o.order_date order by o.order_id, p.list_price) as indexing
    from sale.orders o join sale.order_item so on o.order_id=so.order_id join product.product p on p.product_id=so.product_id) as t 
where t.indexing = 1,


-------- AÞAÐIDAKÝ ÝKÝ AYRI TABLOYU BÝRLEÞTÝRÝN
select brand_id, brand_name from product.brand
select staff_id, first_name, last_name, email from sale.staff

-- ROW_NUMBER() ÝLE INDEKSLER OLUÞTURUP ORTAK ÝNDEKSLER ÜZERÝNDEN JOIN:

select * from
(select brand_id, brand_name, row_number () over(order by brand_id) as index_1 from product.brand) as T1 join
(select staff_id, first_name, last_name, email, row_number() over(order by staff_id) as index_2 from sale.staff) as T2 on T1.index_1=T2.index_2
