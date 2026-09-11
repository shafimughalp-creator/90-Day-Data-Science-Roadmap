[notes.md](https://github.com/user-attachments/files/32098387/notes.md)
# SQL — Subqueries & Nested Queries

## Quick Overview
- Today's topic: writing queries that contain other queries inside them (subqueries), in three forms — WHERE, FROM, and correlated.
- What I learned: a query can use the *result* of another query as its input, which unlocks questions a single flat query can't answer, like "who is above the average?"
- Tools used: SQLite, DB Browser for SQLite, FC Lahore Lions players/teams/match_stats schema.

## Introduction
- Up to now, filtering meant comparing a column to a fixed value I typed in myself (`WHERE goals > 10`).
- A subquery replaces that fixed value with the *result of another SELECT statement*, so the comparison value is calculated by SQL itself instead of guessed by me.
- This matters because real questions are usually relative, not fixed — "above average," "more than most," "at least one" — and subqueries are how SQL answers those.

## Definitions
- **Subquery (inner query):** a SELECT statement nested inside another SQL statement, usually wrapped in parentheses.
- **Outer query:** the main query that uses the subquery's result.
- **Scalar subquery:** a subquery that returns exactly one value (one row, one column) — used in WHERE with `>`, `<`, `=`.
- **Derived table:** a subquery used inside FROM, treated as a temporary table for the rest of the query.
- **Correlated subquery:** a subquery that references a column from the outer query, so it re-runs once per outer row instead of once total.
- **EXISTS:** a check for whether a subquery returns any row at all — returns TRUE/FALSE, not a value.

## Important Concepts
- **Subquery in WHERE** — runs once, returns one number, outer query compares against it. Example use: "players above the league average."
- **Subquery in FROM** — runs once, returns a mini-table, outer query treats it like any other table (can filter, join, or select from it). Example use: "team averages above 5 goals."
- **Correlated subquery** — runs once *per row* of the outer query, because it depends on that row's value. Example use: "players above their own team's average" (not the whole league).
- **EXISTS vs IN** — EXISTS just checks for presence of at least one matching row and stops as soon as it finds one, which is often faster than IN on large tables.

## Step-by-Step Explanation
1. Write the inner query first, on its own, and run it standalone to confirm it returns what I expect.
2. Wrap it in parentheses.
3. Decide where it belongs:
   - Comparing to a single number → put it in **WHERE**.
   - Need it to act like a table (join/filter/select from) → put it in **FROM** with an alias.
   - Need a value that changes per outer row → make it **correlated** by referencing the outer table's column inside the inner query.
4. For a correlated subquery, alias both the outer and inner reference to the same table differently (e.g. `p1`, `p2`) so SQL knows which "team_id" belongs to which query.
5. Test the outer query and check the row count makes sense (correlated subqueries are the easiest to write logic bugs in).

## Examples
- **WHERE subquery:** `SELECT * FROM players WHERE goals > (SELECT AVG(goals) FROM players);` — players above the league-wide average.
- **FROM subquery:** wrapping a `GROUP BY team_id` average query in parentheses and aliasing it as `team_averages`, then filtering `WHERE avg_team_goals > 5`.
- **Correlated subquery:** `WHERE p1.goals > (SELECT AVG(p2.goals) FROM players p2 WHERE p2.team_id = p1.team_id)` — players above *their own team's* average, not the league's.
- **EXISTS:** checking which teams have at least one player with more than 10 goals, without needing to know how many.

## Common Mistakes
- Forgetting the subquery must return exactly one value when used with `>`, `<`, `=` in WHERE — returning multiple rows throws an error.
- Not aliasing the derived table in FROM — SQLite (and most databases) require every subquery in FROM to have a name.
- Reusing the same table alias for both outer and inner query in a correlated subquery, which makes SQL unable to tell them apart.
- Writing a correlated subquery when a much cheaper GROUP BY + HAVING would answer the same question — correlated subqueries should be the fallback, not the default.
- Assuming EXISTS returns the matching rows — it doesn't, it only returns TRUE/FALSE for filtering.

## Interview Questions
1. What's the difference between a correlated and a non-correlated subquery?
2. When would you use a subquery in FROM instead of just writing a JOIN?
3. Why might EXISTS outperform IN on a large table?
4. Write a query to find employees who earn more than their department's average salary.
5. What error do you get if a WHERE subquery returns more than one row, and how do you fix it?

## Key Takeaways
- A subquery is just a SELECT statement used as an ingredient inside another query.
- Non-correlated subqueries (WHERE, FROM) run once; correlated subqueries run once per outer row.
- "Above average," "at least one," and "more than a threshold" are the classic signals that a question needs a subquery.
- Correlated subqueries are powerful but slower — reach for GROUP BY/HAVING first when it can answer the same question.

## Summary
Today's session covered the three core subquery patterns — WHERE, FROM, and correlated — using the FC Lahore Lions players/teams data to answer relative questions like "who's above the team average?" instead of just fixed-value filters. Practiced translating classic interview questions (department averages, popular products) into the same patterns, plus EXISTS as a faster presence-check alternative to IN.
