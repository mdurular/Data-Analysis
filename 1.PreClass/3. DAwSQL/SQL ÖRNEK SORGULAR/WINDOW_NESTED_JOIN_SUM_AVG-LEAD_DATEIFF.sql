-- List the staff information in the ascending order according to their performance.
-- Determine their performance according to how long they waited to receive their next order.
-- [staff_id, first_name, last_name, previous_order, next_order, days_waited, cumulative_days, average_days]

select t.staff_id, t.first_name, t.last_name, t.previous_order, t.next_order, t.days,
sum(t.days) over (partition by t.staff_id order by(t.next_order)) as cumulative,
avg(t.days) over (partition by t.staff_id) as avg_days
from
    (select st.staff_id, st.first_name, st.last_name, o.order_date as previous_order,
    lead(o.order_date) over(partition by st.staff_id order by o.order_date) as next_order,
    datediff(day, o.order_date, lead(o.order_date) over(partition by st.staff_id order by o.order_date)) as days
    from sale.staff st join sale.orders o on st.staff_id=o.staff_id) as t
order by avg_days