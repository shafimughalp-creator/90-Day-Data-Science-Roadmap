# Day 37: SQL Filtering, Sorting & NULLs

## Quick Overview
- **Topic:** Filtering rows with `WHERE`, combining conditions with `AND`/`OR`, sorting with `ORDER BY`, getting unique values with `DISTINCT`, and handling missing data with `IS NULL` / `IS NOT NULL`.
- **What I learned:** How to pull exactly the rows I want out of a table, in exactly the order I want, using SQLite.
- **Tools used:** SQLite, DB Browser for SQLite.

## Introduction
Day 37 is part of the SQL phase of my 90-day data science roadmap. Today's practice table, `player_stats`, is a small "FC Lahore Lions"-style squad sheet — 7 players with their position, preferred foot, goals, and assists. Every query below runs against that one table.

## Definitions
- **WHERE** — filters rows *before* they're returned, based on a condition.
- **AND** — keeps a row only if *every* condition is true.
- **OR** — keeps a row if *at least one* condition is true.
- **ORDER BY** — sorts the final result set; `DESC` = highest to lowest, `ASC` = lowest to highest (default).
- **DISTINCT** — removes duplicate values from the result, so you see only unique entries.
- **IS NULL / IS NOT NULL** — checks for missing data. You can't use `= NULL`; SQL requires this special syntax.

## Important Concepts
- Query execution order (logically): `FROM` → `WHERE` → `SELECT` → `ORDER BY`. The table is picked first, then filtered, then columns are chosen, then sorted last.
- `AND` narrows results (fewer rows), `OR` widens results (more rows) — mixing them up is the #1 beginner bug.
- Missing values are their own category — a `NULL` preferred foot isn't `'None'` or `0`, it's genuinely unknown, so `=` can never catch it.

## Step-by-Step Explanation
1. Start from the table: `FROM player_stats`.
2. Filter with `WHERE`: pick a condition like `goals = 12`.
3. Combine conditions with `AND` (both true) or `OR` (either true).
4. Choose columns to return: `SELECT name, goals`.
5. Sort with `ORDER BY column DESC/ASC` if order matters.
6. Add `DISTINCT` right after `SELECT` if duplicates need to disappear.
7. Use `IS NULL` / `IS NOT NULL` instead of `=` when checking for missing data.

## Examples
**Exact match filter** — find the player with exactly 12 goals:
```sql
SELECT name, goals
FROM player_stats
WHERE goals = 12;
```

**Combining conditions with AND** — Left Wingers who are right-footed:
```sql
SELECT name, primary_position, preferred_foot
FROM player_stats
WHERE primary_position = 'Left Winger'
  AND preferred_foot = 'Right';
```

**Sorting with ORDER BY** — right-footed players, most goals first:
```sql
SELECT name, goals
FROM player_stats
WHERE preferred_foot = 'Right'
ORDER BY goals DESC;
```

**Combining conditions with OR** — either wing position:
```sql
SELECT name, primary_position
FROM player_stats
WHERE primary_position = 'Left Winger'
   OR primary_position = 'Right Winger';
```

**Unique values with DISTINCT** — every position on the squad, no repeats:
```sql
SELECT DISTINCT primary_position
FROM player_stats;
```

**Finding missing data with IS NULL** — who has no recorded preferred foot:
```sql
SELECT name, primary_position
FROM player_stats
WHERE preferred_foot IS NULL;
```

## Common Mistakes
- Writing `WHERE preferred_foot = NULL` instead of `WHERE preferred_foot IS NULL` — this silently returns zero rows, no error.
- Forgetting quotes around text values (`WHERE primary_position = Striker` instead of `'Striker'`) — SQLite will throw a "no such column" error.
- Assuming `AND` behaves like everyday English "and" (which often means OR) — in SQL, `AND` is always stricter, never looser.
- Putting `ORDER BY` before `WHERE` in the query — it has to go last.

## Interview Questions
1. What's the difference between `WHERE goals > 5 AND assists > 5` and `WHERE goals > 5 OR assists > 5`?
2. Why does `WHERE column = NULL` never return any rows, even when NULLs exist in that column?
3. In what logical order does SQL actually process `SELECT`, `FROM`, `WHERE`, and `ORDER BY`?
4. What does `SELECT DISTINCT` do differently from a plain `SELECT`?

## Key Takeaways
- `WHERE` filters, `ORDER BY` sorts — they're separate jobs and always go in that order in the query.
- `AND` = stricter/fewer rows, `OR` = looser/more rows.
- NULL is "unknown," not zero or empty — it needs `IS NULL` / `IS NOT NULL`, never `=`.
- `DISTINCT` is a fast way to see the shape of your data (e.g. "what positions exist on this team?").

## Summary
Day 37 covered the core toolkit for slicing a table down to just what's needed: filter with `WHERE`, combine conditions with `AND`/`OR`, sort with `ORDER BY`, deduplicate with `DISTINCT`, and correctly handle missing values with `IS NULL`/`IS NOT NULL`. These six patterns cover a large share of everyday SQL querying.
