{{ config(materialized="table") }}

with
    hist_data as (
        select reading_date, measurement from {{ ref("stg_historical_ext_readings") }}
    ),

    hydrovu_data as (
        select reading_date, daily_average_measurement as measurement
        from {{ ref("stg_fact_ext_readings") }}
    ),

    ext_readings as (
        select *
        from hist_data

        union

        select *
        from hydrovu_data
    )

select reading_date, measurement
from ext_readings
order by 1
