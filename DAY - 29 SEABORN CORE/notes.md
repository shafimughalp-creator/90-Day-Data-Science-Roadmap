# Day 29 — Seaborn Core: Distributions, Comparisons & Relationships

## Quick Overview
- **Topic:** Seaborn Core Plots — `histplot`, `boxplot`, `heatmap`, `pairplot`
- **What I learned:** How to go from a raw Pandas DataFrame straight into statistical visuals — distributions, category comparisons, correlations, and multi-variable relationships — with far less code than raw Matplotlib.
- **Tools used:** Python, Pandas, Seaborn, Matplotlib

## Introduction
- Seaborn sits on top of Matplotlib — it still uses `plt.show()` to render, but it does the statistical heavy lifting for you.
- Instead of manually binning data or computing correlations by hand, you hand Seaborn a DataFrame and a column name, and it figures out the rest.
- Today's session covered the four plots that cover 90% of exploratory data analysis (EDA): one for distribution, one for comparison, one for correlation, one for relationships.

## Definitions
- **Distribution plot (`histplot`):** shows how values in a single numeric column are spread out — bunched together, spread wide, skewed, etc.
- **KDE (Kernel Density Estimate):** a smooth curve drawn over a histogram that estimates the "true" underlying shape of the data.
- **Boxplot:** shows the spread of a numeric column across different categories, highlighting the median, quartiles, and outliers.
- **Outlier:** a data point that sits far outside the normal range for its group — boxplots surface these as individual dots beyond the "whiskers."
- **Correlation matrix:** a table showing how strongly every numeric column relates to every other numeric column, from -1 (opposite) to +1 (moves together).
- **Heatmap:** a color-coded grid that makes a correlation matrix easy to scan at a glance.
- **Pairplot:** a grid of scatter plots showing every numeric column plotted against every other one, in a single call.

## Important Concepts
- Seaborn functions almost always follow the same pattern: `sns.plot_type(data=df, x="col", y="col")`.
- Filtering happens in Pandas *before* the plot — Seaborn just draws whatever DataFrame it's handed.
- `annot=True` on a heatmap prints the actual correlation numbers inside each colored square.
- `cmap="coolwarm"` colors strong positive correlation red/warm and strong negative correlation blue/cool.
- `hue="column"` on a pairplot color-codes every point by category, turning one plot into a category comparison tool.
- `plt.show()` is still required after every Seaborn call — Seaborn draws the plot, Matplotlib renders it.

## Step-by-Step Explanation
1. **Distribution check:** call `sns.histplot(data=df, x="column", kde=True)` to see the shape of one numeric column, with a smooth curve on top.
2. **Category comparison:** call `sns.boxplot(data=df, x="category_column", y="numeric_column")` to compare a numeric value across groups and spot outliers.
3. **Correlation check:** run `df.corr()` first to build the correlation matrix, then pass that matrix into `sns.heatmap(data=matrix, annot=True, cmap="coolwarm")`.
4. **Relationship overview:** call `sns.pairplot(data=df, hue="category_column")` to see every numeric pair at once, color-coded by category.
5. **Always finish with `plt.show()`** to actually render the plot.

## Examples
- **Histogram + KDE:** plotted sprint speeds for 6 players — the KDE curve showed a fairly normal, bunched distribution with no extreme outliers.
- **Boxplot:** compared player match ratings by position — the Striker group had one rating (4.0) sitting well below the rest, flagged instantly as an outlier.
- **Filtered boxplot:** filtered the DataFrame down to Defenders only *before* plotting, showing that Seaborn just draws whatever subset of data it's given.
- **Heatmap:** built a correlation matrix for house size, bedrooms, and price — the heatmap made it obvious that size and price were strongly positively correlated.
- **Pairplot:** compared height, weight, and wingspan across Basketball vs. Gymnastics athletes — the `hue` parameter split the two sports into visibly separate clusters across every pair of variables.
- **Mini project:** ran all four plot types back-to-back on one coffee shop dataset — distribution, outlier check, correlation, and full pairplot overview — to practice choosing the right plot for the right question.

## Common Mistakes
- Forgetting `plt.show()` after a Seaborn call — the plot silently doesn't render in some environments.
- Passing a raw DataFrame into `heatmap()` instead of a correlation matrix — `heatmap()` expects a matrix, not raw rows.
- Trying to run `.corr()` on a DataFrame that still has text/categorical columns — non-numeric columns need to be dropped first.
- Confusing `hue` (color-codes by category) with `x`/`y` (which columns to plot) — `hue` is always the categorical column.
- Reading too much into a boxplot outlier without checking the sample size — with only 5-7 data points, one "outlier" is a small statistical signal, not proof.

## Interview Questions
- **Q: What's the difference between a histogram and a KDE plot?**
  A: A histogram bins data into discrete bars; a KDE draws a smooth continuous curve estimating the underlying distribution. `histplot(..., kde=True)` shows both together.
- **Q: How does a boxplot help you find outliers?**
  A: It plots the median and quartiles as a box, with "whiskers" extending to the normal range — any point beyond the whiskers is drawn separately as an outlier.
- **Q: What does `annot=True` do in a Seaborn heatmap?**
  A: It prints the actual numeric correlation value inside each cell of the heatmap, instead of relying on color alone.
- **Q: What is the `hue` parameter used for?**
  A: It color-codes the plot by a categorical column, letting you compare groups within the same chart instead of building separate plots per group.
- **Q: Why do you need to filter data with Pandas before plotting with Seaborn, rather than doing it inside the plot function?**
  A: Seaborn plots whatever DataFrame it receives — filtering is a data operation, so it belongs in Pandas; keeping that separation makes the code easier to read and debug.

## Key Takeaways
- Seaborn turns multi-line Matplotlib setups into single function calls for common statistical plots.
- The same four-plot workflow — histplot → boxplot → heatmap → pairplot — covers most first-pass EDA on any new dataset.
- Filtering and aggregation still happen in Pandas; Seaborn's job is purely visualization.
- `hue` is the single most powerful parameter in Seaborn — it turns any plot into a category comparison.

## Summary
Today moved from single-variable exploration (histograms) to category comparison (boxplots), then to correlation (heatmaps), and finally to full multi-variable relationships (pairplots). Together these four plots form a repeatable first pass for exploring any new dataset — spot the shape, spot the outliers, spot the correlations, spot the clusters — before diving into deeper analysis or modeling.
