# FraudPrint

Self-initiated fraud analytics project.
Raw data (5 tables, ~1M transactions) lives in BigQuery, loaded from Kaggle CSVs.

## Goals
1. **Fraud Identification** — data analysis and exploration to discover the behaviours, patterns, and relationships behind fraudulent activity (portfolio analysis, correlation, regression).
2. **Fraud Detection** — an ML risk-scoring model (classification and/or clustering) to flag fraudulent accounts and transactions.

## Data
- **Source:** [Fraud Detection 1M Transactions · 7 Fraud Types](https://www.kaggle.com/datasets/sergionefedov/fraud-detection-1m-transactions-7-fraud-types) by Sergio Nefedov (Kaggle)
- **Contents:** 5 tables, ~1M synthetic card transactions across 50k accounts
  (transactions, account_profiles, fraud_patterns, network_edges, time_series_stats)
- **License:** Apache 2.0
- **Note:** Raw CSVs are git-ignored — data lives in BigQuery, not in this repo.
  To reproduce: download from the source above and load into your own BigQuery dataset.

## Workflow
- **staging** (SQL)      — clean each raw table individually (rename, cast, standardize)
- **intermediate** (SQL) — join the clean tables
- **marts** (SQL)        — final analytical tables
- **analysis** (Python)  — explore, model, visualize on top of marts

## Setup
1. `gcloud auth application-default login`
2. Staging SQL runs against BigQuery via the `bq` CLI

## Structure
- `sql/staging/`      — one stg_*.sql per raw table
- `sql/intermediate/` — joins
- `sql/marts/`        — final tables
- `notebooks/`        — Python exploration & modeling
- `src/`              — reusable Python
- `data/`             — local CSVs (git-ignored)
