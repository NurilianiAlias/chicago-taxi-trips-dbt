{{ config(materialized='table', schema='gold') }}

with holidays as (
  select date(holiday_date) as holiday_date
  from {{ ref('us_public_holidays') }}
),

daily as (
  select
    trip_date,
    count(*) as trips_count
  from {{ ref('stg_taxi_trips') }}
  group by trip_date
),

joined as (
  select
    d.trip_date,
    d.trips_count,
    case when h.holiday_date is not null then true else false end as is_holiday
  from daily d
  left join holidays h on d.trip_date = h.holiday_date
)

select
  is_holiday,
  avg(trips_count) as avg_trips_per_day
from joined
group by is_holiday;
