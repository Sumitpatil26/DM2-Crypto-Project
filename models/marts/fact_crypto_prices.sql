with kaggle as (
    select * from {{ ref('stg_kaggle') }}
),

coincap as (
    select * from {{ ref('stg_coincap') }}
),

unioned as (
    select * from kaggle
    union all
    select * from coincap
)

select *
from unioned
order by Symbol, DateTime