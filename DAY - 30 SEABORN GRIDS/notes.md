# Seaborn Advanced Grids

## Quick Overview
- Today's topic: building grids of Seaborn plots — `catplot`, `FacetGrid`, `jointplot`, and mixing Seaborn into a Matplotlib subplot grid.
- What I learned: how to split one chart into several small charts by category, and how to plot two numeric columns against each other.
- Tools used: Python, Pandas, Seaborn, Matplotlib.

## Introduction
Single plots only show one slice of the data. Advanced Seaborn grids let you split a chart into several small panels — one per category — so you can compare groups side by side instead of squinting at one crowded plot.

## Definitions
- **catplot** — a Seaborn function that draws a categorical plot (bar, box, etc.) and can automatically split it into multiple columns/rows using `col=` or `row=`.
- **FacetGrid** — a blank grid object you create first, then "map" any plot type onto every panel with `.map()`.
- **jointplot** — a plot that shows the relationship between two numeric columns, with a main scatter/regression plot and small histograms on the edges.
- **Subplot grid (Matplotlib)** — a manually created grid (`plt.subplots()`) where you place individual Seaborn plots into specific boxes using `ax=`.

## Important Concepts
- `sns.catplot(..., col="result", kind="bar")` — one bar chart per unique value in `result`, automatically laid out in columns.
- `FacetGrid` is two steps: (1) build the empty grid with `col=`, (2) fill it with `.map(plot_function, "column_name")`.
- `jointplot(kind="reg")` adds a trend line on top of the scatter plot to show correlation direction.
- Seaborn plots can be dropped into a specific Matplotlib subplot box using the `ax=` parameter — this is how you combine several different plot types into one dashboard.
- `plt.savefig("name.png", dpi=200, bbox_inches="tight")` must be called **before** `plt.show()`, or the saved file can come out blank.

## Step-by-Step Explanation
1. Load or build the DataFrame (e.g. match results with day, shots on target, result, goals).
2. For a quick grouped comparison → use `sns.catplot()` with `col=` set to the grouping column.
3. For full control over a grid → build a `FacetGrid`, then `.map()` a plot function onto it.
4. For comparing two numeric columns → use `sns.jointplot()`.
5. For a custom multi-plot layout with mixed chart types → use `plt.subplots()` first, then pass `ax=axes[i]` into each `sns.plot()` call.
6. Save the final figure with `plt.savefig()` before showing it.

## Examples
- Bar chart of `goals` by `day`, split into columns by `result` (Win / Loss / Draw), using `catplot`.
- A `FacetGrid` of histograms showing `shots_on_target` distribution, split by `day`.
- A `jointplot` comparing `shots_on_target` vs `goals` to see if more shots roughly mean more goals.
- A 1×2 Matplotlib grid with a boxplot on the left and a histogram on the right, built manually with `ax=`.
- A final "Winger Dashboard" — two panels in one figure, saved as `winger_dashboard.png`.

## Common Mistakes
- Trying to pass `ax=` into `sns.catplot()` or `sns.jointplot()` — these are figure-level functions and don't support `ax=` (only axes-level functions like `sns.boxplot`/`sns.histplot` do).
- Calling `plt.savefig()` after `plt.show()` — this can save a blank image because the figure gets cleared after `show()`.
- Forgetting `.map()` after creating a `FacetGrid` — the grid stays empty without it.
- Mixing up `x=` and `y=` on `jointplot`, which flips which variable is treated as the predictor.

## Interview Questions
- What's the difference between a figure-level plot (like `catplot`, `jointplot`) and an axes-level plot (like `boxplot`, `histplot`) in Seaborn?
- When would you use `FacetGrid` instead of `catplot`?
- Why does `plt.savefig()` need to be called before `plt.show()`?
- How do you combine two different Seaborn plot types into a single custom-layout figure?

## Key Takeaways
- `catplot` is the fast path for a grouped categorical grid.
- `FacetGrid` gives more control when the built-in grid functions don't fit the plot type needed.
- `jointplot` is the go-to for checking the relationship between two numeric columns at a glance.
- `ax=` is the bridge between Seaborn and Matplotlib's own subplot grids.

## Summary
Today covered four ways to build multi-panel Seaborn visuals: the quick `catplot` grid, the flexible `FacetGrid` + `.map()` combo, the two-variable `jointplot`, and manually placing Seaborn charts into a Matplotlib `subplots()` grid to build a custom dashboard — finishing with a saved PNG dashboard combining a histogram and a boxplot.
