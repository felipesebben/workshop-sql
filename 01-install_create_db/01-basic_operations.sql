-- LESSON 1 | FIRST QUERIES
-- Example of full query using `*`
SELECT * FROM categories;

-- Querying specific columns.
SELECT 
	e.address, 
	e.birth_date
FROM employees e;

-- Using DISTINCT
-- Get all first names from customers
SELECT c.contact_name
FROM customers c;

-- Split full name and get only the first name.
SELECT 
	c.contact_name,
	SPLIT_PART(c.contact_name, ' ', 1) AS first_name
FROM customers c;

-- Get DISTINCT first names.
SELECT
	DISTINCT(SPLIT_PART(c.contact_name, ' ', 1)) AS first_name
FROM customers c;

-- Use DISTINCT COUNT to get the number of unique first names
SELECT
	COUNT(DISTINCT(SPLIT_PART(c.contact_name, ' ', 1))) AS first_name_count
FROM customers c;

-- Use DISTINCT ON to keep only the first row of each set of rows where the given expressions
-- evaluate to equal. Here, get the most recent freight value for each country.
SELECT DISTINCT ON(o.ship_country) o.ship_country, o.freight, o.order_date
FROM orders o
ORDER BY o.ship_country, o.order_date DESC;

-- WHERE clause. Use it to filter VALUES
-- Select all customers from Argentina
SELECT
	c.contact_name,
	c.contact_title,
	c.city,
	c.region
FROM customers c
WHERE c.country = 'Argentina';

-- Select clients with a specific ID value.
SELECT
	c.contact_name,
	c.contact_title,
	c.city,
	c.region
FROM customers c
	WHERE customer_id = 'ANATR';

-- Use AND to apply multiple conditions.
SELECT
	c.contact_title,
	c.contact_name,
	c.company_name
FROM customers c
	WHERE c.country = 'Brazil' AND c.city = 'Sao Paulo';

-- Use OR to apply multiple, non-exclusive conditions.
SELECT
	DISTINCT c.country,
	c.city
FROM customers c
GROUP BY 1, 2
ORDER BY 1 ASC;

SELECT
	c.contact_title,
	c.contact_name,
	c.company_name	
FROM customers c
	WHERE c.city = 'Rio de Janeiro' OR c.city = 'Campinas';

-- Use <> to exclude country.
SELECT
	c.contact_title,
	c.contact_name,
	c.company_name	
FROM customers c
	WHERE c.country <> 'Brazil';

-- Combine AND, OR, and NOT.
SELECT
	c.contact_title,
	c.contact_name,
	c.company_name	
FROM customers c
	WHERE c.country = 'Brazil' AND (c.city = 'Rio de Janeiro' OR c.city = 'Campinas');

-- Using LIKE and IN to look for patterns and list of values.
-- Select customers where the city contains 'Paulo' (useful if more than one way of writing São Paulo had been inserted).
SELECT 
	c.customer_id,
	c.company_name,
	c.contact_name,
	c.contact_title,
	c.region
FROM customers c
WHERE c.city LIKE ('%Paulo');

-- Get clients in which the company's first letter is different than 'a'.
SELECT 
	c.customer_id,
	c.company_name,
	c.contact_name,
	c.contact_title,
	c.region
FROM customers c
WHERE UPPER(c.company_name) NOT LIKE ('%A%');


-- Get customers from specific cities.
SELECT *
FROM customers c
WHERE c.city IN('Buenos Aires', 'Berlin', 'Campinas');

-- Get customers NOT from specific countries.
SELECT *
FROM customers c
WHERE c.country NOT IN('Argentina', 'Germany', 'Berlin');


-- ORDER BY
-- Sort values by country (default = ASC)
SELECT
	*
FROM customers c
ORDER BY c.country;

-- Sort values by country descending
SELECT
	*
FROM customers c
ORDER BY c.country DESC;

-- Sort values first by country name, then by contact name.
SELECT
	*
FROM customers c
ORDER BY c.country, c.contact_name;

-- Sort values first by country name ASC, then by contact name DESC.
SELECT
	*
FROM customers c
ORDER BY c.country ASC, c.contact_name DESC;