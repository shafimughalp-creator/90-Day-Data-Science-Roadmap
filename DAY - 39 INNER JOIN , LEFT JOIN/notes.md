
# SQL — INNER JOIN & LEFT JOIN (Multi-Table Queries)

## Quick Overview
- **Topic:** Combining data that's spread across multiple related tables using JOINs.
- **What I learned:** How to connect `customers`, `orders`, and `products` tables together with `INNER JOIN` and `LEFT JOIN`, and how to spot rows with no match using the LEFT JOIN + `IS NULL` pattern.
- **Tools used:** SQLite, DB Browser for SQLite.

## Introduction
Real data almost never lives in one table. A store's data is split into `customers`, `products`, and `orders` so nothing gets repeated — but that means to answer a real question ("who bought what?") you need to *join* the tables back together. Today was about learning the two most common ways to do that: `INNER JOIN` and `LEFT JOIN`.

## Definitions
- **JOIN:** A way to combine rows from two or more tables based on a related column between them.
- **INNER JOIN:** Returns only the rows that have a match in *both* tables. If a customer has never placed an order, they're left out entirely.
- **LEFT JOIN:** Returns *every* row from the left (first) table, plus any matching data from the right table. If there's no match, the right side just shows `NULL`.
- **ON clause:** The condition that tells SQL how two tables are related — usually a primary key in one table matching a foreign key in another.
- **Anti-join pattern:** A `LEFT JOIN` combined with `WHERE <right_table>.<col> IS NULL`, used to find rows in the left table that have *no* match at all (e.g. "products that were never ordered").

## Important Concepts
- A join doesn't change the tables themselves — it builds a temporary combined result just for that query.
- `INNER JOIN` is "matches only." `LEFT JOIN` is "everything from the left, matched or not."
- Filtering (`WHERE`) and sorting (`ORDER BY`) happen *after* the join has already combined the rows.
- You can chain more than one JOIN to pull in a third (or fourth) table — just add another `JOIN ... ON ...` line.
- Aggregate functions (`SUM`, `COUNT`, etc.) work on joined data exactly like they do on a single table — combine the JOIN with `GROUP BY` to get one summary row per group.

## Step-by-Step Explanation
1. Start with the base table in `FROM` and give it a short alias (e.g. `customers c`).
2. Choose `INNER JOIN` or `LEFT JOIN` depending on whether unmatched rows should be dropped or kept.
3. Add the second table with its own alias.
4. Write the `ON` condition linking the two tables' keys (usually `left.id = right.foreign_id`).
5. Add `WHERE`, `GROUP BY`, or `ORDER BY` as needed — these apply to the already-joined result.
6. To pull in a third table, add another `JOIN ... ON ...` block right after the first.

## Examples
**INNER JOIN — customers who've ordered:**
```sql
SELECT c.name, c.city, o.order_date
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;
```

**LEFT JOIN — every customer, ordered or not:**
```sql
SELECT c.name, o.order_date
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;
```

**Anti-join — products that were never ordered:**
```sql
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN orders o
ON p.product_id = o.product_id
WHERE o.order_id IS NULL;
```

**3-table JOIN + aggregation — total spend per customer:**
```sql
SELECT c.name, SUM(p.price * o.quantity) AS total_spent
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN products p ON o.product_id = p.product_id
GROUP BY c.name
ORDER BY total_spent DESC;
```

## Common Mistakes
- Forgetting the `ON` clause, which produces a cross join (every row matched with every row) instead of a proper join.
- Using `INNER JOIN` when the goal is to keep unmatched rows too — the missing rows silently disappear instead of erroring.
- Filtering with `WHERE right_table.col = something` when the table is LEFT-joined — this accidentally turns the LEFT JOIN back into an INNER JOIN (a NULL never equals a value). Filtering for missing rows always needs `IS NULL`, not `= NULL`.
- Losing track of which table is "left" when chaining multiple joins.

## Interview Questions
- What's the difference between an `INNER JOIN` and a `LEFT JOIN`?
- How would you find rows in Table A that have no matching row in Table B?
- Why doesn't `WHERE b.column = NULL` work to find unmatched rows?
- If you chain two `INNER JOIN`s, what happens to a row that matches the first table but not the second?
- What determines which table is the "left" table in a `LEFT JOIN`?

## Key Takeaways
- `INNER JOIN` = matches only, from both sides.
- `LEFT JOIN` = everything from the left table, matches optional.
- `IS NULL` after a `LEFT JOIN` is the standard way to find "what's missing."
- Joins can be chained across as many tables as the question needs.
- `WHERE`, `GROUP BY`, and `ORDER BY` all run on the joined result, not the original tables.

## Summary
Today covered how to bring related tables back together with `INNER JOIN` and `LEFT JOIN`, when to use each one, and how to use a `LEFT JOIN` with `IS NULL` to surface rows with no match — a pattern that shows up constantly in real analysis (customers with no orders, products never sold, etc.). Also practiced chaining joins across three tables and combining a join with `SUM`/`GROUP BY` to build a real summary report.
