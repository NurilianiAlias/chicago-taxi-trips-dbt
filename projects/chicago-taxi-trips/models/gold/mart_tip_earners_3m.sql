{{ config(materialized='table', schema='gold') }}

with windowed as (
  select *
  from {{ ref('stg_taxi_trips') }}
  where trip_start_timestamp >= date_add(current_date(), interval -3 month)
),

agg as (
  select
    taxi_id,
    sum(tip_amount) as total_tips_3m,
    sum(fare_amount) as total_fare_3m,
    count(*) as trips_3m,
    sum(trip_hours) as work_hours_3m,
    avg(tip_amount) as avg_tip_per_trip_3m
  from windowed
  group by taxi_id
),

ranked as (
  select *,
    rank() over (order by total_tips_3m desc) as tip_rank
  from agg
)

select *
from ranked
where tip_rank <= 100;