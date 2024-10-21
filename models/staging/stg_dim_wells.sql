{{ config(materialized="view") }}

with source as (select * from {{ source("facilities_ops", "wells") }})

select *
from source
