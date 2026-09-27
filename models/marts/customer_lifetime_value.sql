with orders as (
    select * from {{ ref('int_customer_orders') }}
)

select
    customer_id,
    max(customer_name) as customer_name,
    max(city) as city,
    max(state) as state,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    count(distinct order_id) as total_orders,
    round(sum(line_total_dollars), 2) as lifetime_revenue_dollars
from orders
group by customer_id
order by lifetime_revenue_dollars desc
