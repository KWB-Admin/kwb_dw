{{ config(materialized="view") }}

with
    water_year as (
        select
            min(water_calendar_date) as water_year_start,
            max(water_calendar_date) as water_year_end
        from dev.water_year

    )

select gaugeid, round(sum(measurement::numeric), 2) as water_year_total
from dev.fact_rainfall, water_year
where reading_date >= water_year_start and reading_date <= water_year_end
group by gaugeid
order by gaugeid
