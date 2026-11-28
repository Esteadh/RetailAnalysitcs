/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time

SELECT
    FORMAT(order_date,'yyyy-MM') AS order_date,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(DISTINCT product_key) AS total_product,
    COUNT(DISTINCT store_key) AS total_store,
    COUNT(DISTINCT order_id) AS total_order,
    SUM(price) AS total_price,
    AVG(price) AS avarage_price,
    SUM(quantity) AS total_quantity,
    AVG(quantity) AS avarage_quantitiy,
    SUM(sales) AS total_sales,
    AVG(sales) AS avarage_sales
FROM gold.fact_sales_partitioned
GROUP BY FORMAT(order_date,'yyyy-MM')
ORDER BY order_date


--This query aims to calculate the percentage contribution by determining the monthly sales 
--figures by year and calculating the ratio of those monthly sales to the total sales for that year.
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER(PARTITION BY YEAR(order_date)) total_sales_by_year,
    ROUND(CAST(total_sales AS float) / SUM(total_sales) OVER(PARTITION BY YEAR(order_date)) * 100,2) AS percentage_of_monthly_contribution
FROM(SELECT
    DATETRUNC(MONTH,order_date) AS order_date,
    SUM(sales) AS total_sales
FROM gold.fact_sales_partitioned
GROUP BY DATETRUNC(MONTH,order_date)
)t
ORDER BY order_date


--MoM Growth Analysis
SELECT
    order_date,
    total_sales,
    LAG(total_sales) OVER(ORDER BY order_date) AS previous_month_sales,
    ROUND(CAST((total_sales - LAG(total_sales) OVER(ORDER BY order_date)) AS float) / LAG(total_sales) OVER(ORDER BY order_date) * 100,2) AS MoM_growth
FROM(SELECT
    DATETRUNC(MONTH,order_date) AS order_date,
    SUM(sales) AS total_sales
FROM gold.fact_sales_partitioned
GROUP BY DATETRUNC(MONTH,order_date))t


--YoY Growth Analysis
SELECT
    order_date,
    total_sales,
    LAG(total_sales) OVER(ORDER BY order_date) AS previous_year_sales,
    ROUND(CAST((total_sales - LAG(total_sales) OVER(ORDER BY order_date)) AS float) / LAG(total_sales) OVER(ORDER BY order_date) * 100,2) Yoy_growth
FROM(SELECT
    YEAR(order_date) AS order_date,
    SUM(sales) AS total_sales
FROM gold.fact_sales_partitioned
GROUP BY YEAR(order_date))t


