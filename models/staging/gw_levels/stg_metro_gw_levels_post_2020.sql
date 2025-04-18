{{ config(materialized="table") }}

with
    source as (
        select
            state_well_number,
            reading_date,
            case
                when depth_to_water > 400 then null else depth_to_water
            end as depth_to_water,
            'metro' as source
        from {{ source("kcwa", "metro_water_levels_post_2020") }}
    )

select *
from source
