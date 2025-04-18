{{ config(materialized="table") }}

with
    source as (
        select
            state_well_number,
            sample_id,
            sample_date,
            analysis_method,
            'BSK' as lab,
            analyte,
            result,
            units,
            min_detectable_limit,
            max_report_limit
        from {{ source("water_quality", "bsk_lab_results") }}
    )

select *
from source
