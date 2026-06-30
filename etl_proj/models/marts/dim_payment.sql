with unique_items as(
    select distinct
        coalesce(payment_method, 'UNKNOWN') as payment_method
    from {{ ref('int_clean_rest')}}
)

select
    md5(payment_method) as payment_method_id,
    payment_method
from unique_items