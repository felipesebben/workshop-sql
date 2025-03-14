
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
## Introduction
In this second lesson, we focused on JOIN operations.

## Goals
Our main goals were:
- Understand how each JOIN operation works
- Underline the importance of paying attention to the **question** that is asked and how it affects the type of `JOIN` we need to use
- Consider the importance of normalization in today's data environment vis-a-vis costs.

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

Brings all values from both tables. We can use `COALESCE` to filter out the null values. 

### ...what about the Cross Join?

The `CROSS JOIN` performas  **factorial** operation. It links every single value from a table with every single other value from the other table. Also called **cartesian product**, the result is a multiplication of all values from the first table by the ones from the second table.