with
    source as (
        select
            well_number,
            reading_date,
            total_cfs_per_well_per_report as total_monthly_cfs_per_well,
            row_number() over (
                partition by
                    well_number,
                    extract(month from reading_date),
                    extract(year from reading_date)
                order by reading_date desc
            ) as row_num
        from {{ source("kcwa", "metro_recovery_data") }}
    )

select well_number, reading_date, total_monthly_cfs_per_well
from source
where row_num = 1 and total_monthly_cfs_per_well > 0
order by 1, 2
