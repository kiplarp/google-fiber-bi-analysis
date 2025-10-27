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
- Standardized market and type codes for consistent filtering and labeling.
- Readied files for BigQuery modeling.
- Uploaded raw data files to project repository.

### Data Sources

- Customer contact records (call counts, dates, problem types).
- Repeat call tracking by day-offset intervals (1–7 days).
- Anonymized market and problem type mapping tables.

---

## Phase 2: Data Engineering & SQL Process

### Step 1: Raw Data Upload and Validation

- Files uploaded to BigQuery dataset with consistent schema validation.
- Data integrity checks applied across all dimensions (dates, counts, type codes).
- Ensured coverage spans expected date ranges with no critical gaps.

### Step 2: Table Consolidation in BigQuery

**Query Logic:**

- Union first-contact and repeat-offset tables on shared date and identifier fields.
- Add calculated metrics: repeat rate percentage, total callback volume by cohort.
- Create market-friendly labels from type1–type5 codes.
- Generate time-grain columns (week, month, quarter, year) for dynamic filtering.

### Step 3: Example Analysis Query

```sql
SELECT 
  market_1,
  CASE 
    WHEN problem_type = 'type1' THEN 'Account Management'
    WHEN problem_type = 'type2' THEN 'Technician Troubleshooting'
    WHEN problem_type = 'type3' THEN 'Scheduling'
    WHEN problem_type = 'type4' THEN 'Construction'
    WHEN problem_type = 'type5' THEN 'Internet & Wi-Fi'
    ELSE problem_type
  END AS problem_category,
  SUM(first_contact_calls) AS total_first_calls,
  SUM(repeat_calls_7_day) AS total_repeat_calls,
  ROUND(SUM(repeat_calls_7_day) / SUM(first_contact_calls) * 100, 2) AS repeat_rate_pct
FROM `project.dataset.consolidated_calls`
GROUP BY market_1, problem_category
ORDER BY repeat_rate_pct DESC;
```

---

## Phase 3: Dashboard Development & Insights

### Dashboard Screenshot

![Dashboard Screenshot](images/fiber_screenshot.png)

### Key Dashboard Components

- **Repeat Rate Trend:** Time-series line chart showing callback percentage over selected periods (week/month/quarter).
- **Market × Type Heatmap:** Repeat Rate by market and problem category; tooltips also show Repeat Calls (7d) for volume context.
- **Day-Offset Distribution:** Histogram of callbacks across days 1–7 after first contact to pinpoint follow-up windows.

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
