-- sql/staging/stg_time_series_stats.sql
-- Stage 1 (Staging): clean the raw `time_series_stats` reference table — NO joins.
--   * 0/1 number flags  -> proper BOOLEAN (true/false)

SELECT
hour,                        -- TIMESTAMP hour,     keep
transaction_count,           -- INT64 its a count,  keep
fraud_count,                 -- INT64 its a count,  keep
total_amount,                -- $ decimal,          keep
avg_amount,                  -- $ decimal,          keep
avg_ip_risk,                 -- decimal,            keep
fraud_rate,                  -- decimal,            keep
hour_of_day,                 -- INT64 its a count,  keep
day_of_week,                 -- INT64 its a count,  keep
is_weekend = 1 AS is_weekend -- 0/1 -> BOOL
FROM `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.time_series_stats`
