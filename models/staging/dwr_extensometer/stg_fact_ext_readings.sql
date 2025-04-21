{{ config(materialized="table") }}

with
    source as (
        select
            reading_timestamp::date as reading_date,
            round(avg(measurement)::numeric, 3) as daily_average_measurement
        from {{ source("dwr", "fact_extensometer_readings") }}
        where measurement is not null
        group by 1
    )

select *
from source
