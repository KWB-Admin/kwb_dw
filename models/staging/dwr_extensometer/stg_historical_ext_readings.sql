with source as (
    select * from {{ source('dwr', 'historical_extensometer_readings') }}
)

select *
from source