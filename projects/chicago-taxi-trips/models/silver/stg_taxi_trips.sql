{{ config(materialized='view', schema='silver') }}

with source as (
  select
    taxi_id,
    trip_start_timestamp,
    trip_end_timestamp,
    safe_cast(tips as float64) as tip_amount,
    safe_cast(fare as float64) as fare_amount,
    safe_cast(trip_miles as float64) as trip_miles,
    payment_type,
    company
  from `bigquery-public-data.chicago_taxi_trips.taxi_trips`
),

clean as (
  select
    taxi_id,
    trip_start_timestamp,
    trip_end_timestamp,
    tip_amount,
    fare_amount,
    trip_miles,
    payment_type,
    company,
    timestamp_diff(trip_end_timestamp, trip_start_timestamp, minute) / 60.0 as trip_hours,
    date(trip_start_timestamp) as trip_date
  from source
  where taxi_id is not null
    and trip_start_timestamp is not null
    and trip_end_timestamp >= trip_start_timestamp
    and tip_amount >= 0
    and fare_amount >= 0
)

select * from clean;
