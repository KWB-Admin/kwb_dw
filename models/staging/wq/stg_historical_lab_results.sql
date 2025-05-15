{{ config(materialized="table") }}

with
    source as (
        select
            state_well_number,
            collection_date::date as sample_date,
            collection_time::time as sample_time,
            lab,
            lab_sample_id,
            analyte,
            qualifier,
            result,
            qualitative_result,
            units,
            minimum_reportable_limit
        from {{ source("water_quality", "historical_water_quality_lab_results") }}
        where good_data_flag
    )

select *
from source
