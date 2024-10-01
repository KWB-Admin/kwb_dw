{{ config(materialized='view') }}

with source as (
    select *
    from {{ source('raw', 'wells') }}
)

select *
from source