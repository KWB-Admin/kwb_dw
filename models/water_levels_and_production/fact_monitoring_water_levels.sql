{{ config(materialized="table") }}

with
    mon_well as (
        select
            state_well_num as state_well_number, ground_level, top_screen, bottom_screen
        from {{ source("agol", "wells") }}
        where well_type = 'Monitoring' and status = 'Active'
    ),

    metro_data as (select * from {{ ref("stg_metro_gw_levels_post_2020") }}),

    sems_data as (select * from {{ ref("stg_historical_sems_gw_levels_pre_2020") }}),

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
