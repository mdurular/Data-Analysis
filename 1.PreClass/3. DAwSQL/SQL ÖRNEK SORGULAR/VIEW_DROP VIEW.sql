-- 2019 y�l�ndan sonra �retilen �r�nlerin bulundu�u bir 'NEW_PRODUCTS' view' i olu�turun

create view new_view as
select product_id, model_year
from product.product
where model_year > 2019

SELECT * FROM new_view

DROP VIEW new_view