{{ config(materialized="table") }}

with
    source as (
        select
            state_well_number,
            water_levels_read_date as reading_date,
            case
                when dtgw > 400 then null when dtgw < 0 then null else dtgw
            end as depth_to_water,
            'sems' as source
        from {{ source("kcwa", "historical_sems_water_levels_pre_2020") }}
        where water_levels_read_date < cast('2019-01-02' as date)
    )

select *
from source
