-- sql/staging/stg_account_profiles.sql
-- Stage 1 (Staging): clean the raw `account_profiles` table on its own — NO joins.
-- What this fixes:
--   * 0/1 number flags  -> proper BOOLEAN (true/false)
--   * count columns stored as FLOAT (e.g. 49.0) -> INT64 (whole numbers)
--   * everything else kept as-is (genuine decimals, strings, ids)
-- Columns are kept in their original order so this file diffs cleanly against the raw table.

SELECT
    account_id,                                              -- STRING id,                  keep
    account_age_days,                                        -- whole days,                 keep (already integer-like)
    credit_limit,                                            -- $ decimal,                  keep
    home_country,                                            -- STRING,                     keep
    risk_score,                                              -- decimal,                    keep
    is_high_risk = 1                  AS is_high_risk,       -- 0/1 -> BOOL
    avg_txn_amount,                                          -- decimal,                    keep
    avg_monthly_txns,                                        -- decimal,                    keep
    has_2fa = 1                       AS has_2fa,            -- 0/1 -> BOOL
    account_type,                                            -- STRING (personal/business), keep
    CAST(total_transactions AS INT64) AS total_transactions, -- FLOAT -> INT (it's a count)
    total_amount,                                            -- $ decimal,                  keep
    avg_amount,                                              -- $ decimal,                  keep
    max_amount,                                              -- $ decimal,                  keep
    CAST(fraud_count AS INT64)        AS fraud_count,        -- FLOAT -> INT (it's a count) ⚠️
    fraud_amount,                                            -- $ decimal,                  keep
    pct_foreign,                                             -- ratio,                      keep
    avg_velocity,                                            -- decimal,                    keep
    CAST(unique_countries AS INT64)   AS unique_countries,   -- FLOAT -> INT (it's a count)
    CAST(unique_categories AS INT64)  AS unique_categories,  -- FLOAT -> INT (it's a count)
    avg_ip_risk,                                             -- decimal,                    keep
    fraud_rate,                                              -- decimal,                    keep  ⚠️ LEAKY (see note below)
    is_fraudster = 1                  AS is_fraudster        -- 0/1 -> BOOL                       ⚠️ LABEL / LEAKY
FROM `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.account_profiles`

-- ⚠️ Leakage note for the ML stage (not now):
--   [ is_fraudster ] is the target label, and `fraud_rate`/`fraud_count`/`fraud_amount` are
--   derived from knowing the outcome. Keep them in staging (they're useful for DA/exploration),
--   but EXCLUDE them from the model's input features so the model can't "cheat".
