with delivers as (
    select 
        country,
        state,
        city,
        postal_code,
        region,
        order_id 
    from {{ ref('stg_superstore__orders') }}
)
select
    row_number() over() as place_id,
    country,
    state,
    city,
    postal_code,
    region,
    count(distinct order_id) as number_of_orders
from delivers
group by 2,3,4,5,6