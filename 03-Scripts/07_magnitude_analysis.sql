/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/


---gold.dim_customers--------

SELECT
    customer_key,
    customer_id,
    city,
    signup_date
FROM gold.dim_customers;

--Find the total customers by country
SELECT
    city,
    COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY city
ORDER BY total_customers DESC;


--Find the last customer signup_date by city

SELECT
    city,
    MIN(signup_date)  first_signup,
    MAX(signup_date)  last_signup
FROM gold.dim_customers
GROUP BY city
ORDER BY city



---gold.dim_employees-------

SELECT
    employee_key,
    employee_id,
    store_id,
    salary,
    city
FROM gold.dim_employees;

--Find the most salary by employee

SELECT
    employee_key,
    salary
FROM gold.dim_employees
ORDER BY salary DESC;


--Find the total salary by store
SELECT
    store_id,
    SUM(salary) total_salary
FROM gold.dim_employees
GROUP BY store_id
ORDER BY total_salary DESC

--Find the avg salary by store
SELECT
    store_id,
    AVG(salary) avarage_salary
FROM gold.dim_employees
GROUP BY store_id
ORDER BY avarage_salary DESC

--Find the total salary by city

SELECT
    city,
    SUM(salary) AS total_salary
FROM gold.dim_employees
GROUP BY city
ORDER BY total_salary DESC

--Find the avarage salary by city

SELECT
    city,
    AVG(salary) AS avarage_salary
FROM gold.dim_employees
GROUP BY city
ORDER BY avarage_salary DESC


-----gold.dim_products-----------

SELECT
    product_key,
    product_id,
    category_id,
    category_name,
    supplier_id,
    country,
    price
FROM gold.dim_products;


--Total Product by category

SELECT
    category_name,
    COUNT(*) total_product
FROM gold.dim_products
GROUP BY category_name
ORDER BY total_product DESC;

--Total Product by supplier

SELECT
    supplier_id,
    COUNT(*) total_product
FROM gold.dim_products
GROUP BY supplier_id
ORDER BY total_product DESC;

--Total Product by country

SELECT
    country,
    COUNT(*) total_product
FROM gold.dim_products
GROUP BY country
ORDER BY total_product DESC;

--Avg Price by category

SELECT
    category_name,
    AVG(price) AS avg_price
FROM gold.dim_products
GROUP BY category_name
ORDER BY avg_price DESC


-- AVG price by country

SELECT
    country,
    AVG(price) AS avg_price
FROM gold.dim_products
GROUP BY country
ORDER BY avg_price DESC


 
 ----gold.dim_stores----

--Total store by city

SELECT
    city,
    COUNT(*) AS total_store
FROM gold.dim_stores
GROUP BY city
ORDER BY total_store DESC;


----gold.fact_payments----

SELECT
    *
FROM gold.fact_payments;


--total amount by customer
SELECT
    customer_key AS customer,
    SUM(amount) AS total_amount
FROM gold.fact_payments
GROUP BY customer_key
ORDER BY total_amount DESC;


--Total amount by customer city 
SELECT
    c.city,
    SUM(p.amount) total_amount
FROM gold.fact_payments p
LEFT JOIN gold.dim_customers c
ON p.customer_key = c.customer_key
GROUP BY c.city
ORDER BY total_amount DESC


--Total amount by store 
SELECT
    store_key AS store,
    SUM(amount) AS total_amount
FROM gold.fact_payments
GROUP BY store_key
ORDER BY total_amount DESC;


--Total amount by store city

SELECT
    s.city,
    SUM(p.amount) AS total_amount
FROM gold.fact_payments p
LEFT JOIN gold.dim_stores s
ON p.store_key = s.store_key
GROUP BY s.city
ORDER BY total_amount DESC;


--Total amount by month

SELECT
    FORMAT(order_date,'yyyy-MM') AS order_date,
    SUM(amount) AS total_amount
FROM gold.fact_payments
GROUP BY FORMAT(order_date,'yyyy-MM')
ORDER BY order_date


----gold.fact_returns------

SELECT
    *
FROM gold.fact_returns;

--Return number for customers

SELECT
    customer_key AS customer,
    COUNT(r.return_id) AS total_returns
FROM gold.fact_returns
GROUP BY customer_key
ORDER BY total_returns DESC;

 --Return number for customers city

 SELECT
    c.city,
    COUNT(r.return_id) AS total_return
FROM gold.fact_returns r
LEFT JOIN gold.dim_customers c
ON r.customer_key = c.customer_key
GROUP BY c.city
ORDER BY total_return DESC


--Return Price for customer city

 SELECT
    c.city,
    SUM(r.refund) AS total_refund
FROM gold.fact_returns r
LEFT JOIN gold.dim_customers c
ON r.customer_key = c.customer_key
GROUP BY c.city
ORDER BY total_refund DESC


--Return number for category

SELECT
    p.category_name,
    COUNT(r.return_id) AS total_return
FROM gold.fact_returns r
LEFT JOIN gold.dim_products p 
ON p.product_key = r.product_key
GROUP BY p.category_name
ORDER BY total_return DESC;

--Return Price for category name

SELECT
    p.category_name,
    SUM(r.refund) AS total_refund
FROM gold.fact_returns r
LEFT JOIN gold.dim_products p 
ON p.product_key = r.product_key
GROUP BY p.category_name
ORDER BY total_refund DESC;


--Return number for store city

SELECT
    s.city,
    COUNT(r.return_id) AS total_return
FROM gold.fact_returns r
LEFT JOIN gold.dim_stores s
ON r.store_key = s.store_key
GROUP BY s.city
ORDER BY total_return DESC;


--Return Price for store city

SELECT
    s.city,
    SUM(r.refund) AS total_refund
FROM gold.fact_returns r
LEFT JOIN gold.dim_stores s
ON r.store_key = s.store_key
GROUP BY s.city
ORDER BY total_refund DESC;



----gold.fact_shipments----

SELECT
    *
FROM gold.fact_shipments;

---Total shipment for customer
SELECT
    customer_key,
    COUNT(*) total_shipment
FROM gold.fact_shipments
GROUP BY customer_key
ORDER BY total_shipment DESC

--Total shipment for customer city

SELECT
    c.city,
    COUNT(s.shipment_id) AS total_shipment
FROM gold.fact_shipments s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.city
ORDER BY total_shipment DESC;


--Total shipment for store

SELECT
    store_key,
    COUNT(*) AS total_shipment
FROM gold.fact_shipments
GROUP BY store_key
ORDER BY total_shipment DESC;

--Total shipment for store city

SELECT
    st.city,
    COUNT(s.shipment_id) AS total_shipment
FROM gold.fact_shipments s
LEFT JOIN gold.dim_stores st
ON s.store_key = st.store_key
GROUP BY st.city
ORDER BY total_shipment DESC;


--Total shipment for status

SELECT
    status,
    COUNT(*) AS total_shipment
FROM gold.fact_shipments
GROUP BY status
ORDER BY total_shipment DESC;


----gold.fact_sales----

SELECT
    *
FROM gold.fact_sales_partitioned;

--Total order for customer

SELECT
    customer_key,
    COUNT(DISTINCT order_id) AS total_order
FROM gold.fact_sales_partitioned
GROUP BY customer_key
ORDER BY total_order DESC;

--Total order by customer city

SELECT
    c.city,
    COUNT(DISTINCT sp.order_id) AS total_order
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_customers c
ON sp.customer_key = c.customer_key
GROUP BY c.city
ORDER BY total_order DESC;

--Total Sales for customer

SELECT
    customer_key,
    SUM(sales) AS total_sales
FROM gold.fact_sales_partitioned
GROUP BY customer_key
ORDER BY total_sales DESC;

--Total Sales for customer city

SELECT
    c.city,
    SUM(sp.sales) AS total_sales
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_customers c
ON sp.customer_key = c.customer_key
GROUP BY c.city
ORDER BY total_sales DESC;

--Total Order for product

SELECT 
    product_key,
    COUNT(DISTINCT order_id) AS total_order
FROM gold.fact_sales_partitioned
GROUP BY product_key
ORDER BY total_order DESC;

--Total Sales for product

SELECT
    product_key,
    SUM(sales) AS total_sales
FROM gold.fact_sales_partitioned
GROUP BY product_key
ORDER BY total_sales DESC;

--Total Order for category

SELECT
    p.category_name,
    COUNT(DISTINCT sp.order_id) AS total_order
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_products p 
ON sp.product_key = p.product_key
GROUP BY p.category_name
ORDER BY total_order DESC;


--Total Orders for store

SELECT
    store_key,
    COUNT(DISTINCT order_id) AS total_order
FROM gold.fact_sales_partitioned
GROUP BY store_key
ORDER BY total_order DESC;


--Total sales for store
SELECT
    store_key,
    SUM(sales) AS total_sales
FROM gold.fact_sales_partitioned
GROUP BY store_key
ORDER BY total_sales DESC;


--Total orders for store city

SELECT
    s.city,
    COUNT(DISTINCT sp.order_id) AS total_order
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_stores s
ON sp.store_key = s.store_key
GROUP BY s.city
ORDER BY total_order DESC;

--Total Sales for store city
SELECT
    s.city,
    SUM(sp.sales) AS total_sales
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_stores s
ON sp.store_key = s.store_key
GROUP BY s.city
ORDER BY total_sales DESC;


----Total Sales After Discount-----

SELECT
    sp.order_item_id,
    sp.promotion_key,
    sp.sales,
    p.discount,
    sp.sales * (1 - ROUND(CAST(p.discount AS float) / 100,2)) AS sales_after_discount
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_promotions p
ON p.promotion_key = sp.promotion_key



---Total order for order_date--

SELECT
    FORMAT(order_date,'yyyy-MM') AS order_date,
    COUNT(DISTINCT order_id) AS total_order
FROM gold.fact_sales_partitioned
GROUP BY FORMAT(order_date,'yyyy-MM')
ORDER BY order_date;


--Total Sales for order_date--

SELECT
    FORMAT(order_date,'yyyy-MM') AS order_date,
    SUM(sales) AS total_sales
FROM gold.fact_sales_partitioned
GROUP BY FORMAT(order_date,'yyyy-MM')
ORDER BY order_date;

