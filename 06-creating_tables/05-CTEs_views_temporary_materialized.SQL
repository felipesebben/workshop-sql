-- 01. Subqueries
-- Use them when you need intermediary results to gilter or aggregate data on a main query.


SELECT product_id, rank 
	FROM
		(SELECT 
			det.product_id,
			SUM(det.quantity * det.unit_price * (1 - det.discount)) AS sold_value,
			RANK() OVER(ORDER BY SUM(det.quantity * det.unit_price * (1- det.discount)) DESC) AS rank
		FROM order_details det
		GROUP BY 1
		ORDER BY 3)
WHERE rank <= 5; -- Window Functions cannot be filtered so we create a subquery and filter it afterwards.

-- Common Table Expressions (CTEs)
-- CTEs are useful when you need to split a query into more manageable parts or when you may want to reuse
-- a subqery multiple times in the main query.

WITH TotalRevenues AS ( 
	SELECT
		c.company_name,
		SUM(od.unit_price * od.quantity * (1.0 - od.discount)) AS total
	FROM customers c
	INNER JOIN orders o ON c.customer_id = o.customer_id 
	INNER JOIN order_details od ON od.order_id = o.order_id 
	GROUP BY 1
)
SELECT * FROM TotalRevenues;

-- Refactoring subqueries to CTEs.