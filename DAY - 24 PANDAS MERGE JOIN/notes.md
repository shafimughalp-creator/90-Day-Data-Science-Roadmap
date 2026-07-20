# Pandas — Merge, Join & Concat

## Quick Overview
Day 24 of my 90-Day Data Science journey. Learned how to combine multiple pandas DataFrames into one — using `pd.merge()` (join on a shared key column) and `pd.concat()` (stack tables together). Tools used: Python, Pandas.

## Introduction
Real data almost never lives in a single table — a business has a customers table, an orders table, a products table, all connected by shared ID columns. Merging is how you turn those separate tables into one usable dataset for analysis. This is also one of the most common interview topics in data roles, because misunderstanding join types is an easy way to silently produce wrong numbers.

## Definitions
- **Merge / Join** — combining two DataFrames *sideways* (adding columns) by matching values in a shared key column.
- **Concat** — combining DataFrames by *stacking* them, either as new rows (`axis=0`) or new columns (`axis=1`), with no key matching involved.
- **Key column** — the shared column (e.g. `customer_id`) used to match rows between two tables.
- **`how` parameter** — controls which rows survive a merge when a match is missing on one side.

## Important Concepts
- `pd.merge(left, right, on='key', how='inner')` — keep only rows where the key exists in **both** tables.
- `how='left'` — keep **all** rows from the left table, fill `NaN` where there's no match on the right.
- `how='right'` — mirror of `left`, keeps all rows from the right table.
- `how='outer'` — keep all rows from **both** tables, `NaN` fills any gaps.
- `pd.concat([df1, df2], axis=0)` — stack rows on top of each other.
- `pd.concat([df1, df2], axis=1)` — glue columns side-by-side, matched purely by row position (risky if rows aren't already aligned).
- `.reset_index(drop=True)` — cleans up a duplicated/messy index (common after `concat`) by renumbering from 0, discarding the old index instead of keeping it as a column.
- Chaining merges — merging a third table onto the result of a first merge to build a multi-table report (e.g. customers → orders → products).

## Step-by-Step Explanation
1. Identify the "anchor" table — the one whose rows you refuse to lose (e.g. all registered customers).
2. Pick the right `how`:
   - Need only matched data on both sides → `inner`
   - Need to keep everything from your anchor table → `left` (or `right` if the anchor is the second argument)
   - Need everything from both, matched or not → `outer`
3. Call `pd.merge(left, right, on='key_column', how='...')`.
4. If a third table needs joining, merge it onto the *result* of the first merge, using its own shared key.
5. To stack similar tables instead of joining on a key, use `pd.concat([...], axis=0)`, then `.reset_index(drop=True)` if the index needs to be clean.

## Examples
**Inner merge — only matches survive:**
```python
customers = pd.DataFrame({"id": [1, 2, 3], "name": ["Ali", "Sara", "Bilal"]})
orders = pd.DataFrame({"id": [1, 1, 2], "amount": [2500, 900, 1800]})
report = pd.merge(customers, orders, on="id", how="inner")
print(report)
```
```
   id  name  amount
0   1   Ali    2500
1   1   Ali     900
2   2  Sara    1800
```

**Left merge — keep every customer, even with no orders:**
```python
left_report = pd.merge(customers, orders, on="id", how="left")
no_orders = left_report[left_report["amount"].isnull()]
print(no_orders)
```

**Chaining a 3-table join:**
```python
step1 = pd.merge(customers, orders, on="customer_id", how="inner")
final_report = pd.merge(step1, products, on="product_id", how="inner")
```

## Common Mistakes
- Forgetting `on='...'` — pandas auto-merges on all shared column names, which can silently match the wrong thing.
- Typing the key column name wrong → `KeyError`, or a merge that returns 0 rows if paired with the wrong `how`.
- Assuming `inner` keeps everything — it's actually the strictest option; it drops anything unmatched on either side.
- Using `pd.concat()` when a `pd.merge()` was actually needed — `concat(axis=1)` glues by row position with **no key matching**, so misaligned rows silently combine wrong data.
- Forgetting that `concat` keeps the original index — leads to duplicated index values unless you call `.reset_index(drop=True)`.
- Not noticing merged numeric columns silently change from `int64` to `float64` once `NaN` values are introduced.

## Interview Questions
1. You have a `customers` table and an `orders` table. You want a report showing every customer, even ones with zero orders. Which merge do you use, and why not `inner`?
2. What's the practical difference between `pd.merge()` and `pd.concat()`, and when would using `concat` instead of `merge` actually corrupt your data?
3. After an `outer` merge, several numeric columns show `NaN` and the dtype changed from `int64` to `float64`. Why does that happen?

## Key Takeaways
- Merging is how multiple real-world tables become one usable dataset — this is the core of most business reporting.
- The `how` parameter is the single most important decision in any merge; get it wrong and rows disappear silently, with no error.
- `concat` stacks blindly with no key matching — safe for `axis=0` on identically-shaped tables, risky for `axis=1`.
- Chaining merges (table → table → table) is exactly how multi-source reports get built in real jobs.

## Summary
Today covered `pd.merge()` (`inner`, `left`, `right`, `outer`) for combining tables on a shared key, `pd.concat()` for stacking tables, and `.reset_index(drop=True)` for cleaning up the resulting index. Practiced by chaining a customers → orders → products join into a single report — the exact pattern used to build real analytics dashboards.
