with unique_items as(
    select distinct
        coalesce(items, 'UNKNOWN') as items
    from {{ ref('int_clean_rest') }}
)

select
    md5(items) as item_id,
    items
from unique_items