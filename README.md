# Customer Retention & Engagement Analytics

**A Python and MySQL case study in data quality, customer churn analysis, and retention prioritisation**

**Tech Stack:** Excel (initial checks) · Python · Pandas · NumPy · Matplotlib · scikit-learn (standardisation) · MySQL · MySQL Workbench

## Project Overview

This project analyses 50,000 e-commerce customer records to identify behavioural patterns associated with customer churn and support evidence-based retention decisions.

The project follows an analytical workflow from data preparation and quality validation to SQL business analysis and the development of reusable reporting views.

The current scope focuses on **data quality, business analytics, customer segmentation and rule-based retention prioritisation**.

## 1. Business Problem

An e-commerce business needs to understand why certain customer segments experience higher churn and how behavioural data can support more targeted retention efforts.

The project addresses four business questions:

1. **Who is churning?** Identify customer segments with higher observed churn rates.
2. **What behaviours distinguish churned from retained customers?** Compare engagement, purchasing behaviour and service interactions.
3. **Which high-value customers show potential churn-risk signals?** Identify retained customers who may warrant further review.
4. **Where should retention efforts be prioritised?** Evaluate historical churn patterns alongside the size and recorded value of retained customer groups.

## 2. Dataset

The original dataset contains **50,000 customer records and 25 variables**, covering demographics, purchasing behaviour, digital engagement, customer service, customer value and churn status.

Following data preparation, the final analytical dataset contains **50,000 records and 34 columns**, including engineered features, missingness indicators and a unique analytical customer identifier.

| Metric | Result |
|---|---:|
| Total customers | 50,000 |
| Churned customers | 14,450 |
| Retained customers | 35,550 |
| Overall churn rate | 28.9% |
| Missing values after cleaning | 0 |
| Unique Customer_ID values | 50,000 |

## 3. Data Preparation and Quality Assurance

Python was used to inspect, clean and prepare the customer dataset for business analysis.

The process included:

- Missing-value assessment and median imputation for numeric variables.
- Categorical and numeric data validation.
- Identification and treatment of logically invalid values.
- IQR-based outlier assessment, distinguishing unusual observations from invalid data.
- Creation of missing-value indicators for selected fields.
- Post-cleaning validation of row counts, completeness and churn distribution.

Five analytical features were developed:

| Engineered Feature | Business Purpose |
|---|---|
| Age_Group | Demographic analysis |
| Customer_Value_Segment | Segment customers by recorded Lifetime Value |
| Recency_Segment | Group customers by time since last purchase |
| Engagement_Score | Combine six standardised engagement indicators |
| Engagement_Segment | Classify customers by relative engagement |

The Engagement Score and segments were analytically constructed for this project and are not externally validated business classifications.

## 4. MySQL Business Analysis

The cleaned dataset was imported into MySQL Workbench for data reconciliation, business analysis and the creation of reusable analytical views.

Three SQL scripts organise the analytical workflow:

**01_data_validation.sql**

Validates the imported dataset through customer counts, distinct identifiers, churn reconciliation, schema inspection and basic numeric checks.

**02_business_analysis.sql**

Answers the four business questions through segment-level churn analysis, behavioural comparisons, VIP investigation and retention prioritisation.

**03_analytical_views.sql**

Creates two reusable reporting views:

- `vw_customer_retention`: Customer-level analytical data with customer status and a rule-based retention-priority classification.
- `vw_high_value_at_risk`: Retained High Value/VIP customers meeting specified low-engagement and inactivity criteria.

The views centralise key business definitions for potential downstream reporting.

## 5. Key Business Findings

### BQ1 — Who is churning?

The overall churn rate was **28.9%**.

Customers with Very Low Engagement recorded a churn rate of **52.8%**, compared with **18.9%** among Very High Engagement customers.

Highly Inactive customers recorded **38.0%** churn, compared with **22.4%** among Very Recent customers.

VIP customers showed unexpectedly elevated churn (**39.6%**) compared with High Value customers (**14.4%**).

**Business implication:** Engagement, purchase inactivity and the VIP segment warrant further investigation when developing retention priorities.

### BQ2 — What behaviours distinguish churned from retained customers?

| Behavioural Metric (Average) | Retained | Churned |
|---|---:|---:|
| Login Frequency | 12.64 | 9.12 |
| Days Since Last Purchase | 26.54 | 35.97 |
| Email Open Rate | 22.79 | 16.16 |
| Cart Abandonment Rate | 54.16 | 64.15 |
| Customer Service Calls | 5.18 | 6.90 |

Churned customers demonstrated lower digital engagement, longer periods of purchase inactivity and higher observed service or purchasing friction.

**Business implication:** These measures could be investigated as potential retention-monitoring indicators. The observed relationships do not establish causation.

### BQ3 — Which high-value customers warrant retention review?

A rule-based customer segment was defined using four conditions:

- Currently retained customers.
- High Value or VIP customer segment.
- Low or Very Low Engagement.
- Inactive or Highly Inactive Recency.

The analysis identified **1,748 retained customers** meeting these conditions, comprising 1,442 High Value and 306 VIP customers.

Their combined recorded `Lifetime_Value` was **2,903,048.38**, with the currency unit unspecified in the supplied dataset.

**Business implication:** This group provides a potential shortlist for further review and retention outreach. The classification is based on explicit business rules rather than a validated predictive model.

### BQ4 — Where should retention efforts be prioritised?

Historical analysis identified the **VIP / Very Low Engagement / Highly Inactive** segment as having the highest observed churn rate among segments with at least 20 customers: **129 of 147 customers churned (87.76%)**.

Separately, among the retained customers meeting the retention screening rules, the **High Value / Low Engagement / Highly Inactive** segment represented the largest combined recorded Lifetime Value: **566 customers with 855,012.66**.

**Business implication:** Retention decisions should consider both historical churn patterns and the number and recorded value of customers who can still be reached. The segment with the highest historical churn rate is not necessarily the most valuable outreach target.

## 6. Business Recommendations

1. **Monitor engagement and inactivity:** Assess whether declining engagement and prolonged purchase inactivity can support proactive retention interventions.
2. **Investigate elevated VIP churn:** Examine purchasing behaviour, engagement patterns and service interactions before determining potential causes.
3. **Prioritise high-value retained customers:** Pilot outreach to customers identified through the rule-based screening criteria.
4. **Evaluate intervention effectiveness:** Track customer responses, subsequent retention outcomes and campaign costs before scaling retention initiatives.

These are proposed actions, not outcomes from an implemented retention campaign.


## 7. Reproducing the Analysis

1. Obtain the original customer dataset and execute the Python data-preparation notebook.
2. Ensure a unique analytical `Customer_ID` is generated and export the cleaned dataset.
3. Create the `customer_retention_analytics` schema in MySQL Workbench.
4. Import the cleaned CSV into a table named `Customers`.
5. Execute the SQL files in sequence: data validation, business analysis and analytical views.
6. Verify the imported row counts, unique customer identifiers and churn metrics against the Python outputs.

The source dataset's provenance and redistribution permissions should be confirmed before publishing customer-level records.

## 8. Limitations and Future Development

- Findings describe observed associations rather than causal relationships.
- Median imputation and analytically defined segments may influence results.
- The dataset does not provide a complete transaction-level timeline for longitudinal analysis.
- The Engagement Score is project-specific and has not been externally validated.
- The meaning and currency of `Lifetime_Value` require confirmation.
- Rule-based retention classifications do not represent predicted future churn probabilities.

**Potential future development** includes an interactive Tableau dashboard, predictive churn modelling with appropriate validation, and additional data and AI governance documentation.

---

**Project Scope:** Python data preparation, MySQL data validation, customer behaviour analysis, retention prioritisation and reusable reporting views.
