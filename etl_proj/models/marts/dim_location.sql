with unique_items as(
    select distinct
        coalesce(location, 'UNKNOWN') as location
    from {{ ref('int_restore_prices') }}
)

select 
    md5(location) as location_id,
    location
from unique_items
