select 
    order_id 
from {{ ref('stg_superstore__orders') }}
where discount > 1 or discount < 0