with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
)

select
    o.order_id,
    o.order_date,
    o.product_category,
    o.quantity,
    o.unit_price_cents,
    o.line_total_cents,
    {{ cents_to_dollars('o.line_total_cents') }} as line_total_dollars,
    c.customer_id,
    c.first_name || ' ' || c.last_name as customer_name,
    c.city,
    c.state
from orders o
inner join customers c on o.customer_id = c.customer_id
