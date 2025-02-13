with 
orders as (
    select * from {{ ref("stg_superstore__orders") }}
),
customers as (
    select distinct
        customer_id,
        customer_name,
        segment
    from orders
),
customer_orders as (
    select 
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(distinct order_id) as number_of_orders
    from orders
    group by customer_id
),
final as (
    select
        customer_name,
        segment,
        first_order_date,
        most_recent_order_date,
        coalesce(number_of_orders, 0) as number_of_orders
    from customers left join customer_orders using(customer_id)
)
select
    row_number() over() as customer_id,
    customer_name,
    segment,
    first_order_date,
    most_recent_order_date,
    number_of_orders
from final