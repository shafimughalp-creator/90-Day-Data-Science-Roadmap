[notes.md](https://github.com/user-attachments/files/32098763/notes.md)
# SQL — Window Functions

## Quick Overview
- Today's topic: window functions — ROW_NUMBER, RANK, DENSE_RANK, and running totals with SUM() OVER.
- What I learned: how to rank rows *within groups* and calculate running totals, without collapsing rows the way GROUP BY does.
- Tools used: SQLite, DB Browser for SQLite, FC Lahore Lions players/teams/match_stats schema.

## Introduction
- GROUP BY answers "what's the total/average per group?" but it collapses every row into one summary row per group — you lose the individual rows.
- A window function calculates something across a group of rows ("the window") but keeps every original row visible, just with an extra calculated column attached.
- This is exactly what's needed for "rank each player within their team" or "show a running total as we go" — questions where I need the group-level context AND the row-level detail at the same time.

## Definitions
- **Window function:** a calculation performed across a set of rows related to the current row, without collapsing them into one row.
- **OVER():** the clause that turns an aggregate-style function (SUM, RANK, etc.) into a window function — defines the "window" it operates over.
- **PARTITION BY:** splits the rows into groups (like GROUP BY), but each group's rows stay visible individually.
- **ORDER BY (inside OVER):** sets the order rows are processed in *within* each partition — required for RANK, ROW_NUMBER, and running totals to make sense.
- **ROW_NUMBER():** gives each row a unique sequential number within its partition, no ties possible.
- **RANK() / DENSE_RANK():** rank rows within a partition, both giving tied rows the same rank, but differing in how they number the row(s) after a tie.

## Important Concepts
- **ROW_NUMBER()** — always unique per partition (1, 2, 3, 4...), even if values tie. Good for "give me exactly the top N per group."
- **RANK()** — ties share a rank, and the rank after a tie *skips* ahead (e.g. 1, 2, 2, 4).
- **DENSE_RANK()** — ties share a rank, but the rank after a tie does *not* skip (e.g. 1, 2, 2, 3).
- **Running total (SUM() OVER ORDER BY)** — accumulates a value row by row, in the order specified, restarting at each new partition.
- **LAG()** (bonus) — looks back at the previous row's value within the same partition, useful for match-over-match or period-over-period comparisons.

## Step-by-Step Explanation
1. Identify whether I need a rank/order (ROW_NUMBER, RANK, DENSE_RANK) or a running calculation (SUM, AVG, COUNT with OVER).
2. Decide the grouping: what should the window restart on? That's the PARTITION BY column (e.g. team_id, player_id).
3. Decide the order: what should rows be sorted by inside each group? That's the ORDER BY inside OVER (e.g. goals DESC, match_date ASC).
4. Write `FUNCTION() OVER (PARTITION BY ... ORDER BY ...)` as an extra selected column — the rest of the row stays untouched.
5. For ties, check whether RANK's gap behavior or DENSE_RANK's no-gap behavior is what the question actually wants.

## Examples
- **ROW_NUMBER:** `ROW_NUMBER() OVER (PARTITION BY team_id ORDER BY goals DESC)` — numbers players 1, 2, 3... within their own team by goals.
- **RANK vs DENSE_RANK:** two players tied at rank 2 on the same team — RANK gives the next player rank 4, DENSE_RANK gives them rank 3.
- **Running total:** `SUM(goals_in_match) OVER (PARTITION BY team_id ORDER BY match_date)` — a team's cumulative goal tally match by match across the season.
- **LAG:** comparing a player's goals this match to their goals in the previous match, to spot form swings.

## Common Mistakes
- Forgetting ORDER BY inside OVER() when it's needed — RANK/ROW_NUMBER/running totals are meaningless without a defined order.
- Confusing PARTITION BY with GROUP BY — PARTITION BY keeps all rows, GROUP BY collapses them.
- Using RANK() when the question actually wants no gaps (should've used DENSE_RANK), or vice versa.
- Assuming a running total resets automatically per group — it only resets because of PARTITION BY, not just because ORDER BY changed.
- Not handling the first row's NULL result from LAG() — there's no "previous row" for the very first entry in a partition.

## Interview Questions
1. What's the practical difference between RANK() and DENSE_RANK() when there's a tie?
2. Why would you use ROW_NUMBER() instead of GROUP BY to find the top 3 per category?
3. What does PARTITION BY do differently from GROUP BY?
4. Write a query to compute a running total of sales per store, ordered by date.
5. What happens if you use a window function without an ORDER BY clause inside OVER()?

## Key Takeaways
- Window functions add a calculated column without collapsing rows — GROUP BY collapses, windows don't.
- PARTITION BY defines the groups; ORDER BY (inside OVER) defines the sequence within each group.
- ROW_NUMBER is always unique; RANK skips after ties; DENSE_RANK doesn't skip.
- Running totals and rankings are two of the most commonly interview-tested SQL patterns — this is advanced-SQL territory.

## Summary
Today's session covered the core window function toolkit — ROW_NUMBER, RANK, DENSE_RANK, and running totals via SUM() OVER — using FC Lahore Lions players and match data to rank players within their teams and track cumulative goals over the season. Practiced translating classic interview questions (ranking salespeople per region, cumulative sales per store) into the same PARTITION BY / ORDER BY pattern, plus a first look at LAG() for row-to-row comparisons.
