with
    source as (
        select well_number, reading_date, cfs
        from {{ source("kcwa", "metro_recovery_data") }}
        where cfs > 0
    )

select *
from source
