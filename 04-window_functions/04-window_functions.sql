-- 04. WINDOW FUNCTIONS
-- Reminder of a query using GROUP BY.
-- Question: how many unique products are there? How many products do we have in total?
-- What is the total price?

SELECT
	order_id,
	COUNT(order_id) AS unique_product,
	SUM(quantity) AS total_quantity,
	ROUND(CAST(SUM(unit_price * quantity)AS NUMERIC),2) AS total_price
FROM order_details o
GROUP BY order_id
ORDER BY order_id