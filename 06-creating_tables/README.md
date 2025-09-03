# 06 | Creating Tables <!-- omit from toc -->

- [Introduction](#introduction)
- [Context](#context)
- [Initial Setup](#initial-setup)
  - [Manually](#manually)
  - [With Docker and Docker Compose](#with-docker-and-docker-compose)
    - [Setup configuration with Docker](#setup-configuration-with-docker)
- [Subqueries](#subqueries)
- [CTEs](#ctes)
  - [Why use them?](#why-use-them)
  - [When not to use it](#when-not-to-use-it)
  - [Syntax](#syntax)
- [Views](#views)
  - [Syntax](#syntax-1)
  - [When to use it](#when-to-use-it)
  - [Granting access](#granting-access)

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


# Subqueries

# CTEs

## Why use them?
- **CTEs are easier to understand**. You can divide your logic into smaller parts, each of them playing a specific role. 
- **They are easier to maintain**. Because they are divided according to a specific functionality, they are easier to debug.
- **They can be referenced many times in a query**. 

## When not to use it
In case of legacy, older databases, using CTEs may sometimes lead to losing the index. 

## Syntax

```sql
WITH cte_name (column1, column2, ...) AS (
    -- CTE Query Definition
    SELECT ...
    FROM ...
    WHERE ...
)
-- Main Query that references the CTE
SELECT ...
FROM cte_name
WHERE ...;
```

- CTEs require:
  - `WITH`: this keyword initiates the definition of one or more CTEs.
  - `cte_name`: the name you assign to the CTE. It is used to reference the CTE in the main query, treating it like a temporary table.
  - `(column1, column2, ...)`: optional list of colum names for the CTE's result set. If ommitted, the column names from the `SELECT` statement within the CTE will be used.
  - `AS`: precedes the CTE's query definition.
  - `-- CTE Query Definition`: the `SELECT` statement that defines the data set for the CTE.
  - `-- Main Query that references the CTE`: the final query that uses the CTE as if it were a regular table or view.
  
  
# Views
As the previous operations, views do not create new tables. It is a different way to query the data.
- CTEs and Subqueries are only accessible during a query session and are not retained after it is closed.
- **Views** can be queried from other sessions/places.
  - They have **persistent metadata** (not the data, though). Your query will be stored but not the data itself.
   
## Syntax
```sql
CREATE VIEW view_name AS
SELECT
  column1,
  column2,...
FROM table_name;

SELECT * from view_name;
```

## When to use it
- If your query must be used recurrently, creating a view may be a better solution.
- If your team needs to use the same query constantly and you want to avoid mistakes/inconsistencies.

## Granting access
- You can create a view and grant access to a specific user group.

```sql
GRANT SELECT ON <viewname> TO <usergroup>
```
  
