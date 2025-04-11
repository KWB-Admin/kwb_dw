{{ config(materialized="table") }}

with
    mon_well as (
        select
            state_well_num as state_well_number, ground_level, top_screen, bottom_screen
        from {{ source("agol", "wells") }}
        where well_type = 'Monitoring' and status = 'Active'
    ),

    metro_data as (
        select
            state_well_number,
            reading_date,
            case
                when depth_to_water > 400 then null else depth_to_water
            end as depth_to_water,
            'metro' as source
        from {{ source("kcwa", "metro_water_levels_post_2020") }}
    ),

    sems_data as (
        select
            state_well_number,
            water_levels_read_date as reading_date,
            case
                when dtgw > 400 then null when dtgw < 0 then null else dtgw
            end as depth_to_water,
            'sems' as source
        from {{ source("kcwa", "historical_sems_water_levels_pre_2020") }}
        where water_levels_read_date < cast('2019-01-02' as date)
    ),

    unioned_data as (
        select *
        from metro_data
        union
        select *
        from sems_data
    ),

    final as (
        select
            mon_well.state_well_number,
            cast(reading_date as date) as reading_date,
            mon_well.ground_level,
            depth_to_water,
            coalesce(mon_well.ground_level - depth_to_water) as ground_water_elevation,
            source
        from mon_well
        left join
            unioned_data on mon_well.state_well_number = unioned_data.state_well_number
    )

select *
from final
order by state_well_number, reading_date desc
