{{ config(materialized='table', schema='gold') }}

with windowed_shifts as (
  select *
  from {{ ref('int_shifts') }}
  where shift_start >= date_add(current_date(), interval -3 month)
),

ordered as (
  select *,
    lag(shift_end) over (partition by taxi_id order by shift_start) as prev_shift_end
  from windowed_shifts
),

with_breaks as (
  select *,
    timestamp_diff(shift_start, prev_shift_end, minute) / 60.0 as hours_since_prev_shift
  from ordered
),

features as (
  select
    taxi_id,
    sum(shift_work_hours) as total_work_hours_3m,
    countif(shift_work_hours >= 10) as long_shifts_3m,
    countif(hours_since_prev_shift < 8) as insufficient_breaks_3m
  from with_breaks
  group by taxi_id
)

select *
from features
order by total_work_hours_3m desc
limit 100;