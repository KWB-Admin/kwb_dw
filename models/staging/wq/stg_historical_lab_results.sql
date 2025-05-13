{{ config(materialized="table") }}

with
    source as (
        select
            state_well_number,
            lab,
            collection_date,
            collection_time,
            analyte,
            qualifier,
            result,
            qualitative_result,
            units,
            minimum_reportable_limit,
            maximum_contaminant_limit,
            lab_sample_id
        from {{ source("water_quality", "historical_water_quality_lab_results") }}
        where bad_data_flag is null
    )

select *
from source
