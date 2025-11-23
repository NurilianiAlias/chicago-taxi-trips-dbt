{{ config(materialized='table', schema='silver') }}

with ordered as (
  select
    taxi_id,
    trip_start_timestamp,
    trip_end_timestamp,
    trip_hours,
    tip_amount,
    fare_amount,
    timestamp_diff(
      trip_start_timestamp,
      lag(trip_end_timestamp) over (partition by taxi_id order by trip_start_timestamp),
      minute
    ) / 60.0 as hours_since_prev
  from {{ ref('stg_taxi_trips') }}
),

shift_flag as (
  select *,
    case when hours_since_prev is null or hours_since_prev >= 8 then 1 else 0 end as new_shift
  from ordered
),

shift_ided as (
  select *,
    sum(new_shift) over (partition by taxi_id order by trip_start_timestamp) as shift_seq
  from shift_flag
)

select
  taxi_id,
  shift_seq,
  min(trip_start_timestamp) as shift_start,
  max(trip_end_timestamp) as shift_end,
  sum(trip_hours) as shift_work_hours,
  count(*) as trips_in_shift,
  sum(tip_amount) as shift_tip_amount,
  sum(fare_amount) as shift_fare_amount
from shift_ided
group by taxi_id, shift_seq;
