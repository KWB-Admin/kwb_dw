{{ config(materialized="table") }}

with
    source as (
        select * from {{ source("water_quality", "eurofins_lab_results_from_pdfs") }}
    )

select *
from source
