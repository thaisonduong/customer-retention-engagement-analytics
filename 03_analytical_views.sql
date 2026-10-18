USE customer_retention_analytics;


CREATE OR REPLACE VIEW vw_customer_retention AS

SELECT
    *,

    CASE
        WHEN Churned = 1
            THEN 'Churned'
        ELSE 'Retained'
    END AS Customer_Status,

    CASE
        WHEN Churned = 0
         AND Customer_Value_Segment IN ('High Value', 'VIP')
         AND Engagement_Segment IN ('Very Low', 'Low')
         AND Recency_Segment IN ('Inactive', 'Highly Inactive')
            THEN 'Priority'
        ELSE 'Standard'
    END AS Retention_Priority

FROM Customers;


SELECT *
FROM vw_customer_retention
LIMIT 10;



### Create hight_value at-risk view

CREATE OR REPLACE VIEW vw_high_value_at_risk AS

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
  AND Recency_Segment IN ('Inactive', 'Highly Inactive');
  
  
  
  
SELECT COUNT(*)
FROM vw_high_value_at_risk;


SELECT COUNT(*)
FROM vw_customer_retention;

SELECT
    Retention_Priority,
    COUNT(*) AS customers
FROM vw_customer_retention
GROUP BY Retention_Priority;


SELECT
    Customer_Status,
    COUNT(*) AS customers
FROM vw_customer_retention
GROUP BY Customer_Status;
