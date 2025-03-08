/*
02 | Main DQL Operations

1. SELECT - the fundamental command in DQL, it is used to select data from one or more tables.
*/
SELECT
	c.contact_name,
	c.contact_title,
	c.city, 
	c.country
FROM customers c;

-- 2. DISTINCT - returns only distinct values.

SELECT
	o.employee_id
FROM orders o;

SELECT
	DISTINCT o.employee_id
FROM orders o;

SELECT
	COUNT(DISTINCT o.employee_id)
FROM orders o;

-- 3. WHERE - filters the data based on defined conditions.

SELECT 
	DISTINCT o.ship_city
FROM orders o;

SELECT
	o.order_id,
	o.customer_id,
	o.order_date,
	o.freight
FROM orders o
WHERE o.ship_city IN('Butte', 'San Francisco');


-- 3.1 OPERATORS
-- 3.1.1 Operator '>'
-- Question: In which orders did the freight cost more than $15? What was their shipping details?

SELECT
	o.order_id,
	o.freight,
	o.ship_city,
	o.ship_country
FROM orders o
WHERE o.freight > 15
ORDER BY o.freight DESC, o.ship_country ASC;

-- 3.1.2 Operator '<'
-- Question: In which orders was the applied discount lower than 10%? 

SELECT
	od.order_id,
	od.unit_price,
	od.quantity,
	od.discount
FROM order_details od
WHERE od.discount < 0.1
ORDER BY od.discount DESC ,od.quantity DESC, od.unit_price DESC;

-- 3.1.3 Operator '<='
-- Question: Which products have less or equal units on order than in stock? 

SELECT 
	p.product_id,
	p.product_name,
	p.units_in_stock,
	p.units_on_order,
	ABS(p.units_in_stock - p.units_on_order) AS stock_order_difference
FROM products p
WHERE p.units_in_stock <= units_on_order
ORDER BY stock_order_difference DESC;

-- 3.1.4 Operator '>='
-- Question: Which products have more or equal units on order than in stock? We want to know
-- if we have too much products in stock with a low number of orders.

SELECT 
	p.product_id,
	p.product_name,
	p.units_in_stock,
	p.units_on_order,
	ABS(p.units_in_stock - p.units_on_order) AS stock_order_difference
FROM products p
WHERE p.units_in_stock >= units_on_order
ORDER BY stock_order_difference DESC, p.units_on_order DESC;

-- 3.1.5 Operator '<>'/'!='
-- Question: How many employees that are not Sales Representatives are there in the company?

SELECT 
COUNT(*)
FROM employees e
WHERE UPPER(e.title) != 'SALES REPRESENTATIVE';

-- 3.1.6 Operator '<'
-- Question: Which countries do we have less than 2 suppliers?

SELECT
	s.country, 
	COUNT(DISTINCT(s.supplier_id)) AS supplier_count
FROM suppliers s
GROUP BY s.country
HAVING COUNT(DISTINCT(s.supplier_id)) < 2;

-- 3.1.7 Operator '>'
-- Question: Which countries do we have more than 2 suppliers?

SELECT
	s.country, 
	COUNT(DISTINCT(s.supplier_id)) AS supplier_count
FROM suppliers s
GROUP BY s.country
HAVING COUNT(DISTINCT(s.supplier_id)) > 2
ORDER BY supplier_count DESC;

-- 3.2 Combining operators
-- 3.2.1 '<' AND '>='
-- Question: Which products have a unit price between 50 and 100?
SELECT
	p.product_id,
	p.product_name,
	p.unit_price
FROM products p
WHERE p.unit_price BETWEEN 50 AND 100 -- Can also be written as p.unit_price >= 50 AND p.unit_price <= 100
ORDER BY p.unit_price DESC;

-- 3.3 Using 'IS NULL'/'IS NOT NULL'
-- Question: Which suppliers have their region field null?
SELECT
	s.company_name,
	s.city,
	s.country,
	s.region
FROM suppliers s
WHERE s.region IS NULL
ORDER BY s.country ASC;

-- 3.3 Using 'LIKE'
-- Question: Which customers' names have their initial letter as an "R"?
SELECT
	c.contact_name
FROM customers c
WHERE UPPER(c.contact_name) LIKE 'R%'
ORDER BY c.contact_name ASC;

-- 4. AGGREGATE FUNCTIONS
-- Question: what are some of the statistics we can get from our unit prices?

SELECT
	COUNT(*) AS n_products,
	MIN(p.unit_price) AS min_unit_price,
	MAX(p.unit_price) AS max_unit_price,
	ROUND(AVG(CAST(p.unit_price AS NUMERIC)),2) AS avg_unit_price,
	MODE() WITHIN GROUP (ORDER BY p.unit_price) AS mode_unit_price,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.unit_price) AS quartile_25, 
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY p.unit_price) AS quartile_50, 
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.unit_price) AS quartile_75,
	(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY p.unit_price)
	- PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY p.unit_price)) AS IQR,
	ROUND(STDDEV_POP(CAST(p.unit_price AS NUMERIC)),2) AS std_dev_unit_price,
	ROUND(VAR_POP(CAST(p.unit_price AS NUMERIC)),2) AS variance_unit_price
FROM products p;



