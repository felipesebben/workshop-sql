
# 02 | First Queries <!-- omit from toc -->


- [Introduction](#introduction)
- [Goals](#goals)
- [Notes about the lesson](#notes-about-the-lesson)
## Introduction
In this second lesson, we focused on unveiling the main DQL commands, how they behave, their applications and some of their particularities.

## Goals
Our main goals were:
- Understand the main SQL commands
- Review the concepts behind each of the first DQL commands
- Apply some basic queries by trying to answer business-oriented questions

## Notes about the lesson
Although this was a very introductory lesson, I liked to review the basics and remember some particularities. For instance, I forgot that `ROUND()` only works with `NUMERIC` fields and, as such, I had to apply `CAST()` to return a two decimals value.

It was also rewarding to remember some statistics-related aggregate functions such as `PERCENTILE_CONT()`. For mor information, visit the [02-first_DQL_queries.sql](02-first_DQL_queries.sql) file, which contains notes and exercises.