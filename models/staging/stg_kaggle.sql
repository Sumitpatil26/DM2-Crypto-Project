{{ config(materialized='view') }}

WITH raw AS (
    SELECT *
    FROM `dm-2-479815.DM2_Crypto.crypto_kaggle_raw`
),

renamed AS (
    SELECT
        name AS CoinName,

        -- ADD SYMBOL COLUMN (required for dim_coin)
        symbol AS Symbol,

        -- Convert date to TIMESTAMP
        CAST(date AS TIMESTAMP) AS DateTime,

        CAST(Open AS FLOAT64) AS Open,
        CAST(High AS FLOAT64) AS High,
        CAST(Low AS FLOAT64) AS Low,
        CAST(Close AS FLOAT64) AS Close,
        CAST(Volume AS FLOAT64) AS Volume,
        CAST(Marketcap AS FLOAT64) AS Marketcap
    FROM raw
),

cleaned AS (
    SELECT *
    FROM renamed
    WHERE Symbol IS NOT NULL      -- 🔥 IMPORTANT: prevents dim_coin errors
      AND DateTime IS NOT NULL
      AND Open IS NOT NULL
      AND High IS NOT NULL
      AND Low IS NOT NULL
      AND Close IS NOT NULL
      AND Volume IS NOT NULL
      AND Marketcap IS NOT NULL
)

SELECT *
FROM cleaned