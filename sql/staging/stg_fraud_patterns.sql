-- sql/staging/stg_fraud_patterns.sql
-- Stage 1 (Staging): clean the raw `fraud_patterns` reference table — NO joins.
-- raw table schema checked all data types correct no amenment needed
-- No casts needed (types already correct). Columns listed explicitly (not SELECT *)
-- so this file documents the table's shape and stays stable if the raw table changes.

SELECT
fraud_pattern,
description,
transaction_count,
fraud_share_pct,
avg_amount,
median_amount,
pct_night_0_5,
pct_foreign,
pct_card_not_present,
avg_velocity_1h,
avg_ip_risk,
pct_no_2fa
FROM `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.fraud_patterns`
