{{ config(materialized='table', schema='silver') }}

select
  taxi_id,
  trip_date,
  count(*) as trips_count,
  sum(trip_hours) as work_hours,
  sum(tip_amount) as total_tips,
  sum(fare_amount) as total_fare,
  avg(trip_hours) as avg_trip_hours,
  avg(tip_amount) as avg_tip_amount
from {{ ref('stg_taxi_trips') }}
group by taxi_id, trip_date;
