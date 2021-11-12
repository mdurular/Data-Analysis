-- Identify the bikes by gender and find the total counts and average prices of bikes by gender.  [gender, count_bikes_by_gender, average_price_by_gender]
-- kadýn bisikletlerini tespit için “Women, girl, ladies” kelimelerini arattýk.

select distinct product_id, product_name,
case when tt.women_girl = 1 then 'Women' else 'Men' end as gender,
case when tt.women_girl = 1 then sum(tt.women_girl) over() else count(tt.women_girl) over() - sum(tt.women_girl) over() end as count_bikes_by_gender,
avg(tt.list_price) over(partition by tt.women_girl) as average_price_by_gender
from
    (select product_id, product_name, list_price,
    case when patindex('%irl%', product_name) <> 0 or patindex('%omen%', product_name) <> 0  or patindex('%adies%', product_name) <> 0 then 1 else 0 end as women_girl
    from product.product) as tt
order by product_id