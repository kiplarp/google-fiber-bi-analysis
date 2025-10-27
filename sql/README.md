# SQL Analysis Scripts

This directory contains SQL queries and scripts used for data consolidation, transformation, and analysis of Google Fiber call center data.

## Contents

### Data Consolidation
- Market table consolidation queries
- Union operations for cross-market analysis

### Analysis Queries
- Repeat call analysis by market and problem type
- Time-series aggregations for trend analysis
- KPI calculations for dashboard metrics

## Example Queries

### Market Consolidation
The primary consolidation query merges three market tables into a unified view:

```sql
CREATE OR REPLACE TABLE fiber.market_consolidated AS
SELECT * FROM fiber.market_1
UNION ALL
SELECT * FROM fiber.market_2
UNION ALL
SELECT * FROM fiber.market_3;
```

### Repeat Call Analysis
Analyze repeat call patterns by market and problem type:

```sql
SELECT new_market, new_type, COUNT(*) AS repeat_call_count
FROM fiber.market_consolidated
WHERE contacts_n_1 IS NOT NULL
GROUP BY new_market, new_type
ORDER BY repeat_call_count DESC;
```

## Usage

These queries are designed to run in BigQuery against the Google Fiber call center dataset. Adjust table names and dataset references as needed for your environment.

## Related Documentation

See the main [README](../README.md) for full project context and dashboard documentation.
