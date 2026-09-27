with source as (
    select * from {{ ref('raw_orders') }}
),

renamed as (
    select
        cast(order_id as integer) as order_id,
        cast(customer_id as integer) as customer_id,
        cast(order_date as date) as order_date,
        trim(product_category) as product_category,
        cast(quantity as integer) as quantity,
        cast(unit_price_cents as integer) as unit_price_cents,
        cast(quantity as integer) * cast(unit_price_cents as integer) as line_total_cents
    from source
    where order_id is not null
),

-- keep the latest version of each order_id
deduped as (
    select
        *,
        row_number() over (partition by order_id order by order_date desc) as rn
    from renamed
)

select
    order_id,
    customer_id,
    order_date,
    product_category,
    quantity,
    unit_price_cents,
    line_total_cents
from deduped
where rn = 1
