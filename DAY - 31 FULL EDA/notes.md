# Full Exploratory Data Analysis (EDA) — Titanic Dataset

## Quick Overview
- **Topic:** Bringing every EDA tool learned so far (Pandas, Matplotlib, Seaborn) together into one full workflow on a real, messy dataset.
- **What I learned:** How to go from a raw CSV to a set of survival-driving insights — inspection → missing values → distributions → grouped comparisons → feature engineering → correlation → multivariate plots.
- **Tools used:** `pandas`, `numpy`, `matplotlib`, `seaborn`

## Introduction
- EDA (Exploratory Data Analysis) is the process of understanding a dataset before doing any modeling.
- Goal for today: take the Titanic dataset (`titanic_messy.csv`) and figure out **what actually drove survival** — using only exploration, no ML yet.
- This day is a capstone: no new syntax, just combining Days 20–30 into one repeatable EDA pipeline.

## Definitions
- **EDA (Exploratory Data Analysis):** systematically looking at a dataset's structure, quality, and patterns before analysis or modeling.
- **Missing value:** a cell in the dataset with no recorded data (`NaN`).
- **Binning:** converting a continuous numeric column into labeled categories (e.g., Age → Child/Teen/Adult/Senior).
- **Correlation matrix:** a table showing how strongly each pair of numeric columns moves together, from -1 to +1.
- **Pairplot:** a grid of scatterplots showing every numeric column plotted against every other one, useful for spotting relationships at a glance.

## Important Concepts
- Always inspect before touching a dataset: `df.info()` and `df.describe()` reveal column types, non-null counts, and basic stats in seconds.
- Missing data should be measured as a **percentage**, not just a raw count — 19 missing values means very different things in a 50-row vs 5,000-row dataset.
- Distribution shape (normal vs skewed) affects which statistics are meaningful — a skewed `Fare` column makes the mean misleading, so I checked the histogram before trusting `describe()`.
- Grouped survival rates (`groupby().mean()` on a 0/1 column) is a fast way to read a rate directly, since the mean of 0s and 1s **is** the survival percentage.
- Binning a continuous variable (`pd.cut`) can reveal patterns a raw scatterplot hides — age *groups* mattered more than exact age.
- A correlation heatmap is a fast sanity check across every numeric pair at once, before deciding what's worth plotting individually.

## Step-by-Step Explanation
- **Step 1 — Load & Inspect:** read the CSV, run `.info()` and `.describe()` to understand shape, types, and obvious stats.
- **Step 2 — Measure Missingness:** `.isnull().sum()` for raw counts, then divide by `len(df)` for percentages, so I know which columns are usable and which need dropping/imputing later.
- **Step 3 — Check Distributions:** `sns.histplot(..., kde=True)` on `Age` and `Fare` to see the shape of each — normal-ish vs skewed.
- **Step 4 — Compare Groups:** `groupby('Sex')['Survived'].mean()` and `groupby('Pclass')['Survived'].mean()` to get direct survival-rate comparisons.
- **Step 5 — Engineer a Feature:** `pd.cut()` to turn `Age` into `Age_bin` (Child/Teen/Adult/Senior), then re-run the groupby to see if age *groups* explain survival better than raw age.
- **Step 6 — Visual Comparison:** a 3-panel `plt.subplots(1, 3)` grid with `sns.barplot` side by side for Sex, Pclass, and Age_bin — one glance shows all three drivers.
- **Step 7 — Correlation Check:** `df.corr(numeric_only=True)` plus `sns.heatmap(..., annot=True)` to see every numeric relationship at once.
- **Step 8 — Multivariate View:** `sns.pairplot(..., hue='Survived')` on Age, Fare, Pclass, and Survived to see how survival splits across combinations of features, not just one at a time.
- **Step 9 — Write Observations:** turn the plots into plain-English conclusions instead of leaving them as just images.

## Examples
- `df.groupby('Sex')['Survived'].mean()` → females ~0.74, males ~0.19 — the single strongest pattern in the whole dataset.
- `df.groupby('Pclass')['Survived'].mean()` → 1st class ~0.63, 3rd class ~0.24 — a clear class-based gap.
- `pd.cut(df['Age'], bins=[0,12,18,60,100], labels=[...])` → turned an exact age like 34 into the label `'Adult'`, making group comparisons readable.

## Common Mistakes
- Trusting `.mean()` / `.describe()` on a skewed column without checking the histogram first — `Fare` looks "normal" in a table but is heavily right-skewed in a plot.
- Reading `.isnull().sum()` as raw counts only and skipping the percentage step — a count of 19 sounds small until it's 20% of the dataset.
- Forgetting `numeric_only=True` in `.corr()` on a mixed-type DataFrame, which throws an error once non-numeric columns are present.
- Cramming too many variables into one pairplot — keeping it to 4 columns (`Age`, `Fare`, `Pclass`, `Survived`) kept the grid readable instead of a wall of tiny plots.

## Interview Questions
- **Q: What's the difference between `df.isnull().sum()` and `df.isnull().sum() / len(df)`?**
  A: The first gives raw missing-value counts per column; the second converts that into a percentage of the whole dataset, which is more useful for deciding whether to drop or impute a column.
- **Q: Why bin a continuous variable like Age instead of using it raw?**
  A: Binning groups similar values together (e.g., all children), which can reveal category-level patterns that get lost in a scatterplot of hundreds of individual ages.
- **Q: What does a correlation heatmap NOT tell you?**
  A: It only captures *linear* relationships between numeric columns — it won't reveal non-linear patterns or relationships involving categorical columns.

## Key Takeaways
- A repeatable EDA order — inspect → missingness → distributions → group comparisons → feature engineering → correlation → multivariate — turns a messy CSV into clear insights.
- Sex and Pclass were the two strongest, most direct survival drivers in this dataset.
- Age mattered more as a *group* (via binning) than as a raw number.

## Summary
- Today combined nine days of Pandas/Matplotlib/Seaborn learning into one full EDA pass on the Titanic dataset.
- Started from a raw CSV and ended with three concrete, evidence-backed observations about what drove survival — class, sex, and age group.
