{{ config(materialized="table") }}

with
    source as (
        select
            state_well_number,
            sample_date,
            sample_time,
            'Eurofins' as lab,
            null as sample_id,
            analyte,
            null as qualifier,
            result,
            null as qualitative_result,
            units,
            min_detectable_limit
        from
            {{
                source(
                    "water_quality",
                    "historical_eurofins_water_quality_results_from_pdfs",
                )
            }}
        where good_data_flag
    )

select *
from source
