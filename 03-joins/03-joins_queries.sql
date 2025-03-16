-- 03. JOINS

-- INNER JOIN
-- 01. Create a report for all orders of 1996 and its clients
-- Tables: customers and orders 
SELECT 
*
FROM orders o
INNER JOIN customers c -- INNER is implicit, no need to write it
ON o.customer_id = c.customer_id -- Informs on which dimensions will the join be performed
WHERE EXTRACT(YEAR FROM o.order_date) = 1996;

-- EXTRACT performs a filter on the data returned by the SELECT command, making sure that
-- only data registered as 1996 are included on the set of results.
-- You can use MONTH, DAY, WEEK, and so on.

-- Alternative method using DATE_PART
SELECT 
*
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
WHERE DATE_PART('YEAR', o.order_date) = 1996;

-- LEFT JOIN
-- Use it when you want to get all the observations from one row, join it with another and keep the obsevations
-- in which no relationship was found with the relative table.
-- You want all the registers from the first (left) table with the matching values from the second (right) table. 
-- If no identity is found, the returned value is NULL. 
-- Example: Create a report that shows the number of employees and clients for each city that has employees.

SELECT
 e.city AS city,
 COUNT(DISTINCT e.employee_id) AS number_of_employees,
 COUNT(DISTINCT c.customer_id) AS number_of_clients
FROM employees e
LEFT JOIN customers c ON e.city = c.city
GROUP BY e.city
ORDER BY city;

-- Output:
-- a.The city of Kirkland has a balanced number of employees and clients.
-- b. London is understaffed, as there are 4 employees serving 6 clients.
-- c. Redmond and Tacoma are overstaffed. With 1 idle employee, the staff for each city serves no client.
-- Alternatively, the company is still establishing itself on these cities and looking for clients.
-- d. Seatle is also overstaffed, with a 2:1 employee-client proportion.

-- RIGHT JOIN
-- It is rarely used. We use it when we want all observations from the second (right) table that match the
-- first (left) table.
-- Example: Create a report that shows the number of employees and clients for each city that has clients.ABORT

SELECT
	c.city AS city,
	COUNT(DISTINCT c.customer_id) AS number_of_clients,
	COUNT(DISTINCT e.employee_id) AS number_of_employees
FROM employees e
RIGHT JOIN customers c ON e.city = c.city
GROUP BY 1
ORDER BY c.city;

-- Output:
-- Here, we can observe the number of cities with employees but with no clients.
-- We could adopt strategies to propsect more customers on these cities.

-- FULL JOIN
-- Will bring everything from both tables.
-- Example: Create a report that shows the entire number of clients and customers for each city.
SELECT
	COALESCE(e.city, c.city) AS city,
	COUNT(DISTINCT e.employee_id) AS number_of_employees,
	COUNT(DISTINCT c.customer_id) AS number_of_customers
FROM employees e 
FULL JOIN customers c ON e.city = c.city
GROUP BY e.city, c.city
ORDER BY city;


-- HAVING
-- We use HAVING when we want to filter grouped queries.
-- Example 01: Create a report that shows the total quantity of products below a threshold value.

SELECT
	o.product_id,
	p.product_name,
	SUM(o.quantity) AS total_quantity
FROM order_details o
JOIN products p ON p.product_id = o.product_id
GROUP BY 1, 2
HAVING SUM(o.quantity) < 200
ORDER BY total_quantity DESC;

-- Example 02: Create a report that shows the total number of orders for each client since 1996-12-31.
-- The report must return rows only when the total number of clients is above 15.

SELECT
	o.customer_id,
	COUNT(o.order_id) AS total_orders
FROM orders o
WHERE o.order_date >= '1996-12-31'
GROUP BY o.customer_id
HAVING COUNT(o.order_id) > 15
ORDER BY total_orders DESC;