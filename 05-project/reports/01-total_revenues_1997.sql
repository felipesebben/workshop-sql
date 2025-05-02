-- 01. Total Revenues
-- Question: What was the total revenues for the year 1997?
-- Calculate the total revenues
-- Formula: (unit_price * quantity) * (1 - discount)
--     - Will return the revenues minus the discounts that were given


SELECT 
	SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_price
FROM orders o
INNER JOIN order_details od
ON o.order_id = od.order_id
WHERE DATE_PART('year', o.order_date) = 1997


-- Using subquery:

SELECT SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_price
FROM order_details od
INNER JOIN (
	SELECT order_id
	FROM orders
	WHERE DATE_PART('year', order_date) = 1997
) AS o
ON od.order_id = o.order_id;

-- Creating view:

CREATE VIEW total_revenues_1997 AS
SELECT SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS total_revenues_1997
FROM order_details od
INNER JOIN (
	SELECT order_id
	FROM orders
	WHERE DATE_PART('year', order_date) = 1997
) AS o
ON od.order_id = o.order_id;