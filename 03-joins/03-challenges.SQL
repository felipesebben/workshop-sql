-- Lesson 03 - Challenges
-- 01.Create a report for all orders from 1996 and their customers (152 rows)
SELECT
 	o.order_id,
	c.contact_name,
	c.company_name,
	o.order_date,
	o.required_date,
	s.company_name
FROM orders o
JOIN customers c	
	ON o.customer_id = c.customer_id
JOIN shippers s
	ON o.ship_via  = s.shipper_id
WHERE DATE_PART('year',o.order_date) IN('1996');

-- 02.Create a report that shows the number of employees and customers in each city that has employees (5 rows)
SELECT
	e.city AS city,
	COUNT(DISTINCT e.employee_id) AS number_of_employees,
	COUNT(DISTINCT c.customer_id) AS number_of_customers
FROM employees e
LEFT JOIN customers c
	ON e.city = c.city
GROUP BY 1;

-- 03.Create a report that shows the number of employees and customers in each city that has customers (69 rows)
SELECT
	c.city AS city,
	COUNT(DISTINCT e.employee_id) AS number_of_employees,
	COUNT(DISTINCT c.customer_id) AS number_of_customers
FROM customers c
LEFT JOIN employees e
	ON e.city = c.city
GROUP BY 1;

-- 04.Create a report that shows the number of employees and customers in each city (70 rows)
SELECT
	c.city AS city,
	COUNT(DISTINCT e.employee_id) AS number_of_employees,
	COUNT(DISTINCT c.customer_id) AS number_of_customers
FROM customers c
FULL JOIN employees e
	ON e.city = c.city
GROUP BY 1;

-- 05.Create a report that shows the total quantity of products ordered.
SELECT
	SUM(o.quantity)
FROM order_details o;
-- 06.Only show records for products for which the ordered quantity is less than 200 (5 rows)

SELECT
	o.product_id,
	SUM(o.quantity) AS total_quantity
FROM order_details o
GROUP BY o.product_id
HAVING SUM(o.quantity) < 200;

-- 07.Create a report that shows the total number of orders per customer since December 31, 1996.
-- The report should return only rows where the total number of orders is greater than 15 (5 rows)
SELECT
	o.customer_id,
	COUNT(order_id) AS total_orders
FROM orders o
WHERE o.order_date >= '1996-12-31'
GROUP BY 1
HAVING COUNT(order_id) > 15;