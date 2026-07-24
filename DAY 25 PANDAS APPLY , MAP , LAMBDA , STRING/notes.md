# Pandas: apply(), map(), and Lambda Functions

## Quick Overview
- Today's topic: transforming and cleaning DataFrame columns using `.map()`, `.apply()`, lambda functions, and `.str` string methods.
- What I learned: `.map()` does dictionary lookups, `.apply()` runs custom logic (column-wise or row-wise), and `.str` methods clean messy text data.
- Tools used: Python, Pandas, Jupyter Notebook.

## Introduction
- Real data is messy — inconsistent casing, stray spaces, values that need re-labeling or re-categorizing.
- Pandas gives three main tools to transform columns without writing manual loops: `.map()`, `.apply()`, and `.str` accessor methods.
- Practiced all three using a small coffee shop orders dataset (order_id, customer_name, price, product).

## Definitions
- **`.map()`** — replaces each value in a Series using a dictionary (or a function). Best for simple lookups/relabeling.
- **`.apply()`** — runs a function on every value in a Series (column-wise), or on every row when `axis=1` is passed.
- **Lambda function** — a short, unnamed, throwaway function written inline, e.g. `lambda x: x * 2`.
- **`.str` accessor** — a set of vectorized string methods (`.lower()`, `.strip()`, `.contains()`, `.split()`) that work on an entire text column at once.
- **`axis=1`** — tells `.apply()` to pass one whole row (as a mini Series) into the function, instead of one column value at a time.

## Important Concepts
- `.map()` only works well for simple value-to-value substitution — anything not in the dictionary becomes `NaN`.
- `.apply()` with a lambda is for column-wise logic that's too specific for `.map()` (e.g. conditional pricing rules).
- `.apply(func, axis=1)` is for logic that needs more than one column at once (e.g. comparing `price` and `product` together).
- `.str` methods can be chained: `.str.strip().str.lower().str.contains('khan')` runs left to right, each step feeding into the next.
- Inside a function used with `.apply(axis=1)`, each column value arrives as a plain scalar (a single string/number) — not a Series — so `.str` methods don't work directly on it there.

## Step-by-Step Explanation
1. Build a lookup dictionary — e.g. `{101: "paid", 102: "paid"}`.
2. Use `.map(dictionary)` on a column to substitute matching values; unmatched values return `NaN`.
3. For conditional logic on one column, use `.apply(lambda x: ... if ... else ...)`.
4. For logic that needs the whole row, write a named function that takes `row` and returns a value, then call `.apply(function, axis=1)`.
5. For text cleanup, chain `.str` methods: strip spaces, lowercase, then check or split.
6. Combine cleaned columns with `.groupby()` to summarize (e.g. average price per tier).

## Examples
- **Map:** `orders_df['order_id'].map(status_map)` — looks up each order ID in a status dictionary.
- **Apply + lambda (column-wise):** `orders_df['price'].apply(lambda x: x * 2 if x > 1000 else x)` — doubles high prices only.
- **Apply row-wise:** a `price_tier(row)` function checks `row['price']` and returns `"Premium"`, `"Standard"`, or `"Budget"`, applied with `axis=1`.
- **String cleaning:** `orders_df['customer_name'].str.strip().str.lower().str.split('-', expand=True)` — trims, lowercases, then splits names into separate columns.
- **Groupby summary:** `orders_df.groupby('price_category')['price'].mean()` — average price per price tier.

## Common Mistakes
- 🐛 Using `.map()` with a dictionary that's missing some keys — unmapped values silently become `NaN` instead of raising an error.
- 🐛 Forgetting a final `else` branch in a row-wise tier function, so values that don't match any condition get miscategorized.
- 🐛 Calling `.str.contains()` on a column with mixed casing (`'NIDA-KHAN'` vs `'ali khan'`) without lowercasing first — matches get silently missed.
- 🐛 Trying to call `.str.contains()` *inside* a function passed to `.apply(axis=1)` on `row['product']` — inside the row function, `row['product']` is a plain string, not a Series, so the `.str` accessor doesn't exist there. Use plain Python `in` instead (e.g. `'Bundle' in row['product']`).
- 🐛 Reusing a variable/dictionary name from an earlier cell (e.g. an outdated `status_map`) and getting confusing `NaN` results with no obvious cause.

## Interview Questions
- What's the difference between `.map()` and `.apply()` in Pandas?
- When would you pass `axis=1` to `.apply()`, and what does the function receive in that case?
- Why can't you use `.str.contains()` directly on `row['column']` inside a function used with `.apply(axis=1)`?
- What happens when `.map()` encounters a key that isn't in the dictionary?
- How do you chain multiple `.str` methods together, and why does order matter?

## Key Takeaways
- `.map()` → dictionary lookups, simplest option, values not found become `NaN`.
- `.apply()` on a column + lambda → quick conditional logic on single values.
- `.apply(func, axis=1)` → logic that needs multiple columns from the same row.
- `.str` methods clean and inspect text columns, and they chain left to right.
- Case and whitespace inconsistencies are the #1 source of silent bugs when matching or filtering text.

## Summary
Day 25 covered three ways to transform a Pandas column: `.map()` for lookups, `.apply()` for custom logic (column-wise or row-wise), and `.str` methods for cleaning messy text. Practiced all of it on a coffee shop orders dataset — cleaning customer names, tagging price tiers, flagging discounts, and summarizing with `.groupby()`.
