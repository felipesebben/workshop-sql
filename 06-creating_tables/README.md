# 06 | Creating Tables <!-- omit from toc -->

- [Introduction](#introduction)
- [Context](#context)
- [Initial Setup](#initial-setup)
  - [Manually](#manually)
  - [With Docker and Docker Compose](#with-docker-and-docker-compose)
    - [Setup configuration with Docker](#setup-configuration-with-docker)
- [Subquery](#subquery)

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


# Subquery

