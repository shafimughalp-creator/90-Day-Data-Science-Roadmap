[Uploading notes.md…]()
# SQL — CTEs (Common Table Expressions)

## Quick Overview
- Today's topic: CTEs — naming a query with `WITH` and reading from it like a table, including chaining multiple CTEs together.
- What I learned: CTEs solve the exact same problems as subqueries, but read top-to-bottom instead of nested inside-out, and can be reused or chained.
- Tools used: SQLite, DB Browser for SQLite, FC Lahore Lions players/teams/match_stats schema.

## Introduction
- Day 43's subqueries work, but nested subqueries get hard to read fast — especially a subquery inside a subquery, or one query needed twice.
- A CTE (`WITH name AS (...)`) gives a subquery a name and pulls it up to the top of the query, so the rest of the query reads like a sequence of steps instead of a block of nested parentheses.
- This is the difference between "senior-level readable SQL" and "SQL that only the original author can follow."

## Definitions
- **CTE (Common Table Expression):** a named, temporary result set defined with `WITH`, that exists only for the duration of the query it's attached to.
- **WITH clause:** the keyword that starts a CTE definition — `WITH cte_name AS (SELECT ...)`.
- **Chained CTEs:** multiple CTEs defined in sequence, each one allowed to reference the CTE(s) before it.
- **Recursive CTE:** a CTE that references itself, repeating until a stop condition is met — used for sequences, hierarchies, and generating rows that don't exist in a table.

## Important Concepts
- **Basic CTE** — same logic as a FROM-subquery, but named and placed before the main query instead of nested inside it.
- **Chaining** — each CTE can be a clean, named step (`team_totals` → `ranked_teams`), turning a multi-stage problem into readable stages instead of one deeply nested query.
- **Reuse** — a CTE is defined once and can be referenced multiple times in the same query (in a JOIN and in a WHERE subquery, for example) without repeating the logic.
- **CTEs vs subqueries** — functionally often identical, but CTEs win on readability, reusability within a query, and are required for recursion (subqueries can't recurse).
- **Recursive CTE** — has an "anchor" (the starting row) and a "recursive" part that refers back to the CTE itself, plus a stop condition to avoid an infinite loop.

## Step-by-Step Explanation
1. Identify the subquery (or subqueries) I'd normally nest inside FROM or WHERE.
2. Pull each one out, give it a clear name, and define it with `WITH name AS (...)`.
3. If one step depends on another, chain them: `WITH step1 AS (...), step2 AS (...) SELECT ... FROM step2`.
4. Write the main SELECT at the end, reading from the CTE name(s) like normal tables.
5. If the same calculated result is needed twice in the final query, reference the CTE name again instead of rewriting the logic.

## Examples
- **Basic CTE:** `WITH team_averages AS (SELECT team_id, AVG(goals) FROM players GROUP BY team_id) SELECT * FROM team_averages WHERE avg_team_goals > 5;`
- **Chained CTEs:** compute `team_totals` first, then build `ranked_teams` on top of it using `RANK()`.
- **Reused CTE:** `team_averages` used once in a JOIN and again inside a WHERE subquery, without being redefined.
- **Recursive CTE:** generating matchday numbers 1 through 10 with no physical table backing them, for building a full season calendar.

## Common Mistakes
- Forgetting a CTE only exists for the single query it's attached to — it isn't saved anywhere and can't be reused in a later, separate query.
- Chaining CTEs in the wrong order — a later CTE can reference an earlier one, but not the other way around.
- Writing a recursive CTE without a stop condition, which can loop indefinitely.
- Assuming a CTE is automatically faster than a subquery — in SQLite specifically, it's mainly a readability/reuse win, not a guaranteed performance win.
- Reintroducing nested subqueries out of habit instead of naming the step as a CTE, even when the query is getting hard to follow.

## Interview Questions
1. What does a CTE do that a subquery can't?
2. How would you chain two CTEs where the second depends on the first?
3. What are the two required parts of a recursive CTE?
4. Rewrite a nested subquery of your choice using a CTE — what changed about readability?
5. Does a CTE persist across multiple queries, or only for the one it's defined in?

## Key Takeaways
- CTEs are subqueries with a name, pulled to the top of the query instead of nested inside it.
- Chaining CTEs turns a multi-step problem into a readable sequence of named stages.
- A CTE can be referenced multiple times in the same query without repeating its logic.
- Recursive CTEs are the one thing subqueries genuinely can't do — needed for sequences and hierarchies.

## Summary
Today's session covered CTEs as the more-readable alternative to Day 43's subqueries — basic CTEs, chaining multiple CTEs together, reusing a CTE within one query, and a first look at recursive CTEs for generating sequences. Rewrote two of Day 43's subquery examples (the correlated subquery and the FROM-subquery) as CTEs for a direct side-by-side readability comparison.
