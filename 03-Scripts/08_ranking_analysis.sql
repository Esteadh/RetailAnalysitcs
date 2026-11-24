/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

------fact_sales-----------

--Bring in the 10 customers who place the most orders.
SELECT
    customer_key,
    total_order
FROM(SELECT
    customer_key,
    COUNT(DISTINCT order_id) AS total_order,
    ROW_NUMBER() OVER( ORDER BY COUNT(DISTINCT order_id) DESC) AS flag
FROM gold.fact_sales_partitioned
GROUP BY customer_key)t
WHERE flag <= 10 
ORDER BY total_order DESC;


--Bring in the 10 customers who place the worst orders.

 SELECT
    customer_key,
    total_order
 FROM(SELECT
    customer_key,
    COUNT(DISTINCT order_id) AS total_order,
    ROW_NUMBER() OVER( ORDER BY COUNT(DISTINCT order_id) ) AS flag
FROM gold.fact_sales_partitioned
GROUP BY customer_key)t
WHERE flag <= 10
ORDER BY total_order;

--Bring in the 10 customers who spend the most
SELECT
    customer_key,
    total_sales
FROM(SELECT
    customer_key,
    SUM(sales) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(sales) DESC) AS flag
FROM gold.fact_sales_partitioned
GROUP BY customer_key)t
WHERE flag <= 10;


--Bring in the 10 customers who spend the worst

SELECT
    customer_key,
    total_sales
FROM(SELECT
    customer_key,
    SUM(sales) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(sales) ) AS flag
FROM gold.fact_sales_partitioned
GROUP BY customer_key)t
WHERE flag <= 10;

--Retrieve the 10 products with the most orders.
SELECT
    product_key,
    total_order
FROM(SELECT
    product_key,
    COUNT(DISTINCT order_id) AS total_order,
    ROW_NUMBER() OVER(ORDER BY COUNT(order_id) DESC ) AS flag
FROM gold.fact_sales_partitioned
GROUP BY product_key)t
WHERE flag <= 10

--Retrieve the 10 products with the less orders.
SELECT
    product_key,
    total_order
FROM(SELECT
    product_key,
    COUNT(DISTINCT order_id) AS total_order,
    ROW_NUMBER() OVER(ORDER BY COUNT(order_id) ) AS flag
FROM gold.fact_sales_partitioned
GROUP BY product_key)t
WHERE flag <= 10


--Retrieve the 10 best-selling products
SELECT
    product_key,
    total_sales
FROM(SELECT
    product_key,
    SUM(sales) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(sales) DESC) AS flag
FROM gold.fact_sales_partitioned
GROUP BY product_key)t
WHERE flag <= 10


--Retrieve the 10 worst-selling products

SELECT
    product_key,
    total_sales
FROM(SELECT
    product_key,
    SUM(sales) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(sales)) AS flag
FROM gold.fact_sales_partitioned
GROUP BY product_key)t
WHERE flag <= 10


--Retrieve the 5 category with the most orders.
SELECT
    category_name,
    total_order
FROM(SELECT
    p.category_name,
    COUNT( order_id ) AS total_order,
    ROW_NUMBER() OVER(ORDER BY COUNT( order_id ) DESC) AS flag
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_products p
ON p.product_key = sp.product_key
GROUP BY p.category_name)t
WHERE flag <= 10;

--Retrieve the 5 category with the worst orders.


SELECT
    category_name,
    total_order
FROM(SELECT
    p.category_name,
    COUNT( order_id ) AS total_order,
    ROW_NUMBER() OVER(ORDER BY COUNT( order_id )) AS flag
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_products p
ON p.product_key = sp.product_key
GROUP BY p.category_name)t
WHERE flag <= 10;


--Retrieve the 5 best-selling category
SELECT
    category_name,
    total_sales
FROM (SELECT
    p.category_name,
    SUM(sp.sales) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(sp.sales) DESC) AS flag
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_products p 
ON p.product_key = sp.product_key
GROUP BY p.category_name)t
WHERE flag <=5 

--Retrieve the 5 worst-selling category

SELECT
    category_name,
    total_sales
FROM (SELECT
    p.category_name,
    SUM(sp.sales) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(sp.sales) ) AS flag
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_products p 
ON p.product_key = sp.product_key
GROUP BY p.category_name)t
WHERE flag <=5 


--Retrieve the 5 store with the most orders.
SELECT
    store_key,
    total_order
FROM(SELECT
    store_key,
    COUNT(DISTINCT order_id) AS total_order,
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_id) DESC) AS flag
FROM gold.fact_sales_partitioned
GROUP BY store_key)t
WHERE flag <=5

--Retrieve the 5 store with the worst orders.

SELECT
    store_key,
    total_order
FROM(SELECT
    store_key,
    COUNT(DISTINCT order_id) AS total_order,
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_id)) AS flag
FROM gold.fact_sales_partitioned
GROUP BY store_key)t
WHERE flag <=5


--Retrieve the 5 best-selling store
SELECT
    store_key,
    total_sales
FROM(SELECT
    store_key,
    SUM(sales) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(sales) DESC) AS flag
FROM gold.fact_sales_partitioned
GROUP BY store_key)t
WHERE flag <= 5


--Retrieve the 5 worst-selling store
SELECT
    store_key,
    total_sales
FROM(SELECT
    store_key,
    SUM(sales) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(sales)) AS flag
FROM gold.fact_sales_partitioned
GROUP BY store_key)t
WHERE flag <= 5

 -----------fact_payments------

 SELECT
    *
FROM gold.fact_payments;

--Bring in the 10 customers who used the most payment.
SELECT
    customer_key,
    total_payment
FROM(SELECT
    customer_key,
    COUNT(DISTINCT order_id) AS total_payment,
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_id) DESC) flag
FROM gold.fact_payments
GROUP BY customer_key)t
WHERE flag <= 10

--Bring in the 10 customers who used the worst payment.


SELECT
    customer_key,
    total_payment
FROM(SELECT
    customer_key,
    COUNT(DISTINCT order_id) AS total_payment,
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_id) ) flag
FROM gold.fact_payments
GROUP BY customer_key)t
WHERE flag <= 10

 
 ---Retrieve the 10 customers with the highest payment amounts.
 SELECT
    customer_key,
    total_amount
 FROM(SELECT
    customer_key,
    SUM(amount) total_amount,
    ROW_NUMBER() OVER(ORDER BY SUM(amount) DESC) AS flag
FROM gold.fact_payments
GROUP BY customer_key)t
WHERE flag <= 10;


 ---Retrieve the 10 customers with the lowest payment amounts.


  SELECT
    customer_key,
    total_amount
 FROM(SELECT
    customer_key,
    SUM(amount) total_amount,
    ROW_NUMBER() OVER(ORDER BY SUM(amount)) AS flag
FROM gold.fact_payments
GROUP BY customer_key)t
WHERE flag <= 10;


-----fact_returns-------

SELECT
    *
FROM gold.fact_returns;

--List the 10 customers with the most returns
SELECT
    customer_key,
    total_return
FROM(SELECT
    customer_key,
    COUNT(DISTINCT order_id) AS total_return,
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_id)  DESC) as flag
FROM gold.fact_returns
GROUP BY customer_key)t
WHERE flag <= 10;


--List the 10 customers with the less returns


SELECT
    customer_key,
    total_return
FROM(SELECT
    customer_key,
    COUNT(DISTINCT order_id) AS total_return,
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_id) ) as flag
FROM gold.fact_returns
GROUP BY customer_key)t
WHERE flag <= 10;


--List the 10 customers with the highest refund amounts
SELECT
    customer_key,
    total_refund
FROM(SELECT
    customer_key,
    SUM(refund) AS total_refund,
    ROW_NUMBER() OVER(ORDER BY SUM(refund) DESC) AS flag
FROM gold.fact_returns
GROUP BY customer_key)t
WHERE flag <= 10


--List the 10 customers with the lowest refund amounts

SELECT
    customer_key,
    total_refund
FROM(SELECT
    customer_key,
    SUM(refund) AS total_refund,
    ROW_NUMBER() OVER(ORDER BY SUM(refund)) AS flag
FROM gold.fact_returns
GROUP BY customer_key)t
WHERE flag <= 10

--List the 10 product with the most returns
SELECT
    product_key,
    total_return
FROM(SELECT
    product_key,
    COUNT(DISTINCT order_id) AS total_return,
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_id) DESC) AS flag
FROM gold.fact_returns
GROUP BY product_key)t
WHERE flag <= 10;


--List the 10 product with the less returns

SELECT
    product_key,
    total_return
FROM(SELECT
    product_key,
    COUNT(DISTINCT order_id) AS total_return,
    ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_id) ) AS flag
FROM gold.fact_returns
GROUP BY product_key)t
WHERE flag <= 10;

--List the 10 products with the highest refund amounts

SELECT
    product_key,
    total_refund
FROM(SELECT
    product_key,
    SUM(refund) AS total_refund,
    ROW_NUMBER() OVER(ORDER BY SUM(refund) DESC) AS flag
FROM gold.fact_returns
GROUP BY product_key)t
WHERE flag <= 10


--List the 10 products with the lowest refund amounts


SELECT
    product_key,
    total_refund
FROM(SELECT
    product_key,
    SUM(refund) AS total_refund,
    ROW_NUMBER() OVER(ORDER BY SUM(refund)) AS flag
FROM gold.fact_returns
GROUP BY product_key)t
WHERE flag <= 10




--List the 5 product category with the most returns
SELECT
    category_name,
    total_return
FROM(SELECT
    p.category_name,
    COUNT(r.order_id) AS total_return,
    ROW_NUMBER() OVER(ORDER BY COUNT(r.order_id) DESC) AS flag
FROM gold.fact_returns r
LEFT JOIN gold.dim_products p
ON r.product_key = p.product_key
GROUP BY p.category_name)t
WHERE flag <=5



--List the 5 product category with the less returns


SELECT
    category_name,
    total_return
FROM(SELECT
    p.category_name,
    COUNT(r.order_id) AS total_return,
    ROW_NUMBER() OVER(ORDER BY COUNT(r.order_id)) AS flag
FROM gold.fact_returns r
LEFT JOIN gold.dim_products p
ON r.product_key = p.product_key
GROUP BY p.category_name)t
WHERE flag <=5


--List the 5 products category with the highest refund amounts

SELECT
    category_name,
    total_refund
FROM(SELECT
    p.category_name,
    SUM(r.refund) AS total_refund,
    ROW_NUMBER() OVER(ORDER BY SUM(r.refund) DESC) AS flag
FROM gold.fact_returns r
LEFT JOIN gold.dim_products p
ON r.product_key = p.product_key
GROUP BY p.category_name)t
WHERE flag <=5

--List the 5 products category with the lowest refund amounts

SELECT
    category_name,
    total_refund
FROM(SELECT
    p.category_name,
    SUM(r.refund) AS total_refund,
    ROW_NUMBER() OVER(ORDER BY SUM(r.refund)) AS flag
FROM gold.fact_returns r
LEFT JOIN gold.dim_products p
ON r.product_key = p.product_key
GROUP BY p.category_name)t
WHERE flag <=5

