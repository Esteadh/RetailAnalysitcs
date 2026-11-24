--Find the net sales
WITH sales_after_discount AS
(
SELECT
	sp.order_item_id,
	sp.order_id,
	sp.sales,
	ROUND(CAST(pr.discount AS float) / 100,2) AS discount_percentage,
	sp.sales * (1 - ROUND(CAST(pr.discount AS float) / 100,2)) AS sales_after_discount
FROM gold.fact_sales_partitioned sp
LEFT JOIN gold.dim_promotions pr
ON sp.promotion_key = pr.promotion_key
),
refund_and_discount AS
(
SELECT
	sad.*,
	COALESCE(rt.refund,0) AS refund 
FROM sales_after_discount sad
LEFT JOIN gold.fact_returns rt
ON sad.order_item_id = rt.order_item_id
),
net_sales AS
(
SELECT 
		*,
		sales_after_discount - refund AS net_sales
FROM refund_and_discount)

SELECT
	SUM(net_sales) AS total_net_sales
FROM net_sales



 
