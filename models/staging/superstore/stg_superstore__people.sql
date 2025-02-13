select
    person as manager,
    region
from {{ source('superstore', 'people') }}