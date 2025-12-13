{{ config(
    materialized = 'table'
) }}

WITH base_prices AS (

    SELECT
        Symbol,
        CoinName,
        DateTime,
        Close
    FROM {{ ref('fact_crypto_prices') }}

),

metrics AS (

    SELECT
        Symbol,
        CoinName,
        DateTime,
        Close,

        -- Simple Moving Average (7)
        AVG(Close) OVER (
            PARTITION BY Symbol
            ORDER BY DateTime
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS SMA_7,

        -- Simple Moving Average (30)
        AVG(Close) OVER (
            PARTITION BY Symbol
            ORDER BY DateTime
            ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) AS SMA_30,

        -- Exponential Moving Average (EMA 12)
        AVG(Close) OVER (
            PARTITION BY Symbol
            ORDER BY DateTime
            ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
        ) AS EMA_12

    FROM base_prices
)

SELECT *
FROM metrics
ORDER BY Symbol, DateTime