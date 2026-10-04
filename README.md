# Customer Retention & Engagement Analytics

## Project Overview

This project analyses customer behaviour in an e-commerce dataset to identify factors associated with customer churn and support customer retention decision-making.

The analysis focuses on customer engagement, purchase recency and customer value.

## Business Problem

An e-commerce company wants to understand:

1. Which customers are more likely to churn?
2. How customer engagement differs between churned and retained customers.
3. Whether purchase inactivity is associated with churn.
4. Which valuable customers may require greater retention attention.

## Tools

- Microsoft Excel — initial data quality checks and reconciliation
- Python
- Pandas
- NumPy
- Matplotlib
- Scikit-learn

## Dataset

The dataset contains 50,000 customer records and 25 original variables covering:

- customer demographics
- purchasing behaviour
- digital engagement
- customer service activity
- customer value
- churn status

## Data Preparation

The analysis included:

- missing-value assessment
- categorical validation
- invalid numeric value treatment
- outlier assessment
- median imputation
- missing-value indicators
- post-cleaning validation

The final analytical dataset contains 50,000 records and 33 variables.

## Feature Engineering

Five analytical features were created:

- Age Group
- Customer Value Segment
- Recency Segment
- Engagement Score
- Engagement Segment

## Key Findings

### 1. Overall churn

14,450 of 50,000 customers churned, representing a churn rate of 28.9%.

### 2. Engagement is strongly associated with churn

Very Low Engagement customers recorded a churn rate of 52.8%, compared with 28.9% overall.

Churn decreased across higher engagement segments:

- Very Low: 52.8%
- Low: 23.2%
- High: 20.6%
- Very High: 18.9%

### 3. Purchase inactivity is associated with higher churn

Churn increased with the number of days since the customer's last purchase:

- Very Recent: 22.4%
- Recent: 26.7%
- Inactive: 28.9%
- Highly Inactive: 38.0%

### 4. Customer value alone does not explain retention

High Value customers recorded the lowest churn rate at 14.4%, while VIP customers recorded a much higher churn rate of 39.6%.

### 5. High-value customers with low engagement require attention

6,701 High Value or VIP customers had Low or Very Low engagement.

This group recorded a churn rate of 36.4%, above the overall churn rate of 28.9%.

## Recommendations

- Prioritise customers showing very low engagement.
- Use increasing purchase inactivity as an early retention signal.
- Investigate the drivers of elevated churn among VIP customers.
- Combine customer value with behavioural engagement when prioritising retention activity.

## Limitations

- The analysis identifies associations rather than causal relationships.
- Missing numeric values were treated using median imputation.
- The Engagement Score is a project-specific analytical metric rather than an externally validated business KPI.
- The dataset does not include a complete transaction-level timeline.

## Future Development

Future extensions could include:

- PostgreSQL analysis
- Power BI dashboard development
- predictive churn modelling
