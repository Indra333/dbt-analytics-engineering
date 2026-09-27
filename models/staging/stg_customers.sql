with source as (
    select * from {{ ref('raw_customers') }}
),

renamed as (
    select
        cast(customer_id as integer) as customer_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        lower(trim(email)) as email,
        trim(city) as city,
        trim(state) as state,
        cast(signup_date as date) as signup_date
    from source
),

-- SCD Type 1: keep only the latest record per customer_id
deduped as (
    select
        *,
        row_number() over (partition by customer_id order by signup_date desc) as rn
    from renamed
)

select
    customer_id,
    first_name,
    last_name,
    email,
    city,
    state,
    signup_date
from deduped
where rn = 1
