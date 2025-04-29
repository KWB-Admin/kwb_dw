select
    extract(year from reading_date) as year,
    round(((sum(cfs) / 43560) * 86400 * .94)::numeric, 2) as daily_sum
from {{ ref("stg_metro_recovery_data_daily_cfs_per_well") }}
group by 1
