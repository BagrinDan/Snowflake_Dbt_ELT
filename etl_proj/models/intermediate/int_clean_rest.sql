WITH raw_nullified AS (
    SELECT
        transaction_id,
        items,
        TRY_TO_DOUBLE(price_per_unit) AS price_per_unit,
        TRY_TO_DOUBLE(quantities)     AS quantities,
        TRY_TO_DOUBLE(total_spent)    AS total_spent,
        NULLIF(TRIM(payment_method), 'None') AS payment_method,
        NULLIF(TRIM(location), 'None')       AS location,
        NULLIF(TRIM(transaction_date), 'None') AS transaction_date
    FROM {{ ref('int_restore_prices') }}
    WHERE items NOT IN ('UNKNOWN', 'ERROR')
),

clean_types AS (
    SELECT
        transaction_id,
        items,
        price_per_unit,
        quantities,
        total_spent,
        
        CASE
            WHEN payment_method IS NULL OR payment_method = 'ERROR'
                THEN 'UNKNOWN'
            ELSE payment_method
        END AS payment_method,

        CASE 
            WHEN location IS NULL OR location = 'ERROR' 
                THEN 'UNKNOWN'
            ELSE location
        END AS location,

        TRY_CAST(transaction_date AS DATE)  AS transaction_date
    FROM raw_nullified
)

SELECT
    transaction_id,
    items,
    price_per_unit,
    quantities,
    total_spent,
    payment_method,
    location,
    COALESCE(CAST(transaction_date AS VARCHAR), 'UNKNOWN') AS transaction_date
FROM clean_types