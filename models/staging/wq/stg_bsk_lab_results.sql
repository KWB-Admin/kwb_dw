{{ config(materialized="table") }}

with
    source as (
        select
            state_well_number,
            sample_timestamp::date as sample_date,
            sample_timestamp::time as sample_time,
            lab,
            sample_id,
            analyte,
            null as qualifier,
            case when result not like 'ND' then result end as result,
            case when result like 'ND' then result end as qualitative_result,
            units,
            minimum_detectable_limit
        from {{ source("water_quality", "bsk_lab_results") }}
        where good_data_flag
    )

select
    state_well_number,
    sample_date,
    sample_time,
    lab,
    sample_id,
    analyte,
    qualifier,
    result::real,
    qualitative_result,
    units,
    minimum_detectable_limit
from source
