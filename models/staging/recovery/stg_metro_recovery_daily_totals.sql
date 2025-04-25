with
    source as (
        select distinct
            reading_date,
            total_cfs_per_day_for_all_wells,
            total_af_per_day_all_wells_rounded,
            total_af_per_day_all_wells_unrounded
        from {{ source("kcwa", "metro_recovery_data") }}
        where total_cfs_per_day_for_all_wells > 0
    )

select *
from source
