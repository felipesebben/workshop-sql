# 05 | Project – Advanced Reports using SQL Northwind <!-- omit from toc -->

- [Introduction](#introduction)
- [Context](#context)
- [Initial Setup](#initial-setup)
  - [Manually](#manually)
  - [With Docker and Docker Compose](#with-docker-and-docker-compose)
    - [Setup configuration with Docker](#setup-configuration-with-docker)
- [Reports](#reports)
  - [1. Revenue Reports – yearly revenues](#1-revenue-reports--yearly-revenues)
  - [2. Cumulative YTD Revenues](#2-cumulative-ytd-revenues)

# Introduction
In this section, we will present a few advanced reports built using SQL. The available analyses can be reproduced in different company scenarios. Throughout these reports, companies may extract valuable insights from their data, assisting in the decision-making process.

# Context
The `Northwind` database contains sales data from a ficticious company named `Northwind Traders`, which exports and imports specialty foods from all over the world.

The database is an Enterprise Resource Planning (ERP) that integrates business processes and data sources across departments. It presents data for clients, orders, inventory, suppliers, employees, and accounting.

The dataset includes sample data for the following areas:
- **Suppliers**: Suppliers and salespersons
- **Clients**: Clients that bought products from Northwind
- **Employees**: Northwind employees and their details
- **Products**: Product information
- **Logistics**: Information on the freight companies that provide services to Northwind
- **Orders and Order Details**: Transaction information of orders between clients and the company


`Northwind` includes 14 tables, while the relationships between the tables are shown in the following entity-relationship model.

![northwind_model](/05-project/assets/northwind-er-diagram.png)

# Initial Setup
## Manually
You can use the file `northwind.sql` to populate your database.

## With Docker and Docker Compose
**Requirements**: Install Docker and Docker Compose
- [Start with Docker](https://www.docker.com/get-started/)
- [Install Docker Compose](https://docs.docker.com/compose/install/)

### Setup configuration with Docker
01. Start Docker Compose by executing the following commmand:
   ```
   docker-compose up
   ```

02. Connect `PgAdmin` by accessing the url http://localhost:5050 and use the password `postgres`.
   - You can then configure a new server in `PgAdmin`:
     ```
     - Name: db
     - Hostname: db
     - Username: postgres
     - Password: postgres
     ```
 03. Stop Docker Compose using the command `Ctrl+C`. To remove the containers, use:
      ```
      docker-compose down
      ```
 04. Files and Persistency. Any modifications on the Postgres database will persist in the volume `postgresl_data` and can be recovered when restarting Docker Compose with the `docker-compose up` command. To permanently remove files from the database, execute:
      ```
      docker-compose down -v
      ```


# Reports

## 1. Revenue Reports – yearly revenues
The first report aimed at answering the question: 
- *How did our sales perform in the year 1997*? 

Here is how we've built the query using three different methods:

```SQL
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
```

Method #1 creates a simple SQL query that sums the total revenues minus the discount values. Method #2 uses a subquery to filter the `orders` table before performing the `INNER JOIN` operation. Method #3 stores the result as a view that persists in the database and can be reused in the future.

## 2. Cumulative YTD Revenues
This report aimed at answering the question:
- *How are our sales doing at a monthly basis*?
- *How did they perform in relation to the previous month in an absolute and relative comparison*?
- *How are they performing in a YTD basis considering the cumulative sum of sales*?

Here is how we've achieved our results:
```SQL
-- 02. YTD calculation and monthly growth analysis

/* Monthly Revenues
	- EXTRACT of YEAR and MONTH
	- Total monthly quantities
	- JOIN orders and order_details
	- GROUP BY YEAR and MONTH
*/
WITH monthly_revenues AS (
	SELECT
		EXTRACT(YEAR FROM o.order_date) AS year,
		EXTRACT(MONTH FROM o.order_date) AS month,
		SUM((od.unit_price * od.quantity) * (1 - od.discount)) AS month_revenue
	FROM orders o
	JOIN order_details od
		ON o.order_id =  od.order_id
	GROUP BY 1, 2
	ORDER BY 1, 2
),
-- YTD Monthly Revenues

ytd_monthly_revenues AS (
	SELECT
		month,
		year,
		month_revenue,
		SUM(month_revenue) OVER (PARTITION BY year ORDER BY month) AS ytd_revenue
	FROM monthly_revenues
)
/*
Use LAG to get the monthly progression and the difference between each month. 
Get:
- Difference from previous month
- Percentage difference from previous month.
*/
SELECT
	year,
	month,
	month_revenue,
	month_revenue - LAG(month_revenue) OVER(PARTITION BY year ORDER BY month) AS month_diff,
	(month_revenue - LAG(month_revenue) OVER(PARTITION BY year ORDER BY month)) / LAG(month_revenue) OVER(PARTITION BY year ORDER BY month) AS month_pct_diff,
	ytd_revenue
FROM ytd_monthly_revenues
ORDER BY 1, 2;
```

First, we created one **common table expression** (CTE) named `monthly_revenues`. We extracted the month and year parts of `order_date` as two separate columns. Then, we got the `monthly_revenue` for each month, grouping the result by `year` and `month`. Then, we created another CTE named `yte_monthly_revenues` by selecting the previous CTE and adding a **window function** calculation named `yte_revenue`. It partitioned the data by `year` and summed the `month_revenue`, ordering the result by `month`. Finally, using this CTE, we created a query that returns the results and calculates the absolute and percentage difference between each month and the previous month. We used `LAG(month_revenue)` to get the previous value partitioned by `year` and ordered by `month`.