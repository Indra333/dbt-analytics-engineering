with orders as (
    select * from {{ ref('int_customer_orders') }}
)

select
    order_date,
    count(distinct order_id) as num_orders,
    round(sum(line_total_dollars), 2) as total_revenue_dollars,
    round(sum(line_total_dollars) / count(distinct order_id), 2) as avg_order_value_dollars
from orders
group by order_date
order by order_date
