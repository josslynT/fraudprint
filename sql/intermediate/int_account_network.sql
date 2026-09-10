-- sql/intermediate/int_account_network.sql
-- Stage 2 (Intermediate): reshape stg_network_edges from one-row-per-EDGE (account pair)
--   into one-row-per-ACCOUNT network features.
--     Step 1  UNION ALL account_a + account_b  -> one account_id column (gather each account's edges)
--     Step 2  GROUP BY account_id              -> per-account aggregates (connections, ring membership, ...)
--   Result grain: one row per account. Then LEFT JOIN into int_transactions_enriched ON account_id.
-- We use CTE to UNION and aggregate in one query.

WITH account_edges AS (
    SELECT account_a AS account_id, ring_id, both_fraud FROM `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.stg_network_edges`
    UNION ALL
    SELECT account_b AS account_id, ring_id, both_fraud FROM `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.stg_network_edges`
)

SELECT
    account_id,
    COUNT(*)                          AS net_num_connections,
    LOGICAL_OR(ring_id IS NOT NULL)   AS net_in_fraud_ring,    --is any row in a ring? (yes/no)
    COUNT(DISTINCT ring_id)           AS net_num_rings,        --how many different rings?
    COUNTIF(both_fraud)               AS net_num_fraud_conns   -- ⚠️ leaky
FROM account_edges
GROUP BY account_id
