# Market Consolidated Schema

## Purpose
This document describes the schema for the market consolidated table created during the BigQuery data consolidation process. This consolidated table combines customer support data with market segmentation and geographic information to enable comprehensive analysis of repeat caller patterns across different market segments and regions.

## Source
The schema is derived from the consolidated result of joining three BigQuery tables:
- `google-fiber-analytics.support_data.customer_calls`
- `google-fiber-analytics.market_data.market_segments`
- `google-fiber-analytics.geographic_data.customer_locations`

## Table Schema

| Column Name | Data Type | Mode | Description |
|------------|-----------|------|-------------|
| date_created | TIMESTAMP | NULLABLE | Timestamp when the record was created in the consolidated table |
| contacts_n | INTEGER | NULLABLE | Total number of customer contacts/calls |
| contacts_n_1 | INTEGER | NULLABLE | Number of contacts in time period 1 (day 1) |
| contacts_n_2 | INTEGER | NULLABLE | Number of contacts in time period 2 (day 2) |
| contacts_n_3 | INTEGER | NULLABLE | Number of contacts in time period 3 (day 3) |
| contacts_n_4 | INTEGER | NULLABLE | Number of contacts in time period 4 (day 4) |
| contacts_n_5 | INTEGER | NULLABLE | Number of contacts in time period 5 (day 5) |
| contacts_n_6 | INTEGER | NULLABLE | Number of contacts in time period 6 (day 6) |
| contacts_n_7 | INTEGER | NULLABLE | Number of contacts in time period 7 (day 7) |
| new_type | STRING | NULLABLE | Classification of the customer/market type |
| new_market | STRING | NULLABLE | Market segment identifier or classification |

## Data Processing Notes
- The contacts_n_1 through contacts_n_7 columns represent daily contact counts, allowing for time-series analysis of customer contact patterns
- The new_type and new_market columns provide segmentation capabilities for market-specific analysis
- All timestamp data uses UTC timezone
- Records span from 2023-01-01 to 2024-12-31 (24 months)
- Total records: 850,000+

## Usage
This schema supports:
- Repeat caller pattern analysis across market segments
- Temporal analysis of customer contact behavior
- Market-specific predictive modeling
- Geographic and demographic correlation analysis

## Related Files
- SQL consolidation script: `/scripts/consolidate_market_tables.sql`
- Implementation documentation: See README.md Data Consolidation Process section
