{{ config(materialized="view") }}

with
    grazing_numbers_raw as (
        select reporting_date, sum(number_of_animal_units) as "total"
        from facilities_ops.fact_grazing
        group by 1
        order by 1 desc
        limit 12
    ),

    grazing_numbers_rectified as (
        select
            case
                when
                    reporting_date
                    - lag(reporting_date, 1) over (order by reporting_date)
                    < 7
                then lag(reporting_date, 1) over (order by reporting_date)
                else reporting_date
            end as "new_date",
            total
        from grazing_numbers_raw
    )

select new_date as reporting_date, sum(total) as total
from grazing_numbers_rectified
group by 1
