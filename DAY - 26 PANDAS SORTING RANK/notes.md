# Pandas — Sorting, Ranking, Rolling & Pivot Tables

## Quick Overview
- **Topic:** Reordering and reshaping data in Pandas — `sort_values`, `rank`, `rolling`, and `pivot_table`.
- **What I learned:** How to find top performers, assign position numbers with tie handling, smooth noisy data with moving windows, and reshape long data into summary grids.
- **Tools used:** Python, Pandas.

## Introduction
Ranking, rolling windows, and pivot tables all answer the same underlying question — "how do I reshape or reorder data to see a pattern?" They're used constantly for feature engineering and for answering business questions fast, without writing a new custom script every time.

## Definitions
- **`sort_values()`:** Reorders rows in a DataFrame based on one column's values.
- **`rank()`:** Assigns a position number to each row based on where it falls within a column, with configurable tie-handling.
- **`rolling(window)`:** Creates a sliding window of N rows and lets you compute a rolling statistic (mean, sum, max) over just that window.
- **`pivot_table()`:** Reshapes long-format data into a wide grid — one column becomes new rows, another becomes new columns, a third gets aggregated into each cell.

## Important Concepts
- `sort_values(by, ascending)` — `ascending=False` puts the largest value first.
- `rank(method, ascending)` — `method='dense'` gives tied values the same rank with no gaps in the next rank; `method='min'` gives tied values the same rank but skips the ranks "used up" by the tie.
- `rolling(window, min_periods)` — the first `window - 1` rows are `NaN` unless `min_periods` is set lower; rolling only understands row order, so data must be sorted first (usually by date).
- `pivot_table(values, index, columns, aggfunc)` — `aggfunc` decides how multiple matching rows combine into one cell; forgetting it silently defaults to `'mean'`.
- `pivot_table` is essentially `groupby().agg().unstack()` packaged into one call.

## Step-by-Step Explanation
1. Sort a DataFrame by a column: `df.sort_values('col', ascending=False)`.
2. Rank a column, handling ties explicitly: `df['col'].rank(method='dense', ascending=False)`.
3. Compute a moving statistic: `df['col'].rolling(window=7).mean()`.
4. Reshape long data into a summary grid: `pd.pivot_table(df, values=..., index=..., columns=..., aggfunc=...)`.
5. Combine groupby + rank for an overall ranking that a pivot table alone can't give: `df.groupby('col')['value'].mean().rank(ascending=False)`.

## Examples
```python
# Top 10 orders by sales
top_orders = df.sort_values('sales', ascending=False).head(10)

# Dense rank, ties share a rank with no gap
df['sales_rank'] = df['sales'].rank(method='dense', ascending=False)

# 7-day rolling average, smooths daily noise
df['rolling_mean'] = df['sales'].rolling(window=7).mean()

# Region x Category revenue grid
grid = pd.pivot_table(df, values='sales', index='region', columns='category', aggfunc='sum')

# Overall rank per country by average CLV
avg_clv = df.groupby('country')['clv'].mean()
country_rank = avg_clv.rank(ascending=False)
```

## Common Mistakes
- Passing a column name without quotes (`df.sort_values(sales)`) — throws a `NameError`.
- Forgetting `.mean()`/`.sum()` after `.rolling(window=7)` — leaves an unevaluated `Rolling` object instead of numbers.
- Selecting columns *before* sorting by a column not in that selection — throws a `KeyError` (the sort column has to still be present).
- Forgetting `aggfunc` in `pivot_table` — silently defaults to `'mean'` instead of the intended `'sum'`.
- Typo `column=` instead of `columns=` in `pivot_table` — throws a `TypeError`.

## Interview Questions
1. What's the difference between `rank(method='dense')` and `rank(method='min')` when there's a tie?
2. Why do the first few rows of a `rolling(window=7)` column come back as `NaN`?
3. How is `pivot_table()` related to `groupby()` — could you build the same result with `groupby`?

## Key Takeaways
- `sort_values` reorders rows; `rank` labels rows with a position number — they solve different problems and are often used together.
- Rolling windows require sorted, sequential data to mean anything.
- `pivot_table` is the fastest way to answer "totals broken down by two categories at once."
- Combining `groupby` + `rank` gives an overall ranking that a two-dimensional pivot table can't give directly.

## Summary
Today covered four Pandas tools for reordering and reshaping data: `sort_values` for finding top/bottom performers, `rank` for assigning tie-aware position numbers, `rolling` for smoothing noisy time-based data, and `pivot_table` for turning long data into readable summary grids — closing with the practice scenario of ranking countries by average customer lifetime value.
