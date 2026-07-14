Pandas — Series & DataFrame Fundamentals

Quick Overview


Day: 20 of the 94-Day Data Science Roadmap — Phase 2 (Data Tools)
What I learned: how to create, inspect, and select data from Pandas Series and DataFrames — the foundation of the entire Pandas workflow
Tools used: Python, Pandas, NumPy


Introduction


Every dataset a data scientist works with — CSV files, database exports, model outputs — ends up living inside a Pandas DataFrame
NumPy (Days 16–19) gave raw numbers with no labels; Pandas adds labels on top of that same NumPy foundation
Mastering Series and DataFrames is the first real step toward working with real-world datasets


Definitions


Series — a 1D labeled array. One column of values, where each value has a label (index) attached to it
DataFrame — a 2D labeled table. Multiple Series stacked together side by side, all sharing the same index
Index — the row labels of a Series or DataFrame (defaults to 0, 1, 2... if not set manually)
dtype (object) — Pandas' way of labeling text/string columns
dtype (int64) — Pandas' way of labeling whole-number columns


Important Concepts


A DataFrame is essentially several Series glued together, all sharing one index
Pulling a single column out of a DataFrame (df['col']) always returns a Series
.iloc and .loc are not interchangeable:

.iloc = position-based (uses row number, works like Python list slicing, stop is exclusive)
.loc = label/condition-based (uses row label or a boolean condition, can behave differently after filtering)



Filtering a DataFrame with .loc[condition] keeps the original row labels — it does not renumber rows to 0,1,2...
This means after filtering, .iloc[2] and .loc[2] can return completely different rows, or .loc[2] can error out entirely if that label no longer exists


Step-by-Step Explanation

1. Creating a Series

pythonimport pandas as pd

goals = pd.Series(
    [12, 9, 15, 4],              # the data
    index=["Ali", "Bilal", "Hamza", "Zain"]   # the labels
)


pd.Series(data, index) → data = values, index = label for each value


2. Creating a DataFrame — from a dictionary

pythonsquad = pd.DataFrame({
    "player": ["Ali", "Bilal", "Hamza", "Zain"],
    "goals":  [12, 9, 15, 4],
    "assists": [5, 8, 3, 10]
})


Each dictionary key becomes a column name; each list becomes that column's values
All lists must be the same length, or Pandas raises an error


3. Creating a DataFrame — from a NumPy array

pythonsquad_from_array = pd.DataFrame(
    stats_array,                                   # raw numpy array
    columns=["goals", "assists"],                  # name the columns
    index=["Ali", "Bilal", "Hamza", "Zain"]         # name the rows
)


Common in ML workflows — a model produces a raw NumPy array, and it gets wrapped in a DataFrame just to make it human-readable


4. Creating a DataFrame — from a CSV

pythonsquad_df = pd.read_csv("fc_lahore_lions.csv")
print(squad_df.head())   # shows only the first 5 rows


The single most-used Pandas function in real data science work — almost every project starts by reading a CSV


5. Key attributes

pythonsquad.shape      # (rows, columns) — a tuple, no parentheses needed since it's an attribute
squad.dtypes      # data type of each column
squad.columns      # all column names
squad.index          # all row labels
squad.values           # raw data as a plain NumPy array, no labels

6. Selecting data

pythonsquad["goals"]                          # single column → Series
squad[["player", "goals"]]              # list of columns → DataFrame
squad.iloc[0:2]                         # rows by position (stop excluded)
squad.loc[squad["age"] > 25]            # rows by condition (boolean mask)
squad.iloc[-2:, 0:2]                    # rows AND columns in one call — [row_slice, col_slice]

Examples

python# Full worked example on a football squad
lions = pd.DataFrame({
    "player":  ["Ali", "Bilal", "Hamza", "Zain"],
    "goals":   [12, 9, 15, 4],
    "assists": [5, 8, 3, 10],
    "age":     [24, 27, 22, 29]
})

# Players with more than 8 goals, showing only name + goals
lions.loc[lions["goals"] > 8, ["player", "goals"]]

# Last 2 rows, first 2 columns only
lions.iloc[-2:, 0:2]

Common Mistakes


Writing squad.shape() with parentheses — .shape is an attribute, not a method, so this throws a TypeError
Using .loc(...) with round brackets instead of .loc[...] with square brackets — .loc is an indexer, not a callable function
Writing df["col1", "col2"] instead of df[["col1", "col2"]] — forgetting the inner list causes a KeyError
Assuming .iloc and .loc slicing work the same way — .loc can include the stop value and can fail with a KeyError after filtering, while .iloc never fails from filtering since it only counts by position
Confusing .shape's row/column counts with the actual content of the data — .shape only tells you size, never what's inside


Interview Questions


What is the difference between a Pandas Series and a DataFrame?
How would you create a DataFrame from a NumPy array with custom column and row names?
What is the difference between df.iloc[2] and df.loc[2], and when could they return different results?
Write one line of code to select two specific columns for all rows where a condition is true.
Why might .loc[2] raise a KeyError even though a DataFrame clearly has more than 2 rows?


Key Takeaways


A DataFrame is just multiple Series stacked together, sharing one index
.shape and .dtypes are the first two things to check on any new dataset
.iloc = position-based, .loc = label/condition-based — they are not interchangeable
Filtering with .loc[condition] keeps original row labels — it does not create a fresh 0,1,2... index
pd.read_csv() will be the single most-used function going forward, since real data always comes from files


Summary

Today covered the core building blocks of Pandas: Series vs DataFrame, the three main ways to construct a DataFrame, the key attributes used to inspect any dataset, and the four main ways to select data ([], [[]], .iloc, .loc). These fundamentals are used in literally every Pandas operation from here forward — Day 21 builds directly on this by cleaning messy, real-world data (missing values and duplicates).
