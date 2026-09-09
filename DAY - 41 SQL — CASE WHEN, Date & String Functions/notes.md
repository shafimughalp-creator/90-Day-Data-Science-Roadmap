[notes.md](https://github.com/user-attachments/files/32018530/notes.md)# Day 41 — SQL: CASE WHEN, Date & String Functions

## Quick Overview
- Topic: conditional logic (`CASE WHEN`) plus date and string functions in SQLite.
- What I learned: how to bucket and reshape data inside a single query, group records by month, and clean/combine text columns — no subqueries needed.
- Tools: SQLite, DB Browser for SQLite, FC Lahore Lions schema (`teams`, `players`, `matches`, `match_stats`).

## Introduction
`CASE WHEN` is SQL's version of an if/else statement. Combined with date and string functions, it's the toolkit behind most real-world reporting queries — monthly sales breakdowns, status-based pivots, cleaned-up labels for dashboards.

## Definitions
- **CASE WHEN**: a conditional expression that returns different values depending on which condition matches first.
- **Conditional aggregation**: wrapping `CASE WHEN` inside an aggregate function (like `SUM` or `COUNT`) to turn row-level conditions into pivot-style summary columns.
- **strftime()**: SQLite's date-formatting function, used to reshape a full date into a coarser unit like year-month.
- **String functions**: `SUBSTR()`, `UPPER()`, `LOWER()` for text manipulation, and `||` for concatenation.

## Important Concepts
- `CASE WHEN` checks conditions top to bottom and stops at the first match — order matters.
- Always include an `ELSE` branch so no row falls through with a `NULL`.
- `SUM(CASE WHEN condition THEN 1 ELSE 0 END)` is the standard pattern for counting rows that meet a condition, and it can run alongside other aggregates in the same `GROUP BY`.
- `strftime('%Y-%m', date_column)` truncates a date down to year-month, which is the key to time-based grouping in SQLite (which has no native `DATE_TRUNC`).
- `||` concatenates strings in SQLite (not `+`, which is arithmetic).

## Step-by-Step Explanation
1. Write the base `SELECT` and `FROM`.
2. Add a `CASE WHEN ... THEN ... ELSE ... END` expression as a computed column, or wrap it inside `SUM()`/`COUNT()` for conditional aggregation.
3. For date grouping, wrap the date column in `strftime('%Y-%m', column)` and use that expression in both `SELECT` and `GROUP BY`.
4. For text cleanup, apply `SUBSTR()`, `UPPER()`, `LOWER()`, or `||` directly in the `SELECT` list.
5. Combine both patterns (conditional aggregation + date grouping) for a single-query report.

## Examples
See `day_41_case_when_date_string.sql` for all 6 runnable examples: value bucketing, conditional aggregation, date grouping, string cleanup, concatenation, and the combined monthly report.

## Common Mistakes
- Forgetting the `ELSE` branch in `CASE WHEN`, leaving unmatched rows as `NULL`.
- Using `+` instead of `||` to concatenate strings in SQLite.
- Trying to `GROUP BY` the raw date column instead of the `strftime()` expression, which produces one group per exact timestamp instead of per month.

## Interview Questions
- How would you calculate the number of "paid" vs "unpaid" orders in one query without running two separate queries?
- What's the difference between filtering rows with `WHERE` and bucketing them with `CASE WHEN`?
- How do you group timestamped data by month in SQLite specifically (as opposed to Postgres/MySQL)?

## Key Takeaways
- `CASE WHEN` turns row-level conditions into new columns or pivot-style aggregates.
- `strftime()` is the SQLite-specific way to group data by time period.
- String functions clean and combine text without leaving SQL.

## Summary
Today combined conditional logic with date and string functions to write single-query reports — the exact query shape used in day-to-day reporting and dashboard work, and now demonstrated on the FC Lahore Lions dataset.
