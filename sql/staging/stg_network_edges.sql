-- sql/staging/stg_network_edges.sql
-- Stage 1 (Staging): clean the raw `network_edges` reference table — NO joins.
--   * 0/1 number flags  -> proper BOOLEAN (true/false)

SELECT
account_a,                   -- STRING id,               keep
account_b,                   -- STRING id,               keep
shared_type,                 -- STRING devices use type, keep
connection_count,            -- INT64 its a count,       keep
ring_id,                     -- STRING id,               keep
both_fraud = 1 AS both_fraud -- 0/1 -> BOOL
FROM `lewagon-bootcamp-494609.Fraud_detection_1M_transactions.network_edges`
