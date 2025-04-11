{{ config(materialized="view") }}

with
    grazing as (select * from {{ source("agol", "fact_grazing") }}),

    max_date as (select max(reporting_date) as maxdate from grazing)

select grazing.*
from grazing, max_date
where reporting_date = maxdate
