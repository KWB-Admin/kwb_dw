{{ config(materialized='table') }}

with source as (
    select *
    from {{ source('raw', 'historical_water_quality_lab_results') }}
)

select *
from source