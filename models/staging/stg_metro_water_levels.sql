{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('kcwa', 'metro_water_levels_post_2020') }}
)

select *
from source