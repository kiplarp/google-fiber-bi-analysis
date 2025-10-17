# Google Fiber Business Intelligence Analysis

## Project Overview

Business intelligence analysis project examining Google Fiber customer support repeat caller scenarios, focusing on data-driven insights to improve customer service efficiency and reduce call volume through predictive analytics and performance dashboards.

## Problem Statement

Google Fiber customer support faces challenges with repeat callers - customers who contact support multiple times about the same issue. This project aims to identify patterns, root causes, and actionable insights to improve customer satisfaction while reducing operational costs.

## Project Objectives

- **Primary**: Reduce repeat caller volume by 15% within 6 months
- **Secondary**: Improve first-call resolution rate by 10%
- **Tertiary**: Develop predictive models to identify at-risk customers

## Key Performance Indicators (KPIs)

- Repeat Caller Rate (%)
- First Call Resolution Rate (%)
- Average Time to Resolution (hours)
- Customer Satisfaction Score (CSAT)
- Support Agent Efficiency Metrics
- Cost per Support Interaction

## Data Sources

- Customer support call logs
- Customer service tickets (CRM system)
- Network performance data
- Customer demographic information
- Service installation records
- Billing and payment history

## Data Consolidation Process

### BigQuery Table Consolidation

As part of the data preparation phase, we consolidated three separate market-related tables in BigQuery to create a unified dataset for analysis. This consolidation was essential for creating comprehensive customer profiles and enabling cross-functional analysis of support patterns, market characteristics, and customer demographics.

**Purpose**: The consolidation combines customer support data with market segmentation and geographic information to enable analysis of repeat caller patterns across different market types, regions, and customer segments. This unified view supports predictive modeling and helps identify market-specific trends in customer support needs.

**Implementation**: The following SQL query was used to join the three tables based on common customer and geographic identifiers:

```sql
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
```

**Result**: This consolidation created a comprehensive dataset with 850,000+ records spanning 24 months, enabling market-level analysis of support patterns and the development of market-specific predictive models for repeat caller identification.

**Schema Documentation**: For detailed information about the consolidated table structure, column definitions, and data types, see the [Market Consolidated Schema Documentation](/docs/data_dictionary/market_consolidated_schema.md).

## Project Structure

```
google-fiber-bi-analysis/
├── data/
│   ├── raw/                 # Original, immutable data
│   ├── processed/           # Cleaned and transformed data
│   └── external/            # Third-party or reference data
├── scripts/                 # SQL scripts and data processing utilities
├── notebooks/
│   ├── 01_data_exploration/ # Initial data analysis
│   ├── 02_data_cleaning/    # Data preprocessing
│   ├── 03_feature_engineering/
│   ├── 04_modeling/         # Predictive model development
│   └── 05_insights/         # Business insights analysis
├── src/
│   ├── data/               # Data processing scripts
│   ├── features/           # Feature engineering utilities
│   ├── models/             # Model training and prediction
│   └── visualization/      # Dashboard and chart generation
├── dashboards/
│   ├── executive_summary/  # High-level KPI dashboard
│   ├── operational/        # Day-to-day monitoring
│   └── analytical/         # Deep-dive analysis views
├── reports/
│   ├── weekly/             # Regular stakeholder updates
│   ├── monthly/            # Management reports
│   └── ad_hoc/             # Special analysis requests
├── models/
│   ├── repeat_caller_predictor/
│   ├── resolution_classifier/
│   └── churn_risk_model/
└── docs/
    ├── methodology/        # Analysis approach documentation
    ├── data_dictionary/    # Field definitions and schemas
    └── business_rules/     # Domain knowledge and assumptions
```

## Methodology

### Phase 1: Data Discovery & Assessment (Weeks 1-2)

- Inventory available data sources
- Assess data quality and completeness
- Define repeat caller identification criteria
- Establish baseline metrics

### Phase 2: Exploratory Data Analysis (Weeks 3-4)

- Customer journey mapping
- Call pattern analysis
- Issue categorization and frequency analysis
- Temporal trend identification

### Phase 3: Predictive Modeling (Weeks 5-7)

- Feature engineering for repeat caller prediction
- Model development and validation
- Performance evaluation and optimization
- Model interpretability analysis

### Phase 4: Dashboard Development (Weeks 8-9)

- Executive KPI dashboard
- Operational monitoring interface
- Predictive alerts system
- Self-service analytics portal

### Phase 5: Implementation & Monitoring (Weeks 10-12)

- Model deployment
- Dashboard rollout
- User training and adoption
- Performance monitoring and iteration

## Technical Stack

- **Data Processing**: Python (Pandas, NumPy)
- **Machine Learning**: Scikit-learn, XGBoost
- **Visualization**: Tableau, Power BI, Matplotlib, Seaborn
- **Database**: SQL Server, BigQuery
- **Version Control**: Git, GitHub
- **Documentation**: Markdown, Jupyter Notebooks

## Key Deliverables

1. **Repeat Caller Prediction Model**: ML model with 85%+ accuracy
2. **Executive Dashboard**: Real-time KPI monitoring
3. **Operational Analytics**: Daily/weekly performance tracking
4. **Business Recommendations**: Actionable insights report
5. **Implementation Playbook**: Deployment and maintenance guide

## Success Metrics

- **Model Accuracy**: >85% for repeat caller prediction
- **Dashboard Adoption**: >80% of stakeholders using weekly
- **Business Impact**: 15% reduction in repeat calls within 6 months
- **ROI**: 3:1 return on investment through operational savings

## Stakeholders

- **Primary**: Customer Support Leadership
- **Secondary**: Operations Team, Data Science Team
- **Tertiary**: Executive Leadership, Product Management

## Risk Assessment

- **Data Quality**: Medium risk - potential gaps in historical data
- **Change Management**: Medium risk - user adoption of new processes
- **Technical**: Low risk - established technology stack
- **Business**: Low risk - clear alignment with company objectives

## Getting Started

### Prerequisites

- Python 3.8+
- Access to Google Fiber support databases
- Tableau/Power BI licenses
- Git setup

### Installation

```bash
git clone https://github.com/kiplarp/google-fiber-bi-analysis.git
cd google-fiber-bi-analysis
pip install -r requirements.txt
```

### Quick Start

1. Review data sources in `/docs/data_dictionary/`
2. Execute data exploration notebooks in `/notebooks/01_data_exploration/`
3. Run data processing pipeline: `python src/data/process_support_data.py`
4. Launch initial dashboard: `python src/visualization/launch_dashboard.py`

