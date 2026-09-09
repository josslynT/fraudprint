-- sql/intermediate/int_transactions_enriched.sql
-- Stage 2 (Intermediate): enrich each transaction with its account's profile.
-- Base = stg_transactions (the FACT, ~1M rows). LEFT JOIN stg_account_profiles on account_id
-- (many txns -> one account). Account cols prefixed acct_ so they never collide with txn cols.

SELECT
    t.*,                                                -- all transaction columns (the fact)

    -- Account context (from stg_account_profiles) , prefixed acct_
    ap.home_country        AS acct_home_country    ,
    ap.account_type        AS acct_account_type    ,
    ap.risk_score          AS acct_risk_score      ,
    ap.is_high_risk        AS acct_is_high_risk    ,
    ap.credit_limit        AS acct_credit_limit    ,     -- account-level (≠ txn credit_limit)
    ap.account_age_days    AS acct_account_age_days,     -- account-level (≠ txn account_age_days)
    ap.avg_txn_amount      AS acct_avg_txn_amount  ,
    ap.avg_monthly_txns    AS acct_avg_monthly_txns,
    ap.total_transactions  AS acct_total_transactions,
    ap.pct_foreign         AS acct_pct_foreign       ,
    ap.unique_countries    AS acct_unique_countries  ,
    ap.unique_categories   AS acct_unique_categories ,
    ap.avg_ip_risk         AS acct_avg_ip_risk       ,
    ap.is_fraudster        AS acct_is_fraudster,
    fp.description         AS pattern_description,      -- ⚠️ NULL for non-fraud rows (only fraud has a pattern) 982857 null

    ts.transaction_count AS hour_txn_count,             -- how busy that hour was (volume context)
    ts.total_amount      AS hour_total_amount           -- $ volume that hour
    -- (⚠️ leaky)
    --ap.is_fraudster  — keep included for exploration, EXCLUDE from ML features, New info
    -- (⚠️ leaky)
    --EXCLUDED for now
    --ap.fraud_count         AS acct_fraud_count       ,
    --ap.fraud_rate          AS acct_fraud_rate        ,

    --New info for account
    --ap.fraud_amount      = account's total fraud $
    -- (⚠️ leaky)
    --EXCLUDED for now
    --fp.fraud_share_pct               = this pattern's share of all fraud
    --fp.avg_amount, median_amount     = avg/median $ for this fraud type
    --fp/pct_night_0_5, pct_foreign       = behavioral rates of this fraud type
    --fp.pct_card_not_present, pct_no_2fa = behavioral rates of this fraud type
    --fp.pct_card_not_present, pct_no_2fa = behavioral rates of this fraud type
    --fp.avg_velocity_1h, avg_ip_risk     = avg velocity/IP-risk of this fraud type
    -- (⚠️ leaky)
    --EXCLUDED for now
    --ts.fraud_rate
    --ts.fraud_count

    FROM   `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.stg_transactions`  AS t
LEFT JOIN  `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.stg_account_profiles`  AS ap -- 1st join: account profile (many txns -> one account)
ON t.account_id = ap.account_id
LEFT JOIN `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.stg_fraud_patterns` AS fp     -- 2nd join: fraud pattern (many txns -> one pattern)
ON t.fraud_pattern = fp.fraud_pattern
LEFT JOIN `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.stg_time_series_stats` AS ts  -- 3rd join: time series stats (many txns -> one hour)
ON TIMESTAMP_TRUNC(t.txn_ts, HOUR) = ts.hour

    --   REASONING — those columns from account_profile that is left out.
    --   has_2fa          =DROPPED, txns table has the column same meaning

    --   RESONING - columns below are, new info but deferable , drop temporarily not needed yet*
--stg_account_profiles
    --   avg_velocity = similar to transctions columnn velocity_1hr *could be diff grain work on grain? But include or no?
    --   total_amount = the account's lifetime total across all its txns
    --   avg_amount   = avg from txn's amount
    --   max_amount   = account's biggest-ever txn - new info for account
--stg_fraud_pattern
    --fp.transactin_count             = # txns of this pattern (population stat)
--stg_time_series_stats
    --ts.avg_amount                   = avg $ of all txns in that hour (population stat)
    --ts.median_amount                = median $ of all txns in that hour (population stat)
    --ts.pct_night_0_5                 = % of txns in that hour that were at night (population stat)
    --ts.pct_foreign                   = % of txns in that hour that were foreign (population stat)
    --ts.pct_card_not_present          = % of txns in that hour that were card-not-present (population stat)
    --ts.pct_no_2fa                    = % of txns in that hour that were no-2fa (population stat)
    --ts.avg_velocity_1h               = avg velocity of all txns in that hour (population stat)
    --ts.avg_ip_risk                   = avg ip_risk of all txns in that hour (population stat)
-- stg_time_series_stats
    --   hour_of_day          =DROPPED, (a) collide on those names and (b) replicate byte-for-byte identical values , 0 info
    --   day_of_week          =DROPPED, (a) collide on those names and (b) replicate byte-for-byte identical values , 0 info
    --   is_weekend           =DROPPED, (a) collide on those names and (b) replicate byte-for-byte identical values , 0 info
