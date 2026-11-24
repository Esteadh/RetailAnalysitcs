/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/


-----------------------------fact_sales-----------------------------------------
SELECT
    *
FROM gold.fact_sales_partitioned;


-- Find the total number of customers with orders
SELECT COUNT(DISTINCT customer_key) AS customer_number FROM gold.fact_sales_partitioned;

-- Find the total number of customers
SELECT COUNT(*) AS customer_number FROM gold.dim_customers;


-- Find the total number of product with orders

SELECT COUNT(DISTINCT product_key) AS total_product FROM gold.fact_sales_partitioned;


-- Find the total number of product 

SELECT COUNT(*) AS total_product FROM gold.dim_products;


--Find the total number of store with orders

SELECT COUNT(DISTINCT store_key) AS total_store FROM gold.fact_sales_partitioned;

--Find the total number of store

SELECT COUNT(*) AS total_store FROM gold.dim_stores;

--Find the total number of promotion with orders

SELECT COUNT(DISTINCT promotion_key) AS total_promotion FROM gold.fact_sales_partitioned;

--Find the total number of promotion

SELECT COUNT(*) AS total_promotion FROM gold.dim_promotions;

--Find the total orders

SELECT COUNT(DISTINCT order_id) AS total_orders FROM gold.fact_sales_partitioned;

--Find the avarage price

SELECT AVG(price) AS avg_price FROM gold.fact_sales_partitioned;


--Find the total quantity

SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales_partitioned;

--Find the avarage quantity

SELECT AVG(quantity) AS avarage_quantity FROM gold.fact_sales_partitioned;


-- Find the Total Sales

SELECT SUM(sales) AS toal_sales FROM gold.fact_sales_partitioned;

-- Find the Avarage Sales


SELECT AVG(sales) AS avarage_sales FROM gold.fact_sales_partitioned;


-- Generate a Report that shows all key metrics of the business

SELECT 'Total Customer With Orders' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Total Customer',COUNT(*) FROM gold.dim_customers

UNION ALL

SELECT 'Total Product With Orders',COUNT(DISTINCT product_key) FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Total Product',COUNT(*)  FROM gold.dim_products

UNION ALL 

SELECT 'Total Store With Orders', COUNT(DISTINCT store_key)  FROM gold.fact_sales_partitioned

UNION ALL 

SELECT 'Total Store',COUNT(*)  FROM gold.dim_stores

UNION ALL 

SELECT 'Total Promotion With Orders',COUNT(DISTINCT promotion_key)  FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Total Promotion',COUNT(*)  FROM gold.dim_promotions

UNION ALL

SELECT 'Total Orders',COUNT(DISTINCT order_id) FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Avarage Price',AVG(price)  FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Total Quantity',SUM(quantity)  FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Avarage Quantity',AVG(quantity)  FROM gold.fact_sales_partitioned

UNION ALL 

SELECT 'Total Sales',SUM(sales)  FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Avarage Sales', AVG(sales) FROM gold.fact_sales_partitioned;



--------------------------fact_payments---------------------------------

SELECT
    *
FROM gold.fact_payments;    


---Find the total number of payment

SELECT COUNT(*) AS total_payments FROM gold.fact_payments;


---Find the total customer with payments

SELECT COUNT(DISTINCT customer_key) AS total_customer FROM gold.fact_payments;


--Find the total store with payments

SELECT COUNT(DISTINCT store_key) AS total_store FROM gold.fact_payments;


--Find the total order with payments

SELECT COUNT(DISTINCT order_id) AS total_orders FROM gold.fact_payments;


--Find the total amount of payments

SELECT SUM(amount) AS total_amount FROM gold.fact_payments;


--Find the avarage amount of payments 

SELECT AVG(amount) AS avarage_amount FROM gold.fact_payments;


--Find the min amount of payments 

SELECT MIN(amount) AS min_amount FROM gold.fact_payments;



-- Generate a Report that shows all key metrics of the business

SELECT 'Total Number Of Payments' AS measure_name, COUNT(*) AS measure_value FROM gold.fact_payments

UNION ALL

SELECT 'Total Customer With Payments' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_payments

UNION ALL

SELECT 'Total Store With Payments' AS measure_name,  COUNT(DISTINCT store_key)  AS measure_value FROM gold.fact_payments

UNION ALL 

SELECT 'Total Order With Payments' AS measure_name,  COUNT(DISTINCT order_id)  AS measure_value FROM gold.fact_payments

UNION ALL 

SELECT 'Total Amount' AS measure_name,  SUM(amount)   AS measure_value FROM gold.fact_payments

UNION ALL

SELECT 'Avarage Amount' AS measure_name,  AVG(amount)   AS measure_value FROM gold.fact_payments

UNION ALL 

SELECT 'Minimum Amount' AS measure_name,  MIN(amount)   AS measure_value FROM gold.fact_payments

UNION ALL 

SELECT 'Maximum Amount' AS measure_name,  MAX(amount)   AS measure_value FROM gold.fact_payments



--------------------------fact_returns---------------------------------

SELECT 
    *
FROM gold.fact_returns;


--Find the total number of return

SELECT COUNT(*) AS total_return FROM gold.fact_returns;

--Find the total number of order 

SELECT COUNT(DISTINCT order_id) AS total_order FROM gold.fact_returns;

--Find the total number of customer 

SELECT COUNT(DISTINCT customer_key) AS total_customer FROM gold.fact_returns;

--Find the total number of product

SELECT COUNT(DISTINCT product_key) AS total_product FROM gold.fact_returns;

--Find the total number of stores

SELECT COUNT(DISTINCT store_key) AS total_store FROM gold.fact_returns;

--Find the total refund

SELECT SUM(refund) AS total_refund FROM gold.fact_returns;

--Find the avarage refund

SELECT AVG(refund) AS avarage_refund FROM gold.fact_returns;

--Find the minimum refund

SELECT MIN(refund) AS minimum_refund FROM gold.fact_returns;

--Find the maximum refund

SELECT MAX(refund) AS minimum_refund FROM gold.fact_returns;


-- Generate a Report that shows all key metrics of the business

SELECT 'Total Number Of Returns' AS measure_name, COUNT(*) AS measure_value FROM gold.fact_returns

UNION ALL

SELECT 'Number Of Returned Orders' AS measure_name,  COUNT(DISTINCT order_id) AS measure_value FROM gold.fact_returns

UNION ALL 

SELECT 'Number Of Customers Who Returned Items' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_returns

UNION ALL

SELECT 'Number Of Returned Product' AS measure_name, COUNT(DISTINCT product_key) AS measure_value FROM gold.fact_returns

UNION ALL 

SELECT 'Number Of Stores That Accepted Returns' AS measure_name, COUNT(DISTINCT store_key) AS measure_value FROM gold.fact_returns

UNION ALL

SELECT 'Total Refund' AS measure_name, SUM(refund) AS measure_value FROM gold.fact_returns

UNION ALL 

SELECT 'Avarage Refund' AS measure_name, AVG(refund) AS measure_value FROM gold.fact_returns

UNION ALL

SELECT 'Minimum Refund' AS measure_name, MIN(refund) AS measure_value FROM gold.fact_returns

UNION ALL

SELECT 'Maximum Refund' AS measure_name, MAX(refund) AS measure_value FROM gold.fact_returns


--------------------------fact_shipments---------------------------------

SELECT
    *
FROM gold.fact_shipments

--Total shipment number

SELECT COUNT(*) AS total_shipment FROM gold.fact_shipments

--Total customer number of shipment

SELECT COUNT(DISTINCT customer_key) AS total_customer FROM gold.fact_shipments

--Total store number of shipment

SELECT COUNT(DISTINCT store_key) AS total_store FROM gold.fact_shipments

--Total order number of shipment

SELECT COUNT(DISTINCT order_id) AS total_orders FROM gold.fact_shipments



-- Generate a Report that shows all key metrics of the business

SELECT 'Total Number Of Shipmnets' AS measure_name, COUNT(*) AS measure_value FROM gold.fact_shipments

UNION ALL

SELECT 'Total Number Of Customers Shipments' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_shipments

UNION ALL

SELECT 'Total Number Of Stores Shipments' AS measure_name, COUNT(DISTINCT store_key) AS measure_value FROM gold.fact_shipments

UNION ALL

SELECT 'Total Number Of Stores Orders' AS measure_name, COUNT(DISTINCT order_id) AS measure_value FROM gold.fact_shipments



--We can now save the KPI reports we've created as views.


--FACT SALES
CREATE VIEW fact_sales_kpi AS

 SELECT 'Total Customer With Orders' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Total Customer',COUNT(*) FROM gold.dim_customers

UNION ALL

SELECT 'Total Product With Orders',COUNT(DISTINCT product_key) FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Total Product',COUNT(*)  FROM gold.dim_products

UNION ALL 

SELECT 'Total Store With Orders', COUNT(DISTINCT store_key)  FROM gold.fact_sales_partitioned

UNION ALL 

SELECT 'Total Store',COUNT(*)  FROM gold.dim_stores

UNION ALL 

SELECT 'Total Promotion With Orders',COUNT(DISTINCT promotion_key)  FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Total Promotion',COUNT(*)  FROM gold.dim_promotions

UNION ALL

SELECT 'Total Orders',COUNT(DISTINCT order_id) FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Avarage Price',AVG(price)  FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Total Quantity',SUM(quantity)  FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Avarage Quantity',AVG(quantity)  FROM gold.fact_sales_partitioned

UNION ALL 

SELECT 'Total Sales',SUM(sales)  FROM gold.fact_sales_partitioned

UNION ALL

SELECT 'Avarage Sales', AVG(sales) FROM gold.fact_sales_partitioned;


 -- FACT PAYMENTS
 CREATE VIEW fact_payments_kpi AS

 SELECT 'Total Number Of Payments' AS measure_name, COUNT(*) AS measure_value FROM gold.fact_payments

UNION ALL

SELECT 'Total Customer With Payments' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_payments

UNION ALL

SELECT 'Total Store With Payments' AS measure_name,  COUNT(DISTINCT store_key)  AS measure_value FROM gold.fact_payments

UNION ALL 

SELECT 'Total Order With Payments' AS measure_name,  COUNT(DISTINCT order_id)  AS measure_value FROM gold.fact_payments

UNION ALL 

SELECT 'Total Amount' AS measure_name,  SUM(amount)   AS measure_value FROM gold.fact_payments

UNION ALL

SELECT 'Avarage Amount' AS measure_name,  AVG(amount)   AS measure_value FROM gold.fact_payments

UNION ALL 

SELECT 'Minimum Amount' AS measure_name,  MIN(amount)   AS measure_value FROM gold.fact_payments

UNION ALL 

SELECT 'Maximum Amount' AS measure_name,  MAX(amount)   AS measure_value FROM gold.fact_payments;


--FACT RETURNS
CREATE VIEW fact_returns_kpi AS

SELECT 'Total Number Of Returns' AS measure_name, COUNT(*) AS measure_value FROM gold.fact_returns

UNION ALL

SELECT 'Number Of Returned Orders' AS measure_name,  COUNT(DISTINCT order_id) AS measure_value FROM gold.fact_returns

UNION ALL 

SELECT 'Number Of Customers Who Returned Items' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_returns

UNION ALL

SELECT 'Number Of Returned Product' AS measure_name, COUNT(DISTINCT product_key) AS measure_value FROM gold.fact_returns

UNION ALL 

SELECT 'Number Of Stores That Accepted Returns' AS measure_name, COUNT(DISTINCT store_key) AS measure_value FROM gold.fact_returns

UNION ALL

SELECT 'Total Refund' AS measure_name, SUM(refund) AS measure_value FROM gold.fact_returns

UNION ALL 

SELECT 'Avarage Refund' AS measure_name, AVG(refund) AS measure_value FROM gold.fact_returns

UNION ALL

SELECT 'Minimum Refund' AS measure_name, MIN(refund) AS measure_value FROM gold.fact_returns

UNION ALL

SELECT 'Maximum Refund' AS measure_name, MAX(refund) AS measure_value FROM gold.fact_returns


--FACT SHIPMENTS
CREATE VIEW fact_shipments_kpi AS

SELECT 'Total Number Of Shipmnets' AS measure_name, COUNT(*) AS measure_value FROM gold.fact_shipments

UNION ALL

SELECT 'Total Number Of Customers Shipments' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_shipments

UNION ALL

SELECT 'Total Number Of Stores Shipments' AS measure_name, COUNT(DISTINCT store_key) AS measure_value FROM gold.fact_shipments

UNION ALL

SELECT 'Total Number Of Stores Orders' AS measure_name, COUNT(DISTINCT order_id) AS measure_value FROM gold.fact_shipments




