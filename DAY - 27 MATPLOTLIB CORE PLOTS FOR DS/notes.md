# Matplotlib — Core Plots for Data Science

## Quick Overview
- **Topic:** Matplotlib's Object-Oriented plotting interface — line, bar, and scatter charts.
- **What I learned:** How to build clear, labeled charts using `fig, ax = plt.subplots()`, and how to pick the right chart type for the data (line for trends, bar for categories, scatter for relationships).
- **Tech/tools used:** Python, Matplotlib (`pyplot`), Pandas (for `groupby`, `.rolling()`, boolean indexing feeding into the plots).

## Introduction
Matplotlib is Python's core plotting library. Today's focus was the **Object-Oriented (OO) interface** — creating a `fig` (canvas) and `ax` (the actual plot area) explicitly, instead of relying on Matplotlib's shortcut functions. The OO style is more verbose but gives full control, which matters once you're building more than one chart or reusing the same figure logic across projects.

## Definitions
- **Figure (`fig`):** the overall canvas/window that holds one or more plots.
- **Axes (`ax`):** the actual plotting area — where lines, bars, and points get drawn. One figure can hold multiple axes.
- **Line plot:** shows how a value changes over a continuous sequence (e.g., a match number or a day).
- **Bar plot:** compares values across separate categories (e.g., players, positions, clubs).
- **Scatter plot:** shows the relationship between two numeric variables (e.g., shots vs. goals).

## Important Concepts
- Always start with `fig, ax = plt.subplots(figsize=(w, h))` — this is the standard OO setup pattern.
- Matching chart type to data type matters: line plots for something changing over time/sequence, bar plots for categories, scatter for two numeric variables side by side.
- `label=` on every `ax.plot()` / `ax.bar()` / `ax.scatter()` call is what makes `ax.legend()` actually show anything — skipping it means an empty or missing legend.
- `ax.set_title()`, `ax.set_xlabel()`, `ax.set_ylabel()` — every chart needs all three to be readable on its own, without extra explanation.
- Multiple series can be plotted on the same `ax` object (e.g., two players' stats, or a raw value plus its rolling average) just by calling `ax.plot()` more than once before `plt.show()`.
- Grouped/aggregated data (via Pandas `.groupby().sum()` or `.mean()`) plots directly — the resulting Series' `.index` and `.values` become the x and y inputs.

## Step-by-Step Explanation
1. Prepare the data (a list, dict, or a Pandas DataFrame/Series).
2. Create the canvas: `fig, ax = plt.subplots(figsize=(8, 4))`.
3. Choose the right method for the chart type: `ax.plot()` for lines, `ax.bar()` for categories, `ax.scatter()` for point relationships.
4. Pass the data, plus styling (`color`, `linestyle`, `marker`, `width`, `alpha`, `edgecolor`) and a `label`.
5. Add `ax.set_title()`, `ax.set_xlabel()`, `ax.set_ylabel()`.
6. Call `ax.legend()` if more than one series is plotted (or a label was set).
7. Call `plt.show()` to render.

## Examples
- A line chart tracking a player's sprint distance across matches, with a 3-day rolling average line layered on top for trend-spotting.
- A bar chart comparing seasonal goals across four strikers, colored green with a black edge.
- A scatter chart comparing shots on target vs. goals scored across six players, with dot size and transparency (`alpha`) tuned for readability.
- Two-group scatter: splitting players into "Starters" vs. "Subs" by boolean indexing first, then plotting each group on the same axes with different colors/markers.

## Common Mistakes
- Using `ax.plot()` (line) for data that's actually categorical — it either draws a misleading line or breaks entirely. The fix is switching to `ax.bar()`.
- Forgetting `label=` on a series, then calling `ax.legend()` and getting an empty or missing legend box.
- Passing `width=` to `ax.scatter()` (a bar-only parameter) — a sign the wrong chart-type method was picked for the data.
- Skipping axis labels/titles, which makes a chart meaningless once it's out of the notebook context (e.g., shared as an image).

## Interview Questions
- What's the difference between Matplotlib's OO interface (`fig, ax`) and the simpler `plt.plot()` shortcut style, and why prefer OO?
- When would you choose a bar chart over a line chart for the same underlying numbers?
- How does `label=` interact with `ax.legend()` — what happens if you forget it?
- How would you plot two groups (e.g., starters vs. subs) on the same axes after filtering a DataFrame with boolean indexing?

## Key Takeaways
- The OO pattern (`fig, ax = plt.subplots()`) is the reusable foundation for every chart type.
- Chart type should match data type: line = trend, bar = category, scatter = relationship.
- Labels and legends aren't optional polish — they're what make a chart interpretable without extra explanation.
- Debugging a chart is often just "wrong method for this data" — recognizing that quickly comes with practice.

## Summary
Today covered Matplotlib's core plot types — line, bar, and scatter — through the Object-Oriented `fig, ax` pattern, using football-themed data (player distances, goals, sprint speeds) as the practice dataset. The main skill built was matching the right chart type to the shape of the data, labeling it properly, and debugging cases where the wrong chart type was picked.
