{{ config(materialized="table") }}

with source as (select * from {{ source("water_quality", "bsk_lab_results") }})

select *
from source
