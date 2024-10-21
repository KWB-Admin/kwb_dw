{{ config(materialized="table") }}

with
    source as (
        select * from {{ source("kcwa", "historical_sems_water_levels_pre_2020") }}
    )

select *
from source
