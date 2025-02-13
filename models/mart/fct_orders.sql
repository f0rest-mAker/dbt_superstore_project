with 
cut_orders as (
    select distinct
        order_id,
        ship_mode,
        customer_name,
        segment,
        country,
        state,
        city,
        postal_code,
        region,
        category,
        subcategory,
        product_name,
        sales,
        quantity,
        profit,
        discount
    from {{ ref('stg_superstore__orders') }}
),
new_combined_orders as (
    select distinct
        order_id,
        ship_mode_id,
        customer_id,
        place_id,
    from cut_orders join {{ ref('dim_customers') }} using(customer_name, segment)
                    join {{ ref('dim_deliver') }} using(country, state, city, postal_code, region)
                    join {{ ref('dim_ship') }} using(ship_mode)
),
orders_agg as (
    select
        order_id,
        day(max(ship_date) - max(order_date)) as delivering_days,
        sum(sales) as sales,
        round(avg(discount), 4) as avg_discount_to_products,
        sum(profit) as profit
        sum(quantity) as quantity,
        count(distinct product_id) as number_of_products,
        round(avg(sales / quantity), 4) as avg_sales_per_product
    from cut_orders
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
    profit
    quantity,
    number_of_products,
    avg_sales_per_product
from final