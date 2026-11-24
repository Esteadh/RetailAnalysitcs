/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.

SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

---gold.dim_customers---

SELECT
    DISTINCT city
FROM gold.dim_customers;

SELECT
    *
FROM gold.dim_customers
ORDER BY signup_date,city


---gold.dim_employees---

SELECT
    DISTINCT city
FROM gold.dim_employees;

SELECT
    *
FROM gold.dim_employees
ORDER BY salary DESC,city;



---gold.dim_products---


SELECT 
    *
FROM gold.dim_products
ORDER BY price DESC,country;

SELECT 
    DISTINCT category_name
FROM gold.dim_products;
 

 SELECT 
    DISTINCT country
FROM gold.dim_products;



---gold.dim_promotions---

SELECT
    *
FROM gold.dim_promotions
ORDER BY discount DESC


---gold.dim_stores---

SELECT
    DISTINCT city
FROM gold.dim_stores

