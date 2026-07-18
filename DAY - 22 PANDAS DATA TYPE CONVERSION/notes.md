# Pandas Data Types & Type Conversion

## Quick Overview
- **Topic:** Checking and fixing column data types in Pandas
- **What I learned:** How to detect wrong dtypes with `.dtypes`, then fix them safely using `pd.to_numeric()`, `pd.to_datetime()`, and `.astype()` — without crashing on messy real-world data
- **Tools used:** Python, Pandas

## Introduction
Real-world datasets are rarely clean. A column that looks like numbers or dates might actually be stored as plain text (`object`), which silently breaks math operations, aggregations, and machine learning models later on. This session covers how to detect that problem and fix it properly.

## Definitions
- **dtype** — the data type Pandas uses internally to store a column (e.g. `int64`, `float64`, `object`, `datetime64[ns]`, `category`)
- **object dtype** — Pandas' generic type for text (or mixed) data
- **NaN** — "Not a Number," Pandas' marker for a missing numeric value
- **NaT** — "Not a Time," the datetime equivalent of NaN
- **category dtype** — a storage format that saves memory by storing each unique value once and using lightweight pointers for repeats

## Important Concepts
- `df.dtypes` — attribute (no parentheses) that lists the dtype of every column in a DataFrame
- `series.dtype` — singular version, used on a single Series only
- `pd.to_numeric(series, errors='coerce')` — converts text to numbers; bad values become `NaN` instead of crashing the program
- `pd.to_datetime(series, errors='coerce')` — converts text to real dates; bad values become `NaT`
- `.astype(dtype)` — direct, no-frills conversion for data you already trust is clean
- `.astype('category')` — converts a column to category dtype; only saves memory when there are many repeated values across a large dataset
- `.memory_usage(deep=True)` — measures the actual memory (in bytes) a Series or DataFrame is using, including full text content

## Step-by-Step Explanation
1. Load or build the DataFrame
2. Run `df.dtypes` to check every column's current type
3. Identify columns that are the *wrong* type (e.g. numbers stored as text)
4. Fix numeric columns with `pd.to_numeric(df["col"], errors='coerce')`
5. Fix date columns with `pd.to_datetime(df["col"], errors='coerce')`
6. **Reassign the result back into the column** (`df["col"] = ...`) — this step is easy to forget and the fix silently does nothing without it
7. Optionally convert low-uniqueness text columns to `category` with `.astype('category')` to save memory on large datasets
8. Re-run `df.dtypes` to confirm the fix worked

## Examples
```python
import pandas as pd

data = {
    "player": ["Bilal", "Zeeshan", "Hamza"],
    "goals": ["5", "3", "7"],              # numbers stored as text
    "match_date": ["2024-01-10", "2024-01-17", "2024-01-24"]  # dates stored as text
}
df = pd.DataFrame(data)
print(df.dtypes)   # all show as 'object'

df["goals"] = pd.to_numeric(df["goals"], errors="coerce")
df["match_date"] = pd.to_datetime(df["match_date"], errors="coerce")
print(df.dtypes)   # goals -> int64/float64, match_date -> datetime64[ns]
```

```python
# category dtype only helps at scale
big_positions = pd.Series(["Forward", "Defender", "Midfielder"] * 1000)
print(big_positions.memory_usage(deep=True))                      # bigger
print(big_positions.astype("category").memory_usage(deep=True))   # smaller
```

## Common Mistakes
- Forgetting to reassign the converted column back (`df["col"] = pd.to_numeric(...)`) — without this, the DataFrame is never actually updated
- Leaving `errors='raise'` (the default) on messy data — one bad value crashes the entire pipeline
- Assuming a column "looks like numbers" means it's stored as numbers — `"5"` with quotes is still text
- Applying `.astype('category')` to an entire DataFrame instead of a single column — this can increase memory instead of saving it, especially on unique-value columns like names, prices, or dates
- Using `category` on columns with mostly unique values (IDs, names) — little to no memory benefit
- Confusing `.dtypes` (all columns, DataFrame) with `.dtype` (single column, Series)

## Interview Questions
1. **Q:** A "price" column loads as `object` even though it's clearly numbers. How do you convert it safely?
   **A:** `df["price"] = pd.to_numeric(df["price"], errors="coerce")` — bad values become `NaN` instead of crashing.

2. **Q:** A "status" column has 100,000 rows but only 4 unique values. How do you optimize its memory?
   **A:** `df["status"] = df["status"].astype("category")` — it works because Pandas stores each unique value once and uses lightweight pointers for the repeats, instead of storing the full text every row.

3. **Q:** A "signup_date" column is text with some corrupted values. How do you convert it safely, and what do bad rows become?
   **A:** `df["signup_date"] = pd.to_datetime(df["signup_date"], errors="coerce")` — corrupted rows become `NaT`.

## Key Takeaways
- Always check `.dtypes` before and after any conversion — trust but verify
- `errors='coerce'` is the safe default for real-world, messy data
- `category` dtype is a scale tool — it only pays off on large datasets with heavy repetition, and should be applied column-by-column, never to a whole DataFrame at once

## Summary
Wrong data types are one of the most common silent bugs in real datasets. `df.dtypes` is the first diagnostic step on any new data. `pd.to_numeric()` and `pd.to_datetime()` safely convert messy text into usable numbers and dates using `errors='coerce'`, while `.astype()` handles direct conversions and the memory-saving `category` dtype — which only makes sense at real scale, applied to the right column.
