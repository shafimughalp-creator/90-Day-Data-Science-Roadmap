# OUTER JOINs

## Quick Overview
- **Topic:** OUTER JOINs (LEFT, RIGHT, FULL) in SQL
- **What I learned:** how to keep "unmatched" rows in a join instead of silently dropping them, and how to use that to find missing data (players with no team, teams with no players)
- **Tools:** SQLite, DB Browser for SQLite

## Introduction
An INNER JOIN only keeps rows that match on both sides — anything unmatched just disappears. That's a problem when the unmatched rows are exactly what you need to see (a free agent with no team, a club with an empty roster). OUTER JOINs solve this by keeping those rows and filling the missing side with `NULL`.

## Definitions
- **OUTER JOIN** — a join that preserves unmatched rows from one or both tables, filling the other side with `NULL`.
- **LEFT JOIN** — keeps every row from the first (left) table.
- **RIGHT JOIN** — keeps every row from the second (right) table.
- **FULL OUTER JOIN** — keeps every row from both tables.
- **Anti-join** — LEFT/RIGHT JOIN + `WHERE ... IS NULL`, used to isolate only the unmatched rows.
- **COALESCE()** — returns the first non-NULL value from a list; used to replace NULLs with a readable default.

## Important Concepts
- Table order matters: in `FROM players p LEFT JOIN teams t`, `players` is "left," `teams` is "right."
- Any RIGHT JOIN can be rewritten as a LEFT JOIN by swapping table order.
- SQLite only added RIGHT JOIN and FULL OUTER JOIN support in version 3.39+.
- `= NULL` never evaluates true — always use `IS NULL` / `IS NOT NULL`.
- Filtering an outer join in `WHERE` (instead of `ON`) can silently turn it back into an INNER JOIN by dropping the NULL rows.

## Step-by-Step Explanation
1. Decide which table's unmatched rows you need to keep — that decides LEFT vs RIGHT.
2. Write the JOIN with the matching column in `ON`.
3. If you need *only* the unmatched rows, add `WHERE <right_table>.<key> IS NULL` (anti-join).
4. If you need every row from both tables, use `FULL OUTER JOIN`.
5. Optionally wrap NULL-prone columns in `COALESCE()` for a cleaner output.

## Examples
```sql
-- All players, team or no team
SELECT p.player_name, p.goals, t.team_name
FROM players p
LEFT JOIN teams t ON p.team_id = t.team_id;

-- Only players with no team (anti-join)
SELECT p.player_name, p.goals
FROM players p
LEFT JOIN teams t ON p.team_id = t.team_id
WHERE t.team_id IS NULL;

-- Only teams with no players (anti-join, right side)
SELECT t.team_name
FROM players p
RIGHT JOIN teams t ON p.team_id = t.team_id
WHERE p.player_id IS NULL;

-- Everyone, either direction
SELECT p.player_name, t.team_name
FROM players p
FULL OUTER JOIN teams t ON p.team_id = t.team_id;
```

## Common Mistakes
- Filtering an outer join in `WHERE` instead of `ON`, which turns it back into an INNER JOIN.
- Using `= NULL` instead of `IS NULL`.
- Forgetting which table is "left" and getting the wrong unmatched rows kept.
- Assuming RIGHT JOIN / FULL OUTER JOIN are supported everywhere (MySQL has no FULL OUTER JOIN; older SQLite has neither).

## Interview Questions
1. What's the difference between INNER JOIN and LEFT JOIN?
2. How would you find all customers who have never placed an order?
3. Is RIGHT JOIN ever strictly necessary?
4. Why might a LEFT JOIN return more rows than the left table has?
5. How do you simulate FULL OUTER JOIN on a database that doesn't support it?

## Key Takeaways
- OUTER JOINs keep unmatched rows; INNER JOIN drops them.
- LEFT/RIGHT decide *which* table's unmatched rows survive; FULL keeps both.
- The anti-join pattern (`OUTER JOIN` + `IS NULL`) is the standard way to find "missing" relationships.
- NULL requires `IS NULL`, never `= NULL`.

## Summary
Today's session covered the three OUTER JOIN types using a football squad/roster dataset (FC Lahore Lions and friends), verified against a real SQLite database with a genuinely unmatched player (Free Agent Zaid) and a genuinely empty-rostered team (Islamabad Falcons). The core skill is the anti-join pattern — LEFT or RIGHT JOIN combined with `IS NULL` — which is one of the most commonly asked SQL interview patterns.
