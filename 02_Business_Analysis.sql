USE customer_retention_analytics;

/*  =====================================================
	BUSINESS QUESTIONS

	BQ1: Who is churning?
	BQ2: What behaviours distinguish churned from retained customers?
	BQ3: Which high-value customers show churn-risk behaviour?
	BQ4: Where should retention efforts be prioritised?
	===================================================== */


-- BQ1: Who is churning?

### Overall churn baseline
SELECT
    COUNT(*) AS total_customers,
    SUM(Churned) AS churned_customers,
    COUNT(*) - SUM(Churned) AS retained_customers,
    ROUND(AVG(Churned) * 100, 2) AS churn_rate_pct
FROM Customers;

### Churn based on Age 
SELECT
    Age_Group,
    COUNT(*) AS total_customers,
    SUM(Churned) AS churned_customers,
    ROUND(AVG(Churned) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY Age_Group
ORDER BY FIELD(
    Age_Group,
    '18-24',
    '25-34',
    '35-44',
    '45-54',
    '55-64',
    '65+'
);

### Churn based on Gender
SELECT
    Gender,
    COUNT(*) AS total_customers,
    SUM(Churned) AS churned_customers,
    ROUND(AVG(Churned) * 100, 2) AS churn_rate_pct
FROM Customers
GROUP BY Gender
ORDER BY churn_rate_pct DESC;

### Churn based on Country

SELECT
    Country,
    COUNT(*) AS total_customers,
    SUM(Churned) AS churned_customers,
    ROUND(AVG(Churned) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY Country
ORDER BY churn_rate_pct DESC;

### Churn based on regency

SELECT
    Recency_Segment,
    COUNT(*) AS total_customers,
    SUM(Churned) AS churned_customers,
    ROUND(AVG(Churned) * 100, 2) AS churn_rate_pct
FROM Customers
GROUP BY Recency_Segment
ORDER BY FIELD(
    Recency_Segment,
    'Very Recent',
    'Recent',
    'Inactive',
    'Highly Inactive'
);

### Churn based on Engagement

SELECT
    Engagement_Segment,
    COUNT(*) AS total_customers,
    SUM(Churned) AS churned_customers,
    ROUND(AVG(Churned) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY Engagement_Segment
ORDER BY FIELD(
    Engagement_Segment,
    'Very Low',
    'Low',
    'High',
    'Very High'
);

### Churn based on Customer Value

SELECT
    Customer_Value_Segment,
    COUNT(*) AS total_customers,
    SUM(Churned) AS churned_customers,
    ROUND(AVG(Churned) * 100, 2) AS churn_rate_pct,
    ROUND(AVG(Lifetime_Value), 2) AS avg_lifetime_value
FROM Customers
GROUP BY Customer_Value_Segment
ORDER BY FIELD(
    Customer_Value_Segment,
    'Low Value',
    'Medium Value',
    'High Value',
    'VIP'
);

/*  
	=====================================================
	BQ1 CONCLUSION

	Overall churn rate: 28.90%.

	Churn is primarily concentrated among customers showing low engagement and increasing inactivity.

	VIP customers also show unexpectedly elevated churn relative to High Value customers and require further investigation.

	Overall, behavioural engagement and recency appear more useful for retention prioritisation than demographic characteristics alone.
	===================================================== */

-- =======================================
-- BQ2: Churned vs Retained behaviour
-- =======================================

SELECT
    CASE
        WHEN Churned = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,

    COUNT(*) AS customers,

    ROUND(AVG(Login_Frequency), 2)
        AS avg_login_frequency,

    ROUND(AVG(Session_Duration_Avg), 2)
        AS avg_session_duration,

    ROUND(AVG(Pages_Per_Session), 2)
        AS avg_pages_per_session,

    ROUND(AVG(Days_Since_Last_Purchase), 2)
        AS avg_days_since_purchase,

    ROUND(AVG(Total_Purchases), 2)
        AS avg_total_purchases,

    ROUND(AVG(Average_Order_Value), 2)
        AS avg_order_value,

    ROUND(AVG(Cart_Abandonment_Rate), 2)
        AS avg_cart_abandonment,

    ROUND(AVG(Email_Open_Rate), 2)
        AS avg_email_open_rate,

    ROUND(AVG(Customer_Service_Calls), 2)
        AS avg_service_calls,

    ROUND(AVG(Returns_Rate), 2)
        AS avg_returns_rate,

    ROUND(AVG(Mobile_App_Usage), 2)
        AS avg_mobile_app_usage,

    ROUND(AVG(Social_Media_Engagement_Score), 2)
        AS avg_social_engagement,

    ROUND(AVG(Engagement_Score), 2)
        AS avg_engagement_score

FROM customers
GROUP BY Churned
ORDER BY Churned;

/*
=====================================================
BQ2 CONCLUSION
What behaviours distinguish churned from retained customers?

Churned customers show a clear pattern of lower engagement
and greater inactivity compared with retained customers.

They log in less frequently, remain inactive for longer periods,
interact less with marketing channels, and show greater purchase
or service friction.

These behavioural differences suggest that declining engagement
and increasing inactivity could act as useful early-warning
signals of churn, allowing the business to prioritise proactive
retention actions.

The relationships identified here are associations and should
not be interpreted as causal effects.
=====================================================
*/

-- =======================================
-- BQ3: High-value customers at risk
-- =======================================


### Retention Target List

SELECT
    Customer_ID,
    Customer_Value_Segment,
    Engagement_Segment,
    Recency_Segment,
    Lifetime_Value,
    Days_Since_Last_Purchase,
    Login_Frequency,
    Email_Open_Rate,
    Customer_Service_Calls,
    Engagement_Score
FROM customers
WHERE Churned = 0
  AND Customer_Value_Segment IN ('High Value', 'VIP')
  AND Engagement_Segment IN ('Very Low', 'Low')
  AND Recency_Segment IN ('Inactive', 'Highly Inactive')
ORDER BY Lifetime_Value DESC;

### Quantify at_risk group

SELECT
    COUNT(*) AS priority_customers,
    ROUND(SUM(Lifetime_Value), 2)
        AS total_lifetime_value,
    ROUND(AVG(Lifetime_Value), 2)
        AS avg_lifetime_value
FROM Customers
WHERE Churned = 0
  AND Customer_Value_Segment IN ('High Value', 'VIP')
  AND Engagement_Segment IN ('Very Low', 'Low')
  AND Recency_Segment IN ('Inactive', 'Highly Inactive');


### Investigate VIP churn

SELECT
    CASE
        WHEN Churned = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,

    COUNT(*) AS customers,

    ROUND(AVG(Days_Since_Last_Purchase), 2)
        AS avg_recency,

    ROUND(AVG(Login_Frequency), 2)
        AS avg_login_frequency,

    ROUND(AVG(Email_Open_Rate), 2)
        AS avg_email_open_rate,

    ROUND(AVG(Customer_Service_Calls), 2)
        AS avg_service_calls,

    ROUND(AVG(Cart_Abandonment_Rate), 2)
        AS avg_cart_abandonment,

    ROUND(AVG(Returns_Rate), 2)
        AS avg_returns_rate,

    ROUND(AVG(Mobile_App_Usage), 2)
        AS avg_mobile_usage,

    ROUND(AVG(Engagement_Score), 2)
        AS avg_engagement_score

FROM customers

WHERE Customer_Value_Segment = 'VIP'

GROUP BY Churned
ORDER BY Churned;

### Compare between VIP and high value customer 

SELECT
    Customer_Value_Segment,

    COUNT(*) AS customers,

    ROUND(AVG(Churned) * 100, 2)
        AS churn_rate_pct,

    ROUND(AVG(Days_Since_Last_Purchase), 2)
        AS avg_recency,

    ROUND(AVG(Login_Frequency), 2)
        AS avg_login,

    ROUND(AVG(Customer_Service_Calls), 2)
        AS avg_service_calls,

    ROUND(AVG(Engagement_Score), 2)
        AS avg_engagement

FROM customers

WHERE Customer_Value_Segment
    IN ('High Value', 'VIP')

GROUP BY Customer_Value_Segment;

/*
=====================================================
BQ3 CONCLUSION — HIGH-VALUE CUSTOMERS AT RISK
Which high-value customers show churn-risk behaviour?

A rule-based screening approach identified 1,748 retained
High Value or VIP customers with low/very low engagement
and inactive/highly inactive purchase behaviour.

Their combined recorded Lifetime_Value is 2,903,048.38
(average 1,660.78; currency unspecified). This measures
historical/customer value represented by the segment,
NOT expected future revenue loss.

Historical VIP churn (39.6%) is also higher than churn
in the High Value segment (14.4%), warranting further
investigation of behavioural and service differences.

The priority group is an interpretable business heuristic,
not a validated individual churn probability. Customers
should be reviewed before any retention intervention.
=====================================================
*/


-- =======================================
-- BQ4 : Where should retention efforts be prioritised?
-- ===========================

SELECT
    Customer_Value_Segment,
    Engagement_Segment,
    Recency_Segment,

    COUNT(*) AS total_customers,

    SUM(Churned) AS churned_customers,

    ROUND(
        AVG(Churned) * 100,
        2
    ) AS churn_rate_pct,

    ROUND(
        SUM(Lifetime_Value),
        2
    ) AS total_lifetime_value

FROM customers

GROUP BY
    Customer_Value_Segment,
    Engagement_Segment,
    Recency_Segment

HAVING COUNT(*) >= 20

ORDER BY
    churn_rate_pct DESC,
    total_lifetime_value DESC;
    
    
    
    ### Create actionable priority for retained customers
    
    SELECT
    Customer_Value_Segment,
    Engagement_Segment,
    Recency_Segment,

    COUNT(*) AS customers,

    ROUND(
        SUM(Lifetime_Value),
        2
    ) AS total_lifetime_value,

    ROUND(
        AVG(Lifetime_Value),
        2
    ) AS avg_lifetime_value

FROM customers

WHERE Churned = 0
  AND Customer_Value_Segment IN ('High Value', 'VIP')
  AND Engagement_Segment IN ('Very Low', 'Low')
  AND Recency_Segment IN ('Inactive', 'Highly Inactive')

GROUP BY
    Customer_Value_Segment,
    Engagement_Segment,
    Recency_Segment

ORDER BY
    total_lifetime_value DESC;
    
    
    /*
=====================================================
BQ4 CONCLUSION — RETENTION PRIORITISATION
Where should retention efforts be prioritised?

Historical segmentation highlights the combination of
VIP status, Very Low Engagement and Highly Inactive
recency: 87.8% of its 147 customers have churned.
This describes historical churn in the full segment,
not the likelihood of an individual customer's churn.

For actionable outreach, focus on customers who have
NOT yet churned. Among the retained priority segments,
High Value + Low Engagement + Highly Inactive has the
largest combined recorded Lifetime_Value (855,012.66)
and includes 566 customers.

Prioritisation should therefore consider both historical
churn patterns and the size/value of reachable retained
customer groups. Validate suitability with business
stakeholders, pilot interventions, and monitor outcomes.
=====================================================
*/

    




    





