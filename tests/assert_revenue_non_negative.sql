-- Singular test: fails if any day shows negative total revenue.
select
    order_date,
    total_revenue_dollars
from {{ ref('daily_revenue') }}
where total_revenue_dollars < 0
