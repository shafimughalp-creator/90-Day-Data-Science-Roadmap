
[day_35_notes.md](https://github.com/user-attachments/files/30778594/day_35_notes.md)# Day 35 — Phase 2 Review + Pandas Advanced Practice

## Quick Overview
- Consolidation day before starting SQL (Phase 3) — no new theory, pure review and application.
- What I learned: re-solidified `rolling()`, `rank()`, and `pivot_table()`, then combined a 3-table merge + groupby + plot pipeline, and implemented Pearson correlation from scratch with only `np.mean()` and `np.std()`.
- Tools used: Python, NumPy, Pandas, Matplotlib.

## Introduction
- This session sat between the end of Phase 2 (Data Tools) and the start of Phase 3 (SQL).
- Goal: make sure Pandas and NumPy fluency is solid before adding SQL to the toolkit — these stay daily-use tools going forward.

## Definitions
- **Rolling window**: a moving subset of consecutive rows (e.g. last 3 matches) that a function (like `.mean()`) is applied to at each step.
- **Rank**: assigns a standing/order number to values in a column, based on their relative size.
- **Pivot table**: reshapes data so one categorical column becomes new column headers, turning "long" grouped data into a readable grid.
- **Pearson correlation (r)**: a number between -1 and +1 measuring how strongly two variables move together in a straight-line relationship.

## Important Concepts
- `.rolling(window=n).mean()` returns `NaN` for the first `n-1` rows — there isn't a full window yet.
- `.rank(method='dense', ascending=False)` — `dense` avoids rank gaps after ties, `ascending=False` makes the highest value rank 1st.
- `pivot_table(values=, index=, columns=, aggfunc=)` vs `groupby()` — both aggregate the same way, but pivot_table lays a grouping column out sideways as columns instead of stacking it in rows.
- `.loc[]` is label-based (matches by name), `.iloc[]` is position-based (matches by integer index) — same output isn't always same reasoning.
- Chained merges: `pd.merge()` can be called multiple times in sequence to pull columns from more than 2 related tables into one working DataFrame.
- Named aggregation: `.agg(new_col='func')` lets you rename the output column directly during aggregation.
- Pearson's r built manually: mean and std of both variables, sum of paired deviations (numerator), divided by `n * std_x * std_y`.

## Step-by-Step Explanation
1. Rebuilt `rolling()` and `rank()` on a fresh single-player match log to confirm the logic still holds.
2. Built a `pivot_table` on a 2-player dataset, and compared its grid output to the equivalent `groupby` output to see the reshaping difference directly.
3. Merged 3 related tables (matches → players → teams) using two chained `pd.merge()` calls, then grouped by `city` using named aggregation (`sum` and `mean` in one `.agg()` call).
4. Plotted the grouped totals with `Series.plot(kind='bar', ax=ax)`, keeping the `fig, ax = plt.subplots()` pattern from Days 27-28.
5. Rebuilt Pearson's correlation coefficient step by step from its formula, using only `np.mean()` and `np.std()`, then verified the result against `np.corrcoef()`.

## Examples
- Rolling form: `matches['rating'].rolling(window=3).mean()` — smooths a player's last-3-match rating into a "current form" number.
- Pivot grid: goals by player × competition, reshaped so `League` and `Cup` become column headers instead of stacked rows.
- 3-table merge: match → player → team, to answer "which city's team scores the most on average?"
- Manual Pearson: shots vs goals across 6 matches came out to `r ≈ 0.96` — a very strong positive correlation.

## Common Mistakes
- Forgetting `ascending=False` in `.rank()` — defaults to ranking smallest value as #1, which is backwards for a "leaderboard."
- Forgetting `aggfunc` in `pivot_table` — silently defaults to `mean` even when `sum` was intended.
- Confusing `.loc` (label-based) with `.iloc` (position-based) — they can coincidentally return the same value while working on completely different logic.
- Rounding intermediate values by hand when computing correlation manually — small rounding errors compound across multiple terms and shift the final `r`.

## Interview Questions
- What's the difference between `pivot_table()` and `groupby()` if they can produce the same numbers?
- Why does `.rolling(window=n)` return `NaN` for the first `n-1` rows, and how would you handle that in a real feature-engineering pipeline?
- Walk through how you'd compute Pearson correlation without using a built-in function.
- When would average (mean) be a misleading way to compare two groups, even if it's mathematically correct?

## Key Takeaways
- Pivot tables and groupby solve the same underlying question but with different output shapes — layout matters for readability, not just correctness.
- Small-sample groups can have deceptively strong averages (Karachi's 2 matches vs Lahore's 3) — always check `n` alongside any average.
- Rebuilding a formula (Pearson's r) from scratch, not just calling a library function, is what actually cements understanding of what a metric means.

## Summary
Reviewed the shakiest Phase 2 topic (pivot tables), then applied a full pipeline — merge 3 tables, group and aggregate, and visualize — before implementing Pearson correlation manually with NumPy. Phase 2 fundamentals feel solid heading into SQL (Phase 3) starting Day 36.
