USE customer_retention_analytics;

SELECT COUNT(*) AS total_customers
FROM Customers;

SELECT COUNT(DISTINCT Customer_ID) AS unique_customers
FROM customers;

SELECT
    Churned,
    COUNT(*) AS customers
FROM Customers
GROUP BY Churned
ORDER BY Churned;

SELECT
    COUNT(*) AS total_customers,
    SUM(Churned) AS churned_customers,
    COUNT(*) - SUM(Churned) AS retained_customers,
    ROUND(AVG(Churned) * 100, 2) AS churn_rate_pct
FROM Customers;

DESCRIBE Customers;

SELECT
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    MIN(Total_Purchases) AS min_purchases,
    MIN(Cart_Abandonment_Rate) AS min_cart_rate,
    MAX(Cart_Abandonment_Rate) AS max_cart_rate
FROM Customers;

ALTER TABLE Customers
MODIFY Customer_ID VARCHAR(20) NOT NULL;

ALTER TABLE Customers
ADD PRIMARY KEY (Customer_ID);

DESCRIBE Customers;

-- =====================================================
-- VALIDATION RESULT
-- Rows: 50,000
-- Unique Customer IDs: 50,000
-- Churned customers: 14,450
-- Retained customers: 35,550
-- Overall churn rate: 28.90%
-- =====================================================