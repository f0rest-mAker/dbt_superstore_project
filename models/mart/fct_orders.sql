with 
new_combined_orders as (
    select distinct
        order_id,
        s.ship_mode_id,
        c.customer_id,
        d.place_id
    from {{ ref('stg_superstore__orders') }} join {{ ref('dim_customers') }} as c using(customer_name, segment)
                join {{ ref('dim_deliver') }} as d using(country, state, city, postal_code, region)
                join {{ ref('dim_ship') }} as s using(ship_mode)
),
orders_agg as (
    select
        order_id,
        max(ship_date) - max(order_date) as delivering_days,
        sum(sales) as sales,
        round(avg(discount), 4) as avg_discount_to_products,
        sum(profit) as profit,
        sum(quantity) as quantity,
        count(distinct product_id) as number_of_products,
        round(avg(sales / quantity), 4) as avg_sales_per_product
    from {{ ref('stg_superstore__orders') }}
    group by order_id
),
final as (
    select * from orders_agg join new_combined_orders using(order_id)
)

select 
    row_number() over() as order_id,
    ship_mode_id,
    customer_id,
    place_id,
    delivering_days,
    sales,
    avg_discount_to_products,
    profit,
    quantity,
    number_of_products,
    avg_sales_per_product
from final