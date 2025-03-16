
# 03 | Joins <!-- omit from toc -->


- [Introduction](#introduction)
- [Goals](#goals)
- [Notes about the lesson](#notes-about-the-lesson)
  - [Primary and Foreign Keys](#primary-and-foreign-keys)
  - [Data normalization](#data-normalization)
  - [Left Join](#left-join)
  - [`JOIN`s beyond Primary and Foreign Keys](#joins-beyond-primary-and-foreign-keys)
  - [Right Join](#right-join)
  - [Full Join](#full-join)
  - [...what about the Cross Join?](#what-about-the-cross-join)
  - [`HAVING`](#having)
## Introduction
In this second lesson, we focused on JOIN operations.

## Goals
Our main goals were:
- Understand how each JOIN operation works
- Underline the importance of paying attention to the **question** that is asked and how it affects the type of `JOIN` we need to use
- Consider the importance of normalization in today's data environment vis-a-vis costs.
- Understand how `HAVING` works.

## Notes about the lesson

### Primary and Foreign Keys
**Primary key** [PK] - it is a distinct value for each line that **cannot be repeated**. It is the **unique identifier** of an observation.

**Foreign Key [FK]** - it is the primary key from another table. We use it to establish relationships between tables.

### Data normalization
The goal of normalizing data is to get a set of dimensions and store them in a table with unique values and categories only. For a `countries` table, we would have one register for each country, each of them assigned to a primary key. This table would be joined with others with this primary key. We create a  `DISTINCT` of each dimension and store them in a table. This modelling approach would save money as it would be more efficient in terms of storage usage.

| **Question**: with the dwindling costs of data today, is it worth normalizing the data? I guess it depends on the context of the company.


### Left Join

We use it when we want to keep the `NULLS` from the right table. We priorituze the **left** table, which will remain intact even when no identity is established between some values. 

### `JOIN`s beyond Primary and Foreign Keys

We don't need to use `FK` and `PK` to perform joins. As long as the columns have the **same datatype**, we can perform a `JOIN` operation (i.e. two tables with the column `city`).

### Right Join

It is the reverse of `LEFT JOIN` and it is kind of weird - it returns all the values of the table from the  **right**. We could think about queswtions such as the number of unnattended customers for each city, for instance.

### Full Join

Brings all values from both tables. We can use `COALESCE` to filter out the null values. When performing analyses, it can be useful we want to answer questions that need "the bigger picture". We can take a look at the following query using the `Northwind` database:
```SQL
SELECT
	c.city AS city,
	COUNT(DISTINCT c.customer_id) AS number_of_clients,
	COUNT(DISTINCT e.employee_id) AS number_of_employees
FROM employees e
RIGHT JOIN customers c ON e.city = c.city
GROUP BY 1
ORDER BY c.city;
```
This query will return:
- All cities present in both tables.
- The number of clients for each city.
- The number of employees for each city.

Having these observations, we can ask questions such as:
- Which cities have clients but no employees (and vice-versa)?
- Are there any cities in which we are understaffed/overstaffed vis-à-vis the number of customers?
- Are there any cities where no customers or employees were registered?

### ...what about the Cross Join?

The `CROSS JOIN` performas  **factorial** operation. It links every single value from a table with every single other value from the other table. Also called **cartesian product**, the result is a multiplication of all values from the first table by the ones from the second table.

### `HAVING`
`HAVING` will define a filter for grouped values. As such, it cannot be used without a  `GROUP BY` clause. Let's take a look at two examples.

```SQL
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
```
In this case, we want to obtain the sum of quantity for each product and each customer. That is, for customer A, we will get the quantity they bought for each product. However, because of the `HAVING` clause, we will get rows in which the  `total_quantity` is below `200`. We will see which customers bought total quantities below this threshold value for each product.

```SQL
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
```
In this second example, we want to get the total count of orders for each customer since December 31st, 1996. However, we are only concerned with customers that made more than 15 orders. To answer this question, apart from using `WHERE` to filter the `order_date`, we use `HAVING` to return the total number of orders that were above 15.