
# Matplotlib Styling — Stylesheets, Annotations & Export

## Quick Overview
- **Topic:** Making Matplotlib charts presentation-ready with stylesheets, annotations, and saved PNG exports.
- **What I learned:** How to apply a global visual theme with `plt.style.use()`, point out key data with `ax.annotate()`, and export a chart to a real file with `plt.savefig()` — then combined all three into a 2x2 tournament dashboard.
- **Tools used:** Python, Matplotlib, Pandas (boolean filtering feeding into plots), Jupyter Notebook.

## Introduction
Up to this point, charts were functional but plain — default colors, default background, no way to highlight a specific point, and no way to save the result anywhere except a notebook cell. This session covers the layer that turns a "working chart" into a "shareable chart": consistent styling, annotations that point straight at the interesting data point, and exporting to disk at print quality.

## Definitions
- **Stylesheet (`plt.style.use()`):** A built-in Matplotlib theme that changes background, gridlines, font, and color defaults for every plot drawn after it's called.
- **Annotation (`ax.annotate()`):** Text plus an optional arrow that points from a label to a specific `(x, y)` data coordinate.
- **Figure export (`plt.savefig()`):** Writes the current figure to an image file on disk, with control over resolution (`dpi`) and cropping (`bbox_inches`).
- **`dpi` (dots per inch):** Controls image resolution — higher `dpi` means a sharper, larger-file image. 300 is a common "print quality" value.
- **`bbox_inches='tight'`:** Trims extra whitespace around the figure so the saved image isn't padded with empty margin.

## Important Concepts
- **Style is applied once, globally.** Calling `plt.style.use('seaborn-v0_8-darkgrid')` before creating a figure affects every subsequent plot in that script/cell — it isn't per-axis.
- **`xy` vs `xytext` in annotate.** `xy` is the data point being pointed at; `xytext` is where the label text itself sits. They're deliberately offset so the arrow has somewhere to point *from*.
- **Save before show.** `plt.savefig()` should be called before `plt.show()` — some backends clear the figure from memory after displaying it, so saving afterward can produce a blank file.
- **Boolean filtering still works upstream of a plot.** Filtering a DataFrame (e.g. `df[df['sprint_speed_kmh'] > 28]`) before plotting is how you isolate "the interesting subset" for a chart, without needing separate plotting logic.

## Step-by-Step Explanation
1. Import `matplotlib.pyplot` and `pandas`.
2. Call `plt.style.use('style-name')` **before** building the figure, to set the global theme.
3. Build the DataFrame or filter it (boolean masking) to the data you actually want to chart.
4. Create the figure and axes with `plt.subplots()`.
5. Plot the data with `ax.plot()` / `ax.bar()`, adding `color`, `marker`, and `label` where a legend is needed.
6. Add titles and axis labels with `ax.set_title()`, `ax.set_xlabel()`, `ax.set_ylabel()`.
7. If a specific point needs calling out, add `ax.annotate()` with an `xy` target and `xytext` label position.
8. Call `plt.tight_layout()` if using subplots, to prevent titles/labels overlapping.
9. Call `plt.savefig('name.png', dpi=300, bbox_inches='tight')` to export.
10. Call `plt.show()` last, to display in the notebook.

## Examples
- Applied `seaborn-v0_8-darkgrid` and plotted two lines (Left Wing vs Right Wing shots) on one axes with a legend, so both series are readable at a glance.
- Used `ax.annotate("Peak Speed!", xy=(4, 33), xytext=(2.5, 32), arrowprops=...)` to point an arrow at the single highest sprint-speed data point, then exported the chart as `winger_speed_analysis.png` at 300 dpi.
- Filtered a DataFrame to `sprint_speed_kmh > 28` and plotted only that subset next to a separate bar chart of tackles won, combining Pandas filtering with a 1x2 subplot grid.
- Built a 2x2 "Tournament Dashboard" combining a dual-line comparison, a bar chart, a filtered bar chart, and an annotated peak — all under one `seaborn-v0_8-darkgrid` theme, exported as `tournament_dashboard.png`.

## Common Mistakes
- Calling `plt.style.use()` *after* creating the figure — it won't retroactively restyle an existing plot.
- Mixing up `xy` and `xytext` in `annotate()` — this makes the arrow point away from the data instead of at it.
- Forgetting `bbox_inches='tight'` on `savefig()`, which leaves the exported PNG with extra white margin.
- Calling `plt.show()` before `plt.savefig()`, which can save a blank or cleared figure depending on the backend.
- Applying a boolean filter but forgetting it returns a **new** DataFrame — the original `df` is unchanged unless reassigned.

## Interview Questions
1. What does `plt.style.use()` do, and does it apply to one plot or the whole session?
2. What's the difference between the `xy` and `xytext` parameters in `ax.annotate()`?
3. Why should `plt.savefig()` generally be called before `plt.show()`?
4. What do `dpi` and `bbox_inches='tight'` each control when saving a figure?
5. How would you plot only the rows of a DataFrame where a column exceeds a threshold?

## Key Takeaways
- A stylesheet is a one-line, global visual upgrade — apply it early, before building the figure.
- Annotations turn a chart from "here's the data" into "here's the story in the data."
- `savefig()` is what makes a chart shareable outside the notebook — order matters (save, then show).
- Everything from earlier sessions (Pandas filtering, subplots, legends) stacks together into one polished dashboard.

## Summary
Today's session added the finishing layer to chart-building: applying a consistent stylesheet, annotating specific data points with arrows and labels, and exporting figures to disk at print quality. Combined with Pandas boolean filtering and subplot grids from earlier sessions, this came together in a 2x2 "Tournament Dashboard" mini project — a scoring record, possession chart, filtered high-scoring matches, and an annotated peak, all styled and exported in one script.
