{{ config(materialized="view") }}

with
    max_date as (select max(reporting_date) as maxdate from {{ source("agol", "fact_grazing") }})

select agol.fact_grazing.*
from agol.fact_grazing, max_date
where reporting_date = maxdate
