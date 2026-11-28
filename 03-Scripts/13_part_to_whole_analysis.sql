/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To find the proportion of each part relative to the whole.
    - To see which categories contribute the most to overall sales.

SQL Functions Used:
    - SUM(): Aggregates values per category.
    - Window Functions: SUM() OVER() for the overall total.
===============================================================================
*/

-- Which categories contribute the most to overall sales?
WITH total_sales_by_category AS
(
SELECT
    p.category_name,
    SUM(sp.sales) AS total_sales
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_products p 
ON sp.product_key = p.product_key
GROUP BY p.category_name
)

SELECT
    category_name,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    ROUND(CAST(total_sales AS float) / SUM(total_sales) OVER() * 100,2) AS percentage_of_total
FROM total_sales_by_category
ORDER BY percentage_of_total DESC;


-- Which store country contribute the most to overall sales?
WITH total_sales_by_country AS
(
SELECT
    p.country,
    SUM(sp.sales) AS total_sales
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_products p 
ON sp.product_key = p.product_key
GROUP BY p.country)

SELECT
    country,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    ROUND(CAST(total_sales AS float) / SUM(total_sales) OVER() * 100,2) AS percentage_of_total
FROM total_sales_by_country
ORDER BY percentage_of_total DESC;

-- Which customer city contribute the most to overall sales?

WITH total_sales_by_year AS
(
SELECT
    cu.city,
    SUM(sp.sales) AS total_sales
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_customers cu
ON cu.customer_key = sp.customer_key
GROUP BY cu.city
)

SELECT
    city,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    ROUND(CAST(total_sales AS float) / SUM(total_sales) OVER() * 100,2) AS  percentage_of_total
FROM total_sales_by_year
ORDER BY percentage_of_total DESC;


