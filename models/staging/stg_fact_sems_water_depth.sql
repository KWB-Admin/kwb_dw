{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('raw', 'historical_water_depth_values_sems_pre_2020') }}
)

select *
from source