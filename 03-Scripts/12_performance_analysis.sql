/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of category by comparing their sales
to both the average sales performance of the category and the previous year's sales */

WITH yearly_category_sales AS
(
SELECT
    YEAR(sp.order_date) AS order_date,
    p.category_name,
    SUM(sp.sales) AS current_sales
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_products p
ON sp.product_key = p.product_key
GROUP BY YEAR(sp.order_date),p.category_name)

SELECT
    order_date,
    category_name,
    current_sales,
    AVG(current_sales) OVER(PARTITION BY category_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER(PARTITION BY category_name) AS diff_avg,
    CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY category_name) > 0 THEN 'Above Avarage'
         WHEN current_sales - AVG(current_sales) OVER(PARTITION BY category_name) < 0 THEN 'Below Avarage'
         ELSE 'Avg'
    END AS avg_change,
    --year_over_year analysis
    LAG(current_sales) OVER(PARTITION BY category_name ORDER BY order_date) AS py_sales,
    current_sales - LAG(current_sales) OVER(PARTITION BY category_name ORDER BY order_date) AS diff_py,
    CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY category_name ORDER BY order_date) > 0 THEN 'Increase'
         WHEN current_sales - LAG(current_sales) OVER(PARTITION BY category_name ORDER BY order_date) < 0 THEN 'Decrease'
         ELSE 'No Change'
    END AS py_change
FROM yearly_category_sales
ORDER BY category_name,order_date


--Performance analysis based on customers sales

WITH yearly_customer_sales AS
(
SELECT
    YEAR(order_date) AS order_date,
    customer_key AS customer,
    SUM(sales) AS current_sales
FROM gold.fact_sales_partitioned
GROUP BY YEAR(order_date),customer_key
)

SELECT
    order_date,
    customer,
    current_sales,
    AVG(current_sales) OVER(PARTITION BY customer) AS avg_sales,
    current_sales - AVG(current_sales) OVER(PARTITION BY customer) AS diff_avg,
    CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY customer) > 0 THEN 'Above Avarage'
         WHEN current_sales - AVG(current_sales) OVER(PARTITION BY customer) < 0 THEN 'Below Avarage'
         ELSE 'Avg'
    END AS avg_change,
    --year_over_year analysis
    LAG(current_sales) OVER(PARTITION BY customer ORDER BY order_date) AS py_sales,
    current_sales - LAG(current_sales) OVER(PARTITION BY customer ORDER BY order_date) AS diff_py,
    CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY customer ORDER BY order_date) > 0 THEN 'Increase'
         WHEN current_sales - LAG(current_sales) OVER(PARTITION BY customer ORDER BY order_date) < 0 THEN 'Decrease'
         ELSE 'No Change'
    END AS py_change
FROM yearly_customer_sales
ORDER BY customer,order_date
