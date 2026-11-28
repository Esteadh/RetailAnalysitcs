/*
===============================================================================
Employees Report
===============================================================================
Purpose:
    - This report consolidates key employees metrics and behavior*/
IF OBJECT_ID('gold.product_report','V') IS NOT NULL
    DROP VIEW gold.product_report;

GO
CREATE VIEW gold.product_report AS


/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
WITH base_querry AS
(
SELECT
    sp.order_item_id,
    sp.customer_key,
    p.product_key,
    p.product_id,
    p.price AS old_price,
    p.country,
    sp.store_key,
    sp.order_id,
    sp.order_date,
    sp.price,
    sp.quantity,
    sp.sales
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_products p
ON sp.product_key = p.product_key
WHERE order_date IS NOT NULL
),
/*---------------------------------------------------------------------------
2) PRODUCT Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
product_aggregation AS
(
SELECT
    product_key,
    product_id,
    old_price,
    country,
    COUNT(DISTINCT customer_key) AS total_customer,
    COUNT(DISTINCT store_key) AS total_store,
    COUNT(DISTINCT order_id) AS total_order,
    MIN(order_date) AS first_product_date,
    MAX(order_date) AS last_product_date,
    DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS product_life_span,
    SUM(sales) AS total_sales,
    SUM(quantity) AS total_quantity
FROM base_querry
GROUP BY product_key,product_id,old_price,country
)

SELECT
    product_key,
    product_id,
    old_price,
    country,
    total_customer,
    total_store,
    total_order,
    first_product_date,
    last_product_date,
    product_life_span,
    total_sales,
    total_quantity,
    CASE WHEN total_order = 0 THEN 0
         ELSE total_sales / total_order
    END AS avg_order_product_value,
    CASE WHEN product_life_span = 0 THEN total_sales
         ELSE total_sales / product_life_span
    END AS avg_monthly_spend
FROM product_aggregation 


SELECT * FROM gold.product_report;
