{{ config(materialized="table") }}

with
    survey_data as (
        select gaugeid, reading_date, measurement
        from facilities_ops.fact_rainfall_survey
    ),

    field_maps_data as (
        select gaugeid, reading_date, measurement
        from facilities_ops.historic_field_maps_rainfall
    ),

    rain_data_union as (
        select *
        from survey_data
        union
        select *
        from field_maps_data
    )

select *
from rain_data_union
order by reading_date, gaugeid
