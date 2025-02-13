select 
    order_id 
from {{ ref('stg_superstore__orders') }}
where quantity < 0