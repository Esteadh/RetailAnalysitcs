/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/


--Customer segmentation based on signup date and last order.
-- STEP 1 : Looking thresholds for customer segmentations.
WITH customer_activity AS
(
SELECT
    customer_key,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    COUNT(DISTINCT order_id) AS total_order,
    DATEDIFF(DAY,MIN(order_date),MAX(order_date)) AS life_span
FROM gold.fact_sales_partitioned
GROUP BY customer_key
),
percentile AS
(
SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY life_span) OVER() AS life_span_p25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY life_span) OVER() AS life_span_p50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY life_span) OVER() AS life_span_p75,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_order) OVER() AS total_order_p25,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_order) OVER() AS total_order_p50,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_order) OVER() AS total_order_p75
FROM customer_activity    
)

SELECT
    DISTINCT *
FROM percentile


--STEP 2 : CUSTOMER SEGMENTATION
WITH customer_activity AS
(
SELECT
    customer_key,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    COUNT(DISTINCT order_id) AS total_order,
    DATEDIFF(DAY,MIN(order_date),MAX(order_date)) AS life_span
FROM gold.fact_sales_partitioned
GROUP BY customer_key
),
customer_segment AS
(
SELECT
    customer_key,
    first_order,
    last_order,
    total_order,
    life_span,
    CASE WHEN life_span >= 993 AND total_order >= 7 THEN 'High Engagement'
         WHEN life_span >= 993 AND total_order < 7 THEN 'Long-Term Occasional'
         WHEN life_span < 993 AND total_order >= 7 THEN 'Frequent Shorter-Term'
         ELSE 'Low Engagement'
    END AS customer_segment
FROM customer_activity),

customer_segment_dist AS
(
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customer,
    SUM(COUNT(customer_key)) OVER() AS overall_customer
FROM customer_segment
GROUP BY customer_segment
)

SELECT
    customer_segment,
    total_customer,
    overall_customer,
    ROUND(CAST(total_customer AS float) / overall_customer * 100,2) AS percentage_total
FROM customer_segment_dist
ORDER BY percentage_total DESC;


