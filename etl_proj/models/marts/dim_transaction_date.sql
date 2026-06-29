with unique_items as(
    select distinct
        coalesce(transaction_date, 'UNKNOWN') as transaction_date
    from {{ ref('int_restore_prices') }}
)

select
    md5(transaction_date) as transaction_date_id,
    transaction_date
from unique_items