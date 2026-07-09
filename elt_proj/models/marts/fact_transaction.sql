{{
    config(
        materialized='table',
        schema='GOLD'
    )
}}

with source as (
    select * from {{ ref('int_clean_rest') }} 
),

joined as (
    select
        s.transaction_id,

        di.item_id,
        dp.payment_method_id,
        dl.location_id,
        dd.transaction_date_id,

        s.price_per_unit,
        s.quantities,
        s.total_spent

    from source s

    left join {{ ref('dim_items') }} di
        on s.items = di.items

    left join {{ ref('dim_payment') }} dp
        on s.payment_method = dp.payment_method

    left join {{ ref('dim_location') }} dl
        on s.location = dl.location

    left join {{ ref('dim_transaction_date') }} dd
        on CAST(s.transaction_date AS VARCHAR) = dd.transaction_date
)

select * from joined