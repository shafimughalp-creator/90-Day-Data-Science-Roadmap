# SQL — Aggregates & GROUP BY + HAVING

## Quick Overview
- **Topic:** SQL aggregate functions (COUNT, SUM, AVG, MIN, MAX) combined with GROUP BY and HAVING
- **What I learned:** How to summarize raw rows into per-group reports, and the exact difference between filtering *before* grouping (WHERE) vs filtering *after* grouping (HAVING)
- **Tech/tools used:** SQLite, DB Browser for SQLite, a small `players` / `match_stats` schema (FC Lahore Lions dataset)

## Introduction
- Up to now, queries returned one row per row in the table (raw rows).
- Aggregate functions let SQL collapse many rows into a single summary value — total goals, average minutes, etc.
- GROUP BY takes that one step further: instead of one summary for the whole table, you get one summary **per group** (e.g., per player).
- This is the single most-tested SQL pattern in data science interviews, because almost every real reporting question ("total revenue per category", "average salary per department") is a GROUP BY + aggregate question.

## Definitions
- **Aggregate function** — a function that takes many rows and returns one value (COUNT, SUM, AVG, MIN, MAX)
- **COUNT()** — counts rows (or non-NULL values in a specific column)
- **SUM()** — adds up all values in a numeric column
- **AVG()** — calculates the mean of a numeric column
- **MIN() / MAX()** — smallest / largest value in a column
- **GROUP BY** — splits the table into buckets based on one or more columns, then runs the aggregate separately for each bucket
- **HAVING** — a WHERE clause that runs *after* GROUP BY, used to filter the grouped/aggregated results
- **Logical execution order** for a query with all clauses: `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT`

## Important Concepts
- **WHERE vs HAVING is the classic interview question:**
  - `WHERE` filters raw rows **before** grouping happens — it never sees an aggregate value.
  - `HAVING` filters the grouped rows **after** aggregation — it's the only place you can write `HAVING SUM(goals) > 2`.
  - Using an aggregate inside WHERE (e.g. `WHERE SUM(goals) > 2`) is a common beginner mistake and will error in SQLite.
- Every non-aggregated column in SELECT must appear in GROUP BY (SQLite is lenient about this, but most databases enforce it strictly).
- ORDER BY and LIMIT always run last, after the grouping/filtering is done — they just arrange and trim the final result set.
- COUNT(*) counts all rows in a group; COUNT(column) only counts non-NULL values in that column — worth knowing when a column can have gaps.

## Step-by-Step Explanation
1. Start from the source table (`FROM`).
2. Apply row-level filters first (`WHERE`) — this removes rows before any grouping happens.
3. Split the remaining rows into buckets (`GROUP BY player_id`).
4. Run the aggregate function separately inside each bucket (`SUM`, `AVG`, etc.).
5. Filter the *bucket-level* results (`HAVING`) — this is where aggregate conditions belong.
6. Sort the final grouped rows (`ORDER BY`).
7. Trim to the top N rows if needed (`LIMIT`).

## Examples
- Basic multi-aggregate summary over the whole table:
  ```sql
  SELECT
      COUNT(*) AS total_rows,
      SUM(goals) AS total_goals,
      AVG(assists) AS avg_assists
  FROM match_stats;
  ```
- Per-player total goals, sorted highest to lowest:
  ```sql
  SELECT
      player_id,
      SUM(goals) AS total_goals
  FROM match_stats
  GROUP BY player_id
  ORDER BY total_goals DESC;
  ```
- WHERE (before grouping) vs HAVING (after grouping) in the same query:
  ```sql
  SELECT
      player_id,
      SUM(goals) AS total_goals
  FROM match_stats
  WHERE minutes_played >= 60        -- row-level filter, runs first
  GROUP BY player_id
  HAVING SUM(goals) > 1             -- group-level filter, runs after
  ORDER BY total_goals DESC;
  ```
- Top scorer only, using AVG + ORDER BY + LIMIT:
  ```sql
  SELECT
      player_id,
      AVG(minutes_played) AS avg_minutes
  FROM match_stats
  GROUP BY player_id
  ORDER BY avg_minutes DESC
  LIMIT 1;
  ```

## Common Mistakes
- Writing an aggregate condition inside WHERE instead of HAVING (`WHERE SUM(goals) > 2` → error).
- Forgetting that WHERE and HAVING can both appear in the same query, doing two different jobs.
- Assuming GROUP BY sorts the output — it doesn't; you still need ORDER BY.
- Selecting a column that isn't aggregated and isn't in GROUP BY, then being confused about which row's value SQLite picked.

## Interview Questions
- What's the difference between WHERE and HAVING, and why can't you use an aggregate function in WHERE?
- Write a query to find the total revenue per product category, showing only categories with revenue over $10,000.
- What's the difference between COUNT(*) and COUNT(column_name)?
- What order do SQL clauses logically execute in, and why does that matter for GROUP BY/HAVING?

## Key Takeaways
- Aggregates collapse rows into a single summary value; GROUP BY does that per bucket instead of for the whole table.
- WHERE filters rows before grouping; HAVING filters groups after aggregation — never mix the two up.
- ORDER BY and LIMIT always come last in the logical order, regardless of where they're written in the syntax.

## Summary
Today covered the core SQL reporting toolkit: COUNT, SUM, AVG, MIN, MAX combined with GROUP BY to build per-player summaries from the `match_stats` table, and HAVING to filter those summaries after aggregation. The WHERE-vs-HAVING distinction — filtering rows before grouping vs filtering groups after — was the main interview-relevant concept, practiced through a series of leaderboard-style queries (top scorer, players with more than N matches, filtered goal totals) using the FC Lahore Lions dataset.
