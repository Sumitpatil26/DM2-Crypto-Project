{{ config(materialized='table') }}

WITH combined AS (

    -- Kaggle historical source
    SELECT
        UPPER(Symbol) AS Symbol,
        CoinName
    FROM {{ ref('stg_kaggle') }}

    UNION ALL

    -- CoinCap realtime source
    SELECT
        UPPER(Symbol) AS Symbol,
        CoinName
    FROM {{ ref('stg_coincap') }}
),

-- Deduplicate by picking ONE CoinName per Symbol
resolved AS (
    SELECT
        Symbol,
        ANY_VALUE(CoinName) AS CoinName
    FROM combined
    GROUP BY Symbol
)

SELECT *
FROM resolved
ORDER BY Symbol