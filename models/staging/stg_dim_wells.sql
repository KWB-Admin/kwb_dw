{{ config(materialized="view") }}

with source as (select * from {{ source("agol", "wells") }})

select *
from source
