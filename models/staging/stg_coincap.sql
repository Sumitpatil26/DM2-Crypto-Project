with raw as (
    select *
    from {{ source('crypto', 'crypto_coincap_raw') }}
),

-- Add unique row fingerprint
deduped as (
    select
        *,
        row_number() over (
            partition by Symbol, DateTime
            order by DateTime desc 
        ) as rn
    from raw
)

-- Only keep one record per Symbol+DateTime
select
    CoinName,
    Symbol,
    DateTime,
    Open,
    High,
    Low,
    Close,
    Volume,
    Marketcap
from deduped
where rn = 1