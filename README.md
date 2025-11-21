# chicago-taxi-trips-dbt
This project demonstrates end‑to‑end data engineering skills using the Chicago Taxi Trips public dataset on BigQuery.

This project follows the Medallion Architecture pattern. 
The Bronze layer is represented by the raw Chicago Taxi Trips dataset already available in BigQuery’s public data, so no SQL files are needed in the repo. 
The Silver layer contains staging and intermediate models that clean, standardize, and enrich the raw data for consistency and reusability. 
The Gold layer holds curated mart models that answer specific business questions (e.g., top tip earners, overworkers, holiday impacts) and serve as the source for dashboards in Looker Studio.

📂 chicago-taxi-trips-pipeline
├── 📂 models
│   ├── 📂 bronze
│   │   └── (no SQL files – raw data lives in BigQuery public dataset)
│   │       └── bigquery-public-data.chicago_taxi_trips.taxi_trips
│   │
│   ├── 📂 silver
│   │   ├── stg_taxi_trips.sql              # cleans & standardizes raw data
│   │   ├── int_shifts.sql                  # builds driver shift logic
│   │   └── int_driver_daily_metrics.sql    # aggregates daily driver metrics
│   │
│   ├── 📂 gold
│   │   ├── mart_tip_earners_3m.sql         # top 100 tip earners (last 3 months)
│   │   ├── mart_overworkers_3m.sql         # drivers with long shifts & short breaks
│   │   └── mart_holiday_impact.sql         # holiday vs non-holiday trip volumes
│   │
│   └── 📂 macros                           # reusable SQL functions (optional)
│
├── 📂 seeds
│   └── us_public_holidays.csv              # holiday reference data
│
├── 📂 tests                                # custom tests (optional)
│
├── profiles.yml                            # dbt/connection config
├── README.md                               # project documentation
└── .github/workflows/deploy.yml            # CI/CD pipeline config
