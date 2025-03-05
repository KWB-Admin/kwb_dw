{{ config(materialized="view") }}

with
    max_date as (select max(reporting_date) as maxdate from facilities_ops.fact_grazing)

select facilities_ops.fact_grazing.*
from facilities_ops.fact_grazing, max_date
where reporting_date = maxdate
