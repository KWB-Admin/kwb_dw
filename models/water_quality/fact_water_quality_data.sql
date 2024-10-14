{{ config(materialized='table') }}

with hist_digitized_data as (
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
    from {{ ref('stg_historical_water_quality_lab_results') }}
),

bsk_results as (
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
    from {{ ref('stg_bsk_lab_results') }}
),

eurofins_pdf_results as (
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
        
    from {{ ref('stg_eurofins_lab_results_from_pdf') }}
),

wq_data as (
    select * from hist_digitized_data
    union
    select * from bsk_results
    union
    select * from eurofins_pdf_results
),

results_recast as (
    select 
        state_well_number,
        sample_id,
        sample_date,
        analysis_method,
        lab,
        analyte,
        result,
        units,
        min_detectable_limit,
        max_report_limit,
        case
            when result = 'ND' then 0.0
            when result like '<%' then cast(trim(translate(result,'<','')) as real)
            when result = 'No Obs Odor' then null
            else cast(result as real)
        end as quantitative_result
    from wq_data
),

final as (
    select 
        state_well_number,
        sample_id,
        sample_date,
        analysis_method,
        lab,
        analyte,
        result as raw_lab_result,
        quantitative_result,
        units,
        min_detectable_limit,
        max_report_limit as maximum_contaminant_limit,
        row_number() over(partition by state_well_number,sample_date,analyte) as row_num
    from results_recast
)

select 
    state_well_number,
    sample_id,
    sample_date,
    analysis_method,
    lab,
    analyte,
    raw_lab_result,
    quantitative_result,
    units,
    min_detectable_limit,
    maximum_contaminant_limit
from final
where row_num = 1