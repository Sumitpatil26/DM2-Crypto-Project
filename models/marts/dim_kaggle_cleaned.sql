{{ config(materialized='table') }}

WITH base AS (
    SELECT *
    FROM {{ ref('stg_kaggle') }}
),

dedup AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY CoinName, DateTime
            ORDER BY DateTime
        ) AS rn
    FROM base
),

filtered AS (
    SELECT *
    FROM dedup
    WHERE rn = 1
)

SELECT
    CoinName,
    DateTime,
    Open,
    High,
    Low,
    Close,
    Volume,
    Marketcap
FROM filtered
ORDER BY CoinName, DateTime