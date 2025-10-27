# Google Fiber BI Analysis: Repeat Call Dashboard
## Workplace Scenario Overview
As part of a data analytics assessment, this project delivers an executive-friendly BI dashboard for a fictional Google Fiber customer call center, using anonymized, semi-realistic data to surface seven-day repeat call behavior and its drivers. The solution applies BI methodology (capture, analyze, monitor) to design actionable dashboards that address key customer service challenges.
## Project Background
- **Goal:** Quantify and visualize repeat call patterns to inform improvements in first-contact resolution and post-contact follow-up.
- **Focus Questions:**
  - How often do customers call again within seven days of the first contact?
  - Which problem types generate the most repeat calls?
  - Which markets carry the highest repeat burden and should be prioritized?
## Dataset Details
- **Data Includes:**
  - First-contact call counts per cohort date.
  - Repeat call counts by day offset 1–7 after first contact.
  - Problem type codes (type1–type5) and anonymized market identifiers (market_1–market_3).
  - First-contact date fields used for time-series analysis.
- **Problem Type Categories:**
  - **Type 1:** Account Management
  - **Type 2:** Technician Troubleshooting
  - **Type 3:** Scheduling
  - **Type 4:** Construction
  - **Type 5:** Internet & Wi-Fi
## Stakeholders & Team
- **Primary Stakeholders:** Emma Santiago (Hiring Manager), Keith Portone (Project Manager), Minna Rah (Lead BI Analyst)
- **BI Team Members:** Ian Ortega, Sylvie Essa
## Project Requirements
- Reveal repeat-call volume and root patterns across markets and problem types.
- Enable time-based breakdowns at flexible grains (week, month, quarter, year).
- Provide accessible visuals appropriate for leadership and operations audiences.
- Keep underlying data anonymized while preserving analytical integrity.
- Ensure all stakeholders have access to datasets for review and validation.
---
## Phase 1: Data Capture and Upload
Anonymized call-center extracts were prepared for analysis and staged for BI modeling, ensuring coverage of first-contact dates, market/type dimensions, and seven-day repeat offsets.
### Activities
- Validated structure and ranges for first-contact and repeat-offset metrics.
- Loaded CSVs (market_1, market_2, market_3) into BigQuery staging tables.
- Confirmed shared schema: `date_created`, problem type, market ID, `contacts_n`, and seven repeat-day columns (`contacts_n_1` through `contacts_n_7`).
### Step 1: Initial Upload
Three CSV files representing call-center data across distinct markets were uploaded directly to BigQuery using the console import wizard. Each dataset includes first-contact call volumes and repeat-call counts for each day offset.
### Step 2: Table Consolidation in BigQuery
---
## Phase 2: Data Engineering & SQL Process
This phase consolidated the three market-specific tables, built fact tables for efficient aggregation, and created a summary view optimized for Looker Studio dashboards.

### Merge Sources for Cross-Market Dataset
The three market-specific staging tables were consolidated using a UNION ALL pattern to enable cross-market analysis:

```sql
CREATE OR REPLACE TABLE `project.fiber.market_consolidated` AS
SELECT * FROM `project.fiber.market_1`
UNION ALL
SELECT * FROM `project.fiber.market_2`
UNION ALL
SELECT * FROM `project.fiber.market_3`;
```

This approach preserves all rows from each source and establishes a single table for downstream transformations.

### Build Fact Tables for Contacts and Repeats
Two fact tables were created to structure the data for efficient aggregation:

**Fact Table 1: First Contacts**  
This table captures first-contact call volumes with type casting and null-safe handling:

```sql
-- Cast date, market, and type fields to standard types;
-- use IFNULL and SAFE_CAST to handle missing or malformed contact counts.
CREATE TABLE `project.fiber.fact_calls` AS
SELECT
  CAST(date_field AS DATE)        AS datecreated,
  CAST(market_field AS STRING)    AS new_market,
  CAST(type_field AS STRING)      AS new_type,
  IFNULL(SAFE_CAST(contact_field AS INT64), 0) AS contacts_n
FROM `project.fiber.market_consolidated`;
```

**Fact Table 2: Repeat Calls by Offset**  
Repeat call counts (stored as seven separate columns) were unpivoted into a tabular format using an ARRAY and UNNEST pattern:

```sql
-- Collect the seven repeat-count columns into an ARRAY,
-- then UNNEST with GENERATE_ARRAY to create one row per offset day.
CREATE TABLE `project.fiber.fact_repeats` AS
WITH src AS (
  SELECT
    CAST(date_field AS DATE)      AS datecreated,
    CAST(market_field AS STRING)  AS new_market,
    CAST(type_field AS STRING)    AS new_type,
    [repeat_day1, repeat_day2, repeat_day3, repeat_day4, 
     repeat_day5, repeat_day6, repeat_day7] AS repeats
  FROM `project.fiber.market_consolidated`
)
SELECT
  s.datecreated,
  s.new_market,
  s.new_type,
  off AS repeat_offset_days,
  IFNULL(SAFE_CAST(s.repeats[OFFSET(off-1)] AS INT64), 0) AS repeat_calls
FROM src s
JOIN UNNEST(GENERATE_ARRAY(1,7)) AS off;
```

This design normalizes the repeat data, making day-level breakdowns straightforward.

### Create Summary View for Executive Dashboard
A final view joins the two fact tables and calculates key performance indicators:

```sql
-- Aggregate first-contact and repeat calls by date, market, and type;
-- compute repeat rate using SAFE_DIVIDE to handle zero denominators.
CREATE OR REPLACE VIEW `project.fiber.vw_repeat_summary` AS
SELECT
  c.datecreated,
  c.new_market,
  c.new_type,
  SUM(c.contacts_n)                                AS first_contact_calls,
  SUM(r.repeat_calls)                              AS repeat_calls_7d,
  SAFE_DIVIDE(SUM(r.repeat_calls), SUM(c.contacts_n)) AS repeat_rate
FROM `project.fiber.fact_calls` c
LEFT JOIN `project.fiber.fact_repeats` r
  ON r.datecreated = c.datecreated
 AND r.new_market  = c.new_market
 AND r.new_type    = c.new_type
GROUP BY 1, 2, 3;
```

This view powers the executive dashboard with precomputed metrics for each date/market/type combination.

---
## Phase 3: Dashboard Design in Looker Studio
Google Looker Studio serves as the front-end BI layer, with dashboards fed directly by the summary view and fact tables.
### Design Approach
- **User-Centered:** Dashboards prioritize clarity and executive-level insights over exhaustive detail.
- **Consistent Theming:** Light styling using Google Fiber brand neutrals, clear typography, minimal distractions.
- **Flexible Filtering:** Date ranges, market and problem-type selectors enable ad hoc exploration.
### Dashboard Visuals and Insights
- **Executive Summary Scorecard:**
  - Total first-contact calls, total repeat calls, and overall repeat rate KPIs at a glance.
- **Repeat Rate by Problem Type:**
  - Bar chart reveals which problem types (Type 1–Type 5) trigger the most repeat calls, guiding training and playbook updates.
- **Repeat Rate by Market:**
  - Bar chart shows market-level variance, enabling leadership to prioritize resource allocation.
- **Repeat Rate Trend Over Time:**
  - Line chart tracking repeat rate across dates, highlighting recent improvements or emerging issues.
- **Market–Type Heatmap:**
  - Two-dimensional heatmap identifies the specific market/problem-type combinations with the highest repeat burden.
- **Day-Offset Distribution:**
  - Histogram of callbacks across days 1–7 after first contact to pinpoint follow-up windows.
### Key Insights for Decision-Makers
- **Proactive Follow-Up Opportunity:** Callbacks cluster within the first few days, indicating wins from proactive post-contact messaging and improved first-touch guidance.
- **Targeted Intervention Zones:** Specific market–type pairs drive elevated repeat rates, highlighting where playbook updates and training will yield the fastest gains.
- **Market Prioritization:** Clear variance across markets enables resource allocation to highest-impact areas.
---
## Known Limitations and Follow-Up
- **Time-Grain Selector Edge Case:** A Looker Studio editor constraint flagged DATE_TRUNC as unsupported within a dynamic selector during finalization, blocking the "stacked workload by period" visual in this iteration; a stable workaround (precomputed week/month/quarter/year buckets + selector) is planned for the next update.
- **Friendly Labels in All Sources:** Some charts briefly displayed raw codes (type1–type5) instead of friendly names (e.g., Internet & Wi-Fi) due to cross-source field scope; the mapping exists and will be duplicated wherever necessary for uniform labeling.
- **Seven-Day Window:** Repeat metrics reflect callbacks within seven days of first contact; longer-window repeats are out of scope for this scenario and can be added if stakeholders want broader retention tracking.
---
## Open Questions (for stakeholder review)
1. Which market–type combinations should be prioritized first for intervention based on service goals?
2. What target bands for acceptable repeat rate should be visualized as reference lines on trends/heatmaps?
3. Which specific playbook changes (knowledge-base, technician scripts, follow-up SMS/email) should be piloted in high-repeat segments?
---
## Repository Structure
- **`/images`** - Dashboard screenshots and visualization assets
- **README.md** - This project documentation
---
## Next Steps
- Address known limitations in time-grain selector and label consistency.
- Gather stakeholder feedback on prioritization questions.
- Pilot interventions in identified high-repeat segments.
- Monitor dashboard adoption and iterate based on user feedback.
