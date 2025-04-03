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
ORDER BY order_id;

-- Example of window function to answer the previous question.
SELECT 
	DISTINCT order_id,
	COUNT(product_id) OVER (PARTITION BY order_id) AS unique_product, -- count the number of products partitioned by order_id
	SUM(quantity) OVER (PARTITION BY order_id) AS total_quantity, -- sum the total quantity for each order_id
	SUM(unit_price * quantity) OVER (PARTITION BY order_id) AS total_price -- multiply unit price times quantity, sum it for each order_id
FROM order_details o
ORDER BY order_id;

SELECT
	o.order_id, o.quantity, o.product_id
FROM order_details o
ORDER BY order_id;


-- MIN(), MAX(), and AVG()
-- Example: calculate the min, max, and average freight prices paid by each customer
-- Solution 01 using GROUP BY
SELECT
	customer_id,
	MIN(freight) AS min_freight,
	MAX(freight) AS max_freight,
	ROUND(CAST(AVG(freight) AS numeric),2) AS avg_freight
FROM orders
GROUP BY customer_id
ORDER BY customer_id;

-- Solution 02 using window functions
SELECT
	DISTINCT customer_id,
	MIN(freight) OVER (PARTITION BY customer_id) AS min_freight,
	MAX(freight) OVER (PARTITION BY customer_id) AS max_freight,
	ROUND(CAST(AVG(freight) OVER (PARTITION BY customer_id) AS numeric),2) AS avg_freight
FROM orders
ORDER BY customer_id;

-- Collapsing ROWS
-- Example without GROUP BY
-- 830 rows
SELECT
	customer_id,
	freight
FROM orders;

-- Example with GROUP BY
-- 89 rows
SELECT
	customer_id,
	MIN(freight) AS min_freight,
	MAX(freight) AS max_freight,
	ROUND(CAST(AVG(freight) AS numeric),2) AS avg_freight
FROM orders
GROUP BY customer_id
ORDER BY customer_id;



-- Using window functions to avoid errors when we don't want to group our data by a specific dimension.
SELECT
	customer_id,
	order_id,
	freight,
	MIN(freight) OVER (PARTITION BY customer_id) AS min_freight,
	MAX(freight) OVER (PARTITION BY customer_id) AS max_freight,
	AVG(freight) OVER (PARTITION BY customer_id) AS avg_freight
FROM orders
ORDER BY customer_id, order_id;

-- RANK(), DENSE_RANK(), and ROW_NUMBER()
-- Example 01: finding the products with the highest sales by order id

SELECT
	o.order_id,
	p.product_name,
	ROUND(CAST((o.unit_price * o.quantity) AS numeric),2) AS total_sale,
	ROW_NUMBER() OVER(ORDER BY (ROUND(CAST((o.unit_price * o.quantity) AS numeric),2)) DESC) as order_rn,
	RANK() OVER(ORDER BY (ROUND(CAST((o.unit_price * o.quantity) AS numeric),2))DESC) AS order_rank,
	DENSE_RANK() OVER(ORDER BY (ROUND(CAST((o.unit_price * o.quantity) AS numeric),2))DESC) AS order_dense
FROM order_details o
JOIN products p
	ON p.product_id = o.product_id;

-- Alternative answer using subquery

SELECT
	sales.product_name,
	sales.total_sale,
	ROW_NUMBER() OVER(ORDER BY  sales.total_sale DESC) AS order_rn,
	RANK() OVER(ORDER BY sales.total_sale DESC) AS order_rank,
	DENSE_RANK() OVER(ORDER BY sales.total_sale DESC) AS order_dense
FROM (
	SELECT
		p.product_name,
		SUM(o.unit_price * o.quantity) AS total_sale
	FROM
		order_details o
	JOIN products p
		ON p.product_id = o.product_id
	GROUP BY p.product_name
) AS sales;
--ORDER BY sales.product_name;

-- Example 02: finding the orders and their respective products' total sales. We need to 
-- get the total sales for each order and the running sum of the value of each product for 
-- each order. These calculations are based on unit price and quantity of products sold.
SELECT
	o.order_id,
	p.product_name,
	ROUND(CAST((o.unit_price * o.quantity) AS numeric),2) AS total_sale,
	SUM(ROUND(CAST((o.unit_price * o.quantity) AS numeric),2)) OVER (PARTITION BY o.order_id) AS total_order_sales,
	ROUND(ROUND(CAST((o.unit_price * o.quantity)AS numeric),2)/SUM(ROUND(CAST((o.unit_price * o.quantity) AS numeric),2)) OVER (PARTITION BY o.order_id),2) AS product_pct
FROM order_details o
JOIN products p	
	ON p.product_id = o.product_id
ORDER BY o.order_id, product_pct DESC;


-- PERCENT_RANK() and CUME_DIST()
SELECT
	order_id,
	unit_price * quantity AS total_sale,
	ROUND(CAST(PERCENT_RANK() OVER (PARTITION BY order_id
		ORDER BY (unit_price * quantity) DESC) AS numeric),2) AS order_percent_rank,
	ROUND(CAST(CUME_DIST() OVER (PARTITION BY order_id
		ORDER BY (unit_price * quantity) DESC) AS numeric),2) AS order_cume_dist
FROM order_details;


	
