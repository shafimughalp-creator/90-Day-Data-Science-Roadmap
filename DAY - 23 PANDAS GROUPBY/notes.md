[notes.md](https://github.com/user-attachments/files/30156711/notes.md)# Pandas — GroupBy & Aggregation

## Quick Overview
- **Topic:** Pandas `groupby()` and `.agg()` — grouping rows and computing summary statistics per group.
- **What I learned:** How to split a DataFrame into groups by a column, then apply single, multi, and named aggregations to answer business-style questions.
- **Tools used:** Python, Pandas, NumPy — Jupyter Notebook.

## Introduction
Real datasets are rarely useful row-by-row. Most business and analytics questions are really *group* questions — "average X per category," "total Y per region." Pandas' `groupby()` is the tool that turns raw rows into grouped summaries, and `.agg()` is how you control exactly what stats come out.

## Definitions
- **GroupBy:** splits a DataFrame into groups based on the unique values of one or more columns.
- **Aggregation:** a function (mean, sum, count, max, min, etc.) applied to each group separately.
- **Split → Apply → Combine:** the 3-stage process behind every groupby operation — split rows into groups, apply a function to each group, combine results into one table.
- **Named aggregation:** a way to run `.agg()` while directly naming the output columns, instead of getting default column names.

## Important Concepts
- Single-column groupby + single stat: `df.groupby("col")["target"].mean()`
- Multi-column, multi-function `.agg()` with a dict: `df.groupby("col").agg({"c1": "sum", "c2": "mean"})`
- Multiple stats on one column using a list: `df.groupby("col").agg({"c1": ["sum", "mean"]})`
- Named aggregation: `df.groupby("col").agg(new_name=("source_col", "function"))`
- `"count"` as an aggregation function — counts rows per group, regardless of values

## Step-by-Step Explanation
1. Start with a full DataFrame of raw rows (e.g., players with position, goals, rating).
2. Call `.groupby("position")` — this doesn't compute anything yet, it just prepares groups.
3. Chain a column selection and a function (`["goals"].mean()`) OR chain `.agg()` for more control.
4. With `.agg()`, pass a dict `{"column": "function"}` for multiple stats across multiple columns in one line.
5. For readable, report-ready output, use named aggregation: `.agg(new_col=("source_col", "function"))` so the output columns are self-explanatory.

## Examples
```python
# Single column groupby
avg_goals_by_position = df.groupby("position")["goals"].mean()

# Multi-column, multi-function agg
squad_summary = df.groupby("position").agg({"goals": "sum", "rating": "mean"})

# Named aggregation — report-ready column names
squad_report = df.groupby("position").agg(
    total_goals=("goals", "sum"),
    avg_rating=("rating", "mean"),
    top_scorer_goals=("goals", "max"),
    squad_size=("player", "count")
)
```

## Common Mistakes
- Forgetting to select a column after `groupby()` → averages every numeric column instead of the one you meant.
- Using `=` instead of `:` inside an `.agg()` dict → `SyntaxError`.
- Swapping the tuple order in named aggregation — `("function", "column")` instead of `("column", "function")` → wrong result or `KeyError`.
- Typo in a column name inside `.agg()` → `KeyError`.

## Interview Questions
1. Write one line to find the average `goals` scored, grouped by `position`.
2. Using `.agg()` (dict style), get the `sum` of `goals` and `mean` of `rating`, per `position`, in a single call.
3. Using named aggregation, produce a table with `avg_goals` and `total_players` (count), per `position`.

## Key Takeaways
- `groupby()` alone doesn't compute anything — it needs a column selection or `.agg()` to actually produce a result.
- `.agg()` with a dict lets you apply different functions to different columns in one call.
- Named aggregation (`name=(col, func)`) is the professional standard — it gives self-explanatory output columns with no renaming step needed.
- `"count"` counts rows per group and doesn't depend on the values in any particular column.

## Summary
Today covered the core `groupby()` + `.agg()` workflow in Pandas: single-column grouping, multi-column/multi-function aggregation with dicts, and named aggregation for clean, report-ready summaries. This is the exact pattern used constantly in business analytics, EDA, and — later in Phase 3 — mirrors SQL's `GROUP BY` clause directly.
