with unique_items as (
    select distinct
        COALESCE(CAST(transaction_date AS VARCHAR), 'UNKNOWN') AS transaction_date
    from {{ ref('int_clean_rest') }}
)
select
    md5(transaction_date) as transaction_date_id,
    transaction_date
from unique_items