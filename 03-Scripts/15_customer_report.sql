/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors*/

IF OBJECT_ID('gold.customer_report','V') IS NOT NULL
    DROP VIEW gold.customer_report;

GO
CREATE VIEW gold.customer_report AS
 /*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/

WITH base_querry AS
(
SELECT
    sp.order_item_id,
    cu.customer_key,
    cu.customer_id,
    sp.product_key,
    sp.store_key,
    sp.promotion_key,
    sp.order_id,
    sp.order_date,
    cu.city,
    DATEDIFF(MONTH,signup_date,GETDATE()) AS month_since_signup,
    sp.price,
    sp.quantity,
    sp.sales
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_customers cu
ON sp.customer_key = cu.customer_key
WHERE order_date IS NOT NULL
),
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
customer_aggregation AS 
(
SELECT
    customer_key,
    customer_id,
    city,
    month_since_signup,
    COUNT(DISTINCT order_id) AS total_order,
    COUNT(DISTINCT product_key) AS total_product,
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity,
    MAX(order_date) AS last_order_date,
    DATEDIFF(DAY,MIN(order_date),MAX(order_date)) AS life_span
FROM base_querry
GROUP BY customer_key,customer_id,city,month_since_signup
)

SELECT
    customer_key,
    customer_id,
    city,
    month_since_signup,
    total_order,
    total_product,
    total_sales,
    total_quantity,
    last_order_date,
    life_span,
    CASE WHEN life_span >= 993 AND total_order >= 7 THEN 'High Engagement'
         WHEN life_span >= 993 AND total_order < 7 THEN 'Long-Term Occasional'
         WHEN life_span < 993 AND total_order >= 7 THEN 'Frequent Shorter-Term'
         ELSE 'Low Engagement'
    END AS customer_segment,
    -- Compute average order value (AOV)
    CASE WHEN total_order = 0 THEN 0
         ELSE total_sales / total_order
    END AS avg_order_value,
     -- Compute average daily spend
    CASE WHEN life_span = 0 THEN total_sales
         ELSE total_sales / life_span
    END AS avg_daily_spend
FROM customer_aggregation


SELECT * FROM gold.customer_report;
