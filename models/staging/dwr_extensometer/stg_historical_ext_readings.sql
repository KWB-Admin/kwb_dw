{{ config(materialized="table") }}

with
    source as (
        select reading_date, net_change as measurement
        from {{ source("dwr", "historical_extensometer_readings") }}
    )

select *
from source
