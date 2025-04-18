with source as (
    select * from {{ source('dwr', 'fact_extensometer_readings') }}
)

select *
from source