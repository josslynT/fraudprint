-- sql/staging/stg_transactions.sql
-- Stage 1 (Staging): clean the raw `transactions` table (~1M rows) — NO joins.
--   * six 0/1 flags -> BOOL
--   * mcc_code INT -> STRING (it's a categorical code, not a number)
--   * `timestamp` renamed -> txn_ts (avoid the SQL type keyword)

SELECT
    transaction_id,
    account_id,
    timestamp                    AS txn_ts,         -- renamed (was `timestamp`, a type keyword)
    hour_of_day,
    day_of_week,
    is_weekend = 1               AS is_weekend,     -- 0/1 -> BOOL
    amount,
    merchant_category,
    CAST(mcc_code AS STRING)     AS mcc_code,       -- INT -> STRING (categorical code)
    merchant_country,
    card_present = 1             AS card_present,   -- 0/1 -> BOOL
    device_type,
    device_known = 1             AS device_known,   -- 0/1 -> BOOL
    ip_risk_score,
    is_foreign_txn = 1           AS is_foreign_txn, -- 0/1 -> BOOL
    time_since_last_s,
    velocity_1h,
    amount_vs_avg_ratio,
    account_age_days,
    has_2fa = 1                  AS has_2fa,        -- 0/1 -> BOOL
    credit_limit,
    is_fraud = 1                 AS is_fraud,       -- 0/1 -> BOOL  ⚠️ THIS IS THE LABEL
    fraud_pattern                                   --              ⚠️ LEAKY (see note below)
FROM `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.transactions`

-- ⚠️ Leakage note for the ML stage (not now): critical
-- [ fraud_pattern ] is leaky. It's blank for legitimate transactions and only filled in for fraud ( it's empty 'null' in every sample row — those are all non-fraud).
-- It is basically reveals [ is_fraud ].
-- Keep it in staging for exploration, but it joins [ fraud_rate/is_fraudster ] on the exclude-from-features list.
