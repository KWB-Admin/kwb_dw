with
    source as (
        select
            reading_date,
            total_cfs_per_report as total_monthly_cfs,
            round(total_af_per_report_rounded * .94,0) as total_acre_feet_rounded,
            round((total_af_per_report_unrounded * .94)::numeric,2) as total_acre_feet_unfounded,
            row_number() over (
                partition by
                    extract(month from reading_date), extract(year from reading_date)
                order by reading_date desc
            ) as row_num
        from {{ source("kcwa", "metro_recovery_data") }}
    )

select
    reading_date, total_monthly_cfs, total_acre_feet_rounded, total_acre_feet_unfounded
from source
where row_num = 1 and total_monthly_cfs > 0
order by 1
