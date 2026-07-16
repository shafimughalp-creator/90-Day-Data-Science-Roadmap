# Pandas Cleaning — Missing Values & Duplicates

## Quick Overview
- Day 21 of the 94-Day Data Science Roadmap, Phase 2 (Data Tools)
- What I learned: how to find, remove, and fill missing values, and how to detect and remove duplicate rows in a Pandas DataFrame
- Tools used: Python, Pandas, NumPy

## Introduction
- Real-world datasets are almost never clean — values go missing, and the same record can accidentally get entered more than once
- Before doing any analysis or building any model, you have to find and handle these problems, or every calculation built on top of the data will be wrong
- Practiced today using a fictional FC Lahore Lions squad dataset (10 players, some missing stats, one duplicate player entry)

## Definitions
- **Missing value (NaN)** — a cell in the dataset where no data was recorded
- **Duplicate row** — a row that is an exact (or near-exact) repeat of another row already in the dataset
- **Imputation** — the general term for filling in a missing value with an estimated one (mean, median, mode, etc.)

## Important Concepts
- `df.isnull()` — checks every cell, returns `True` where the value is missing
- `df.isnull().sum()` — counts missing values per column
- `.max()` / `.idxmax()` — get the highest value / the label of the highest value in a Series
- `df.dropna()` — removes rows containing missing values
  - `subset=[...]` — only checks specific column(s) for missing values
  - `thresh=N` — keeps a row only if it has at least N non-missing values
  - `axis=1` — drops columns instead of rows
- `df.fillna()` — fills missing values instead of deleting the row
  - `.mean()` — average of the column (works for numeric columns)
  - `.median()` — middle value of the column (less affected by outliers than mean)
  - `.mode()[0]` — most common value (used for categorical columns)
  - `.ffill()` — forward-fill, copies the last known value downward
- `df.duplicated()` — marks a row `True` if an earlier row is an exact repeat
- `df.drop_duplicates()` — removes duplicate rows
  - `subset=[...]` — only compares specific column(s) to decide what counts as a duplicate
  - `keep="first"` / `"last"` — which copy of a duplicate to keep

## Step-by-Step Explanation
1. Load the dataset and inspect it — `df.isnull().sum()` to see which columns have gaps, and how many
2. Turn the count into a percentage — `(df.isnull().sum() / len(df)) * 100` — to judge how serious each gap really is
3. Decide row-by-row whether to **drop** or **fill**:
   - If the missing value makes the row unusable, drop it (`dropna` with `subset`)
   - If the row is still useful without it, fill it (`fillna` with mean/median/mode/ffill, depending on the column type)
4. Check for duplicate rows with `df.duplicated().sum()`
5. Remove duplicates with `df.drop_duplicates()`, choosing `subset` and `keep` deliberately instead of relying on defaults

## Examples
- `df.isnull().sum()` on the squad data showed `position` missing 1 value, `age` missing 3, `market_value_k` missing 3
- `df.dropna()` with no arguments dropped 7 of 10 players — way too aggressive, since it deletes a row for even one missing value anywhere
- `df.dropna(subset=["position"])` only dropped 1 row — the player actually missing something critical
- `df["age"].fillna(df["age"].median())` filled all missing ages with 27.0 (the column's median) without deleting any rows
- `df.drop_duplicates(subset=["player"], keep="first")` correctly removed the duplicate player entry while keeping the first-filed report

## Common Mistakes
- Running `df.dropna()` with no arguments and not checking `df.shape` before/after — can silently delete most of the dataset
- Forgetting that `dropna()` and `fillna()` both return a **new** object by default — the original `df` is unchanged unless you reassign it (`df = df.dropna()`)
- Trusting `idxmax()` or `mode()` blindly when there's a tie — they silently return only the first matching value and hide the tie
- Using `mean()` to fill a skewed numeric column (like salary) where a few outliers pull the average — `median()` is usually safer
- Assuming 0 missing values means the data is "clean" — a fully-filled column can still contain duplicate rows

## Interview Questions
- What's the difference between `dropna()` and `fillna()`, and how do you decide which one to use?
- Why does `df.dropna()` sometimes delete far more data than expected?
- What's the difference between filling missing values with mean vs. median, and when would you choose one over the other?
- How does `df.duplicated()` decide whether a row is a duplicate, and how do you control that with `subset`?
- Why can `idxmax()` or `mode()` give a misleading answer, and how would you check for that?

## Key Takeaways
- Missing data and duplicate rows are the norm in real datasets, not the exception
- `dropna()` is powerful but dangerous without `subset` or `thresh` — it can wipe out usable data
- The right fill strategy (mean, median, mode, ffill) depends on the type of column, not a one-size-fits-all rule
- Functions that return a single "top" answer (`idxmax()`, `mode()[0]`) can hide ties — always sanity-check
- Cleaning is not a side step before "real" data science — it's a core, repeatable part of the workflow

## Summary
Today covered the core Pandas toolkit for cleaning messy data: finding missing values with `isnull().sum()`, deciding when to drop rows with `dropna()` (and its `subset`/`thresh` options), filling gaps sensibly with `fillna()` (mean, median, mode, or forward-fill), and catching duplicate rows with `duplicated()` and `drop_duplicates()`. Practiced end-to-end on a small FC Lahore Lions squad dataset with real missing values and a real duplicate entry.
