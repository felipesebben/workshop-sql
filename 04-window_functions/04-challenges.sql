-- 04. Window Functions – Challenges

-- a. Classify the products with most sales using RANK(), DENSE_RANK(), 
-- and ROW_NUMBER().
-- Tables used: order_details and products
-- This query can be executed using two ways; try to use one that uses a subquery and 
-- one that does not.

-- Answer #1 - Using no subqueries
SELECT 
	p.product_name,
	ROUND(CAST((o.quantity * o.unit_price) AS numeric),2) AS total_sales,
	RANK() OVER(ORDER BY (o.quantity * o.unit_price) DESC ) AS product_rank,
	DENSE_RANK() OVER (ORDER BY (o.quantity * o.unit_price) DESC) AS product_dense_rank,
	ROW_NUMBER() OVER (ORDER BY (o.quantity * o.unit_price) DESC) AS product_row_number	
FROM order_details o
JOIN products p
	ON o.product_id = p.product_id;

-- Answer #2 - Using subqueries and GROUP BY
SELECT
	sales.product_name,
	sales.total_sale,
	RANK() OVER(ORDER BY sales.total_sale DESC) AS product_rank,
	DENSE_RANK() OVER(ORDER BY sales.total_sale DESC) AS product_dense_rank,
	ROW_NUMBER() OVER(ORDER BY sales.total_sale DESC) AS product_row_number
FROM (
	SELECT
		p.product_name,
		SUM(ROUND(CAST((o.unit_price * o.quantity) AS numeric),2)) AS total_sale
	FROM order_details o
	JOIN products p
		ON o.product_id = p.product_id
	GROUP BY p.product_name
) AS sales;


-- b. Make a list of employees dividing them in 3 groups using NTILE().
-- Tables used: employees


-- Order the freight costs paid by clients according
-- to their shipping dates, showing the previous and the following 
-- cost using LAG() and LEAD().
-- Tables used: orders and shippers


-- Extra challenge: Google interview questions
-- https://medium.com/@aggarwalakshima/interview-question-asked-by-google-and-difference-among-row-number-rank-and-dense-rank-4ca08f888486#:~:text=ROW_NUMBER()%20always%20provides%20unique,a%20continuous%20sequence%20of%20ranks.
-- https://platform.stratascratch.com/coding/10351-activity-rank?code_type=3
-- https://www.youtube.com/watch?v=db-qdlp8u3o