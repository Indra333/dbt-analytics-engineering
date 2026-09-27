# dbt Analytics Engineering

A dbt project that turns raw e-commerce seeds into tested, documented analytics marts. It runs entirely locally on **DuckDB** — no warehouse account needed.

## Layered design

The project follows a layered (medallion-style) modeling approach:

**Staging** (`models/staging/`) — one view per raw source. This is where all the messiness gets handled: type casting, trimming and normalizing strings, and deduplication. `stg_customers` implements SCD Type 1, keeping only the latest record per `customer_id`. Business logic never lives here.

**Intermediate** (`models/intermediate/`) — `int_customer_orders` joins the clean staging models and adds shared derived fields (like `line_total_dollars`, via the `cents_to_dollars` macro). Anything two marts would both need lives here, defined once.

**Marts** (`models/marts/`) — the tables analysts actually query: `daily_revenue` (one row per day: order counts, revenue, average order value) and `customer_lifetime_value` (one row per customer: first/last order, total orders, lifetime revenue).

## Tests and docs

Every model has a `schema.yml` with column descriptions and data tests: `unique`, `not_null`, `accepted_values`, and a `relationships` test enforcing the orders → customers foreign key. `tests/assert_revenue_non_negative.sql` is a singular test guarding against negative daily revenue. Run `dbt docs generate && dbt docs serve` to browse the full documentation site.

## How to run

```bash
pip install -r requirements.txt
dbt seed --profiles-dir .     # load the sample raw data
dbt run --profiles-dir .      # build staging -> intermediate -> marts
dbt test --profiles-dir .     # run all data tests
# or simply: dbt build --profiles-dir .
```

## Sample output

`daily_revenue` (first rows):

| order_date | num_orders | total_revenue_dollars | avg_order_value_dollars |
|------------|-----------:|----------------------:|------------------------:|
| 2024-08-01 | 2 | 538.96 | 269.48 |
| 2024-08-02 | 1 | 79.99 | 79.99 |
| 2024-08-03 | 2 | 931.97 | 465.99 |

`customer_lifetime_value` (top rows):

| customer_id | customer_name | total_orders | lifetime_revenue_dollars |
|------------:|---------------|-------------:|-------------------------:|
| 10 | Jack Anderson | 1 | 1299.99 |
| 1 | Alice Johnson | 3 | 1023.95 |
| 5 | Eva Davis | 1 | 899.99 |
