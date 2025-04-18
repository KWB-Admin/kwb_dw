{{ config(materialized="table") }}

with
    source as (
        select
            state_well_number,
            null as sample_id,
            sample_date,
            null as analysis_method,
            'Eurofins' as lab,
            analyte,
            result,
            units,
            min_detectable_limit,
            max_report_limit
        from {{ source("water_quality", "eurofins_lab_results_from_pdfs") }}
    )

select *
from source
