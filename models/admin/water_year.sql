{{ config(materialized="view") }}

with
    water_start_end as (
        select
            case
                when extract(month from current_date) between 1 and 9
                then
                    concat(
                        cast((extract(year from current_date) - 1) as text), '-10-01'
                    )
                else concat(extract(year from current_date)::text, '-10-01')
            end as water_year_start,
            case
                when extract(month from current_date) between 1 and 9
                then concat(extract(year from current_date)::text, '-09-30')
                else
                    concat(
                        cast((extract(year from current_date) + 1) as text), '-09-30'
                    )
            end as water_year_end
    ),

    series as (
        select *
        from
            generate_series(
                (select water_year_start from water_start_end)::date,
                (select water_year_end from water_start_end)::date,
                '1 day'::interval
            )
    )

select generate_series::date as water_calendar_date
from series
