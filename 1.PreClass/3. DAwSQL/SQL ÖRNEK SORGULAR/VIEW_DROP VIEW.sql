-- 2019 yýlýndan sonra üretilen ürünlerin bulunduðu bir 'NEW_PRODUCTS' view' i oluþturun

create view new_view as
select product_id, model_year
from product.product
where model_year > 2019

SELECT * FROM new_view

DROP VIEW new_view