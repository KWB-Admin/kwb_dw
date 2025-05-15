{{ config(materialized="table") }}

with
    historical_digitized_results as (
        select *, 2 as rank from {{ ref("stg_historical_lab_results") }}
    ),

    historical_eurofins_pdf_results as (
        select *, 3 as rank from {{ ref("stg_historical_eurofins_results_from_pdfs") }}
    ),

    bsk_results as (select *, 1 as rank from {{ ref("stg_bsk_lab_results") }}),

    complete_wq_data as (
        select *
        from historical_digitized_results
        union
        select *
        from historical_eurofins_pdf_results
        union
        select *
        from bsk_results
    ),

    final as (
        select
            *,
            rank() over (
                partition by state_well_number, sample_date, analyte
                order by rank
            ) as src_rank
        from complete_wq_data
    )

select
    state_well_number,
    sample_date,
    sample_time,
    lab,
    lab_sample_id,
    analyte,
    qualifier,
    result,
    qualitative_result,
    units,
    minimum_reportable_limit
from final
where src_rank = 1
