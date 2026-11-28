/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/


-- Calculate the total sales per month
-- and the running total that restarts every year
SELECT
    order_date,
    monthly_total_sales,
    SUM(monthly_total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales
FROM(SELECT
    DATETRUNC(MONTH,order_date)  as order_date,
    SUM(sales) AS monthly_total_sales
FROM gold.fact_sales_partitioned
GROUP BY DATETRUNC(MONTH,order_date))t
ORDER BY order_date



--Cumulative Growth Percentage
WITH monthly_total_sales AS 
(
SELECT
    DATETRUNC(MONTH,order_date)  as order_date,
    SUM(sales) AS monthly_total_sales
FROM gold.fact_sales_partitioned
GROUP BY DATETRUNC(MONTH,order_date)
),
running_total AS(
SELECT
    order_date,
    monthly_total_sales,
    SUM(monthly_total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales
FROM monthly_total_sales),

running_and_previous_running AS(
SELECT 
    order_date,
    monthly_total_sales,
    running_total_sales,
    LAG(running_total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY running_total_sales ASC) previous_running
FROM running_total
)

SELECT
    order_date,
    monthly_total_sales,
    running_total_sales,
    previous_running,
    COALESCE(ROUND(CAST((running_total_sales - previous_running) AS float) / NULLIF(previous_running,0) * 100,2),0) AS cumulative_growth_percentage
FROM running_and_previous_running
ORDER BY order_date

-- Calculate the total sales per year
-- and the running total of sales over time
SELECT
    order_date,
    yearly_total_sales,
    yearly_avg_price,
    SUM(yearly_total_sales) OVER(ORDER BY order_date) AS running_total,
    AVG(yearly_avg_price) OVER(ORDER BY order_date) AS moving_avarage_price
FROM(SELECT 
    DATETRUNC(YEAR,order_date) AS order_date,
    SUM(sales) AS yearly_total_sales,
    AVG(price) AS yearly_avg_price
FROM gold.fact_sales_partitioned
GROUP BY DATETRUNC(YEAR,order_date))t
ORDER BY order_date

