{{ config(materialized="table") }}

with
    source as (
        select
            state_well_number,
            sample_id,
            sample_date,
            test_method as analysis_method,
            lab,
            analyte,
            lab_result as result,
            units,
            cast(null as real) as min_detectable_limit,
            cast(maximum_contaminant_limit as real) as max_report_limit
        from {{ source("water_quality", "historical_water_quality_lab_results") }}
    )

select *
from source
