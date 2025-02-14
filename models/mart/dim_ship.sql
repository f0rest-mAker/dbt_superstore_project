with
ships as (
    select
        ship_mode,
        ship_date - order_date as shipping_days
    from {{ ref('stg_superstore__orders') }}
),
final as (
    select
        ship_mode,
        avg(shipping_days) as avg_shipping_days
    from ships
    group by ship_mode
)
select 
    row_number() over() as ship_mode_id,
    ship_mode,
    avg_shipping_days
from final