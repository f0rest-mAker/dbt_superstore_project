with
orders as (
    select * from {{ ref('stg_superstore__orders') }}
),
returns as (
    select * from {{ ref('stg_superstore__returns') }}
),
orders_with_returns as (
    select 
        product_id,
        product_name,
        category,
        subcategory,
        quantity,
        coalesce(returned, 'No') as returned
    from orders left join returns using(order_id)
),
products as (
    select distinct
        product_id,
        product_name,
        category,
        subcategory
    from orders_with_returns
),
products_orders as (
    select 
        product_id,
        sum(case when returned = 'No' then quantity else 0 end) as product_sold_count,
        sum(case when returned = 'Yes' then quantity else 0 end) as product_returned_count
    from orders_with_returns
    group by 1
),
final as (
    select
        product_id,
        product_name,
        category,
        subcategory,
        coalesce(product_sold_count, 0) as product_sold_count,
        coalesce(product_returned_count, 0) as product_returned_count
    from products left join products_orders using(product_id)
)
select 
    row_number() over() as product_id,
    product_name,
    category,
    subcategory,
    product_sold_count,
    product_returned_count
from final