
# Chicago Taxi Trips Dataform Pipeline

This Dataform pipeline processes the Chicago Taxi Trips public dataset to derive insights and create data marts for analysis.

## Pipeline Structure

The pipeline is structured into three main layers:

1.  **Declarations**: Declares the raw data source.
2.  **Silver Layer**: Cleans, prepares, and enriches the raw data.
3.  **Gold Layer**: Applies business logic to create data marts for specific use cases.

### 1. Data Source Declaration

-   `definitions/declarations/chicago_taxi_trips.sqlx`: Declares the `chicago_taxi_trips` table from the `bigquery-public-data` project as the raw data source for this pipeline.

### 2. Silver Layer

The silver layer focuses on data cleaning, preparation, and feature engineering.

-   `definitions/create_silver_dataset.sqlx`: An operation that creates the `silver` dataset in the BigQuery project if it does not already exist.
-   `definitions/silver/silver_taxi_trips.sqlx`: A view that performs initial data cleaning and preparation on the raw taxi trip data. This includes:
    -   Casting data types.
    -   Calculating trip duration (`trip_hours`) and extracting the `trip_date`.
    -   Filtering out invalid or incomplete records.
-   `definitions/silver/daily_summary.sqlx`: A table that provides a daily summary of each taxi's activity, including the number of trips, total work hours, and earnings.
-   `definitions/silver/driver_shifts.sqlx`: A table that identifies and calculates driver shifts. A new shift is considered to start after a break of 8 or more hours.
-   `definitions/silver/us_holidays.sqlx`: A table containing a list of US public holidays for the year 2023, used for holiday impact analysis.

### 3. Gold Layer

The gold layer contains the final data marts, which are designed for business intelligence and analytical purposes.

-   `definitions/gold/mart_trip_earners_3m.sqlx`: This table identifies the top 100 taxi drivers who have earned the most in tips over the last 3 months.
-   `definitions/gold/mart_overwokers_3m.sqlx`: This table identifies the top 100 most overworked drivers based on their total work hours in the last 3 months. It also includes flags for drivers who have worked long shifts (10 hours or more) or have had insufficient breaks (less than 8 hours) between shifts.
-   `definitions/gold/mart_holiday_impact.sqlx`: This table analyzes the impact of public holidays on the number of taxi trips by comparing the average number of trips on holidays versus non-holidays.

## How to Run the Pipeline

To run this Dataform pipeline, you can either trigger a manual run from the Dataform UI in the Google Cloud Console or set up a schedule for automated runs.
