{{ config(materialized='table') }}

with wq_data as (
    select 
        state_well_number,
        sample_id,
        sample_date,
        test_method,
        lab,
        analyte,
        lab_result,
        units,
        maximum_contaminant_limit,
        lab_comment
    from stg_fact_historical_water_quality_lab_results
),

results_recast as (
    select 
        state_well_number,
        sample_id,
        sample_date,
        test_method,
        lab,
        analyte,
        lab_result,
        units,
        maximum_contaminant_limit,
        lab_comment,
        case
            when lab_result = 'ND' then 0.0
            when lab_result like '<%' then cast(trim(translate(lab_result,'<','')) as real)
            when lab_result = 'No Obs Odor' then null
            else cast(lab_result as real)
        end as quantitative_result
    from wq_data
)

select 
    state_well_number,
    sample_id,
    sample_date,
    test_method,
    lab,
    analyte,
    lab_result as raw_lab_result,
    quantitative_result,
    units,
    maximum_contaminant_limit,
    lab_comment
from results_recast