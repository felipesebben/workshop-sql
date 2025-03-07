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

-- 3.1.1 Operator '<'
-- Question: In which orders was the applied discount lower than 10%? 

SELECT
	od.order_id,
	od.unit_price,
	od.quantity,
	od.discount
FROM order_details od
WHERE od.discount < 0.1
ORDER BY od.discount DESC ,od.quantity DESC, od.unit_price DESC;

-- 3.1.1 Operator '<='
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

-- 3.1.1 Operator '>='
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

-- 3.1.1 Operator '<>'/'!='

-- 3.1.1 Operator '<'

-- 3.1.1 Operator '<'