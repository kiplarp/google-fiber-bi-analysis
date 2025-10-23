## Workplace Scenario Overview
As part of a data analytics assessment, I completed a business intelligence project for the fictional Google Fiber customer call center. This simulated scenario required using BI methodology (capture, analyze, monitor) to design dashboards that address key customer service issues using anonymized, semi-realistic data.
## Project Background
- **Goal:** Explore and visualize trends in repeat customer calls to the support line, aiming to help Fiber leadership understand first-contact resolution rates and drivers of repeat contact.
- **Focus Questions:**
  - How often do customers call again after their initial inquiry?
  - What types of problems generate the most repeat calls?
  - Which market city receives the highest volume of repeat calls?
## Dataset Details
- **Data Includes:**
  - Number of calls per customer
  - Number of repeat calls after first contact
  - Call type (see problem categories below)
  - Market city (three anonymized city columns: `market_1`, `market_2`, `market_3`)
  - Date of contact and repeat call timing (`contacts_n`, `contacts_n_#days`)
- **Problem Type Categories:**
  - **Type 1:** Account Management
  - **Type 2:** Technician Troubleshooting
  - **Type 3:** Scheduling
  - **Type 4:** Construction
  - **Type 5:** Internet & Wi-Fi
## Stakeholders & Team
- **Primary Stakeholders:** Emma Santiago (Hiring Manager), Keith Portone (Project Manager), Minna Rah (Lead BI Analyst)
- **BI Team Members:** Ian Ortega, Sylvie Essa
- **Accessibility:** Dashboard formatted for large print and text-to-speech compatibility.
## Project Requirements
- Reveal insights about repeat caller volume and causes
- Enable breakdowns by city, problem type, and time period (weekly, monthly, quarterly, yearly)
- Provide accessible visualizations (charts and tables)
- Ensure all stakeholders have access to underlying anonymized data for review
---
## Phase 1: Data Capture and Upload
This initial phase focuses on obtaining, preparing, and uploading the source data for analysis.
### Activities:
- Capture anonymized customer call center data from Google Fiber support systems
- Validate data quality and completeness
- Prepare datasets for consolidation and analysis
- Upload raw data files to project repository
### Data Sources:
- Customer contact records (call counts, dates, problem types)
- Market segmentation data (three anonymized cities)
- Repeat call tracking metrics
### Status:
Data capture and initial upload complete. Files available in repository for Phase 2 processing.
---
## Data Engineering & SQL Process

### Step 1: Data Capture

Three anonymized CSV files (each representing a market/city) were uploaded as separate BigQuery tables:
- `fiber.market_1`
- `fiber.market_2`
- `fiber.market_3`

### Step 2: Table Consolidation in BigQuery

The market-level tables were merged into a master dataset to support cross-market analysis.  
**SQL used for consolidation:**

```sql
CREATE OR REPLACE TABLE fiber.market_consolidated AS
SELECT * FROM fiber.market_1
UNION ALL
SELECT * FROM fiber.market_2
UNION ALL
SELECT * FROM fiber.market_3;
```

**Result:**  
The consolidated `market_consolidated` table contains variables such as contact date, repeat call intervals, problem type (`new_type`), and market identifier (`new_market`).

### Step 3: Example Analysis Query

Count repeat calls by market and problem type:

```sql
SELECT new_market, new_type, COUNT(*) AS repeat_call_count
FROM fiber.market_consolidated
WHERE contacts_n_1 IS NOT NULL
GROUP BY new_market, new_type
ORDER BY repeat_call_count DESC;
```
---
## Phase 3: Dashboard Development & Insights
This final phase translates the consolidated data into actionable insights through interactive dashboards and visualizations.
### Planned Deliverables:
- **Charts/Tables:**
  - Repeat calls by first-contact date
  - Repeat calls by market and problem type
  - Time-based breakdowns (week, month, quarter, year)
- **Interactive Dashboards:**
  - Executive summary view for leadership
  - Operational dashboard for customer service managers
  - Detailed drill-down views by market and problem category
### Success Criteria:
- Demonstrate operational insights that can reduce overall call volume
- Improve customer satisfaction through targeted interventions
- Optimize customer service operations based on data-driven recommendations
### Accessibility Requirements:
- Large print formatting
- Text-to-speech compatibility
- High-contrast color schemes
- Keyboard navigation support
### Status:
Planned for future development. Awaiting Phase 2 completion.
---
## Open Questions (for next phase/stakeholder review)
1. What additional breakdowns or segmentations do stakeholders find most valuable beyond city and problem type?
2. Are there specific accessibility features (besides large print/text-to-speech) that should be prioritized for dashboard design?
3. How should privacy compliance and data governance be handled for ongoing dashboard access/review?
