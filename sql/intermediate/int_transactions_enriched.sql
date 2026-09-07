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
    ap.is_fraudster        AS acct_is_fraudster

    -- (⚠️ leaky)
    --ap.is_fraudster  — keep included for exploration, EXCLUDE from ML features, New info

    --EXCLUDED for now
    --ap.fraud_count         AS acct_fraud_count       ,
    --ap.fraud_rate          AS acct_fraud_rate        ,
    --New info for account
    --ap.fraud_amount = account's total fraud $

    FROM   `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.stg_transactions`  AS t
LEFT JOIN  `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.stg_account_profiles`  AS ap
ON t.account_id = ap.account_id

    --   REASONING — those columns from account_profile that is left out.

    --   has_2fa          =DROPPED, txns table has the column same meaning

    --   RESONING - columns below are, new info but deferable , drop temporarily not needed yet*

    --   avg_velocity = similar to transctions columnn velocity_1hr *could be diff grain work on grain? But include or no?
    --   total_amount = the account's lifetime total across all its txns
    --   avg_amount   = avg from txn's amount
    --   max_amount   = account's biggest-ever txn - new info for account
