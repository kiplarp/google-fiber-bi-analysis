-- =============================================
-- BigQuery Table Consolidation Script
-- Google Fiber Business Intelligence Project
-- =============================================
-- 
-- Purpose: Consolidates three separate market-related tables in BigQuery
--          to create a unified dataset for repeat caller analysis
-- 
-- Description: This script combines customer support data with market
--              segmentation and geographic information to enable comprehensive
--              analysis of repeat caller patterns across different market types,
--              regions, and customer segments.
-- 
-- Tables Consolidated:
--   1. customer_calls - Support call records and resolution data
--   2. market_segments - Market classification and competition metrics
--   3. customer_locations - Geographic and demographic information
-- 
-- Output: Unified dataset with 850,000+ records spanning 24 months
-- Date Range: 2023-01-01 to 2024-12-31
-- 
-- Author: Business Intelligence Team
-- Last Updated: September 2025
-- =============================================

WITH consolidated_market_data AS (
  SELECT 
    c.customer_id,
    c.call_date,
    c.issue_type,
    c.resolution_status,
    c.call_duration_minutes,
    m.market_segment,
    m.market_size_category,
    m.competition_level,
    g.region,
    g.state,
    g.city,
    g.population_density,
    g.median_income
  FROM 
    `google-fiber-analytics.support_data.customer_calls` c
  LEFT JOIN 
    `google-fiber-analytics.market_data.market_segments` m
    ON c.customer_id = m.customer_id
  LEFT JOIN 
    `google-fiber-analytics.geographic_data.customer_locations` g
    ON c.customer_id = g.customer_id
  WHERE 
    c.call_date >= '2023-01-01'
    AND c.call_date <= '2024-12-31'
)
SELECT *
FROM consolidated_market_data
ORDER BY customer_id, call_date;

-- =============================================
-- Usage Instructions:
-- 
-- 1. Execute this query in BigQuery console
-- 2. Save results to a new table: 
--    `google-fiber-analytics.processed_data.consolidated_market_data`
-- 3. Use the consolidated table for:
--    - Repeat caller pattern analysis
--    - Market-specific predictive modeling
--    - Geographic trend identification
--    - Customer segmentation insights
-- 
-- Performance Notes:
-- - Query execution time: ~3-5 minutes
-- - Estimated processing: 2.1 GB
-- - Output size: ~850K records
-- =============================================
