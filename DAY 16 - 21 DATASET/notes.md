# Mini-Project: FC Lahore Lions Scouting Report (Days 16–21 Recap)

## Quick Overview
- Today's topic: combining everything from Days 16–21 (NumPy arrays → Pandas cleaning) into one real mini-project instead of six separate ones.
- One-line takeaway: raw stats become a real decision (Top 3 scouting picks) only after they've been shaped, scored, filtered, and cleaned — every step matters.
- Tools used: Python, NumPy, Pandas, Jupyter Notebook.

## Introduction
- This project simulates a real scouting job: the coach hands over a messy stat sheet for 6 FC Lahore Lions players, and the task is to turn it into a clean, ranked shortlist.
- Instead of practicing NumPy and Pandas as separate, disconnected exercises, this mini-project chains them together in the order a real data task would need them: load data → transform it → score it → filter it → clean it → report it.
- Every concept from Day 16 through Day 21 shows up here for a specific reason, not just to tick a box.

## Definitions
- **NumPy array** — a grid of numbers (1D or more) that supports fast, whole-grid math operations, unlike a plain Python list.
- **Broadcasting** — NumPy automatically "stretching" a smaller array to match a bigger one so they can be combined, without writing a loop.
- **Axis** — the direction a NumPy operation collapses along; `axis=0` walks down columns, `axis=1` walks across rows.
- **Dot product** — multiplying matching elements of two arrays and summing the result; used here to turn multiple stats into one weighted score.
- **Cosine similarity** — a score from 0 to 1 measuring how similar the *shape* (ratio) of two vectors is, ignoring their raw size.
- **Boolean mask** — an array of `True`/`False` values used to filter another array, keeping only the `True` positions.
- **`np.where()`** — a vectorized if/else that labels every element of an array in one line.
- **Pandas Series** — a 1D array that also carries a label (index) for every value.
- **Pandas DataFrame** — a table made of columns, each of which can be a different data type.
- **`.loc` / `.iloc`** — `.loc` selects rows by a condition/label, `.iloc` selects rows by raw position number.
- **Missing value (NaN)** — a blank spot in a dataset, represented in Pandas as `NaN` ("Not a Number").
- **Duplicate row** — a row that repeats information already present elsewhere in the dataset.

## Important Concepts
- **Shape awareness matters before any math.** Checking `.shape`, `.ndim`, and `.dtype` first prevents confusing errors later — you always know what grid you're working with.
- **Broadcasting removes the need for loops.** A bonus array of length 3 correctly applies itself across all 6 player rows automatically, as long as the lengths are compatible.
- **`axis=0` vs `axis=1` is a direction, not a difficulty.** `axis=0` = "per column" (team totals), `axis=1` = "per row" (per-player totals).
- **A dot product is a weighted sum in disguise.** `np.dot(stats, weights)` replaces `goals*3 + assists*2 + shots*1` for every player, all in one line.
- **Cosine similarity compares style, not scale.** Two players with very different raw numbers can still score close to 1.0 if their stats are in the same *ratio*.
- **Boolean masks and `np.where()` both avoid manual loops** — one filters, the other labels.
- **`np.random.seed()` makes "random" results reproducible** — critical for any report that needs to be checked or re-run later.
- **A DataFrame is just a dictionary of columns.** Each key in `pd.DataFrame({...})` becomes a column name.
- **Cleaning always comes before scoring, not after.** Missing values and duplicates must be handled first, or the final ranking will be wrong.

## Step-by-Step Explanation
1. Convert the raw player list and goals into a NumPy array (Day 16).
2. Build the full 2D stats grid (6 players × 3 stats: goals, assists, shots) and inspect its shape.
3. Apply bonuses using broadcasting, then get team and per-player totals with axis-based aggregation (Day 17).
4. Reshape and transpose the data to see it from a different angle.
5. Compute a weighted **performance score** for every player using the dot product (Day 18).
6. Check prediction accuracy with RMSE, and compare player styles with cosine similarity.
7. Use boolean masking to flag elite scorers, and `np.where()` to label every player Star/Regular (Day 19).
8. Simulate a new trialist's stats using the random module with a fixed seed.
9. Load the scouting data into a Pandas DataFrame, including a few intentional gaps and one duplicate row (Day 20).
10. Filter the table using `.loc` (by condition) and `.iloc` (by position).
11. Detect missing values with `.isnull().sum()`, then fill them sensibly — median for numeric age, mode for categorical position (Day 21).
12. Detect and remove the duplicate row using `.drop_duplicates(subset=["player"])`.
13. Recompute the performance score on the cleaned table, rank players, and produce the final Top 3 scouting picks.

## Examples
- `squad_stats[2, :]` → pulls one player's full row (all their stats at once).
- `squad_stats.sum(axis=0)` → team totals per stat (goals, assists, shots).
- `np.dot(squad_stats, weights)` → one performance score per player, no loop needed.
- `goals > 8` → a boolean mask that flags elite scorers.
- `squad_df.loc[squad_df["position"] == "Forward"]` → every Forward on the squad.
- `squad_df["age"].fillna(squad_df["age"].median())` → fills missing ages sensibly.
- `squad_df.drop_duplicates(subset=["player"], keep="first")` → removes the repeated Zain entry.

## Common Mistakes
- Assuming `duplicated()` with no arguments checks what you expect — by default it compares the **entire row**, so a single differing column (even a filled-in missing value) can hide a real duplicate. Always specify `subset=[...]` for the column that actually defines a duplicate.
- Filling missing numeric values with the **mean** instead of the **median** — the mean is easily skewed by one outlier, the median isn't.
- Confusing `axis=0` and `axis=1` — a common early mix-up; remember `axis=0` moves down, `axis=1` moves across.
- Forgetting that broadcasting only works when array shapes are compatible — mismatched lengths will throw an error instead of silently doing the wrong thing.
- Treating cosine similarity like a percentage of "sameness" in raw values — it only measures shape/ratio, not magnitude.

## Interview Questions
- What's the difference between a Python list and a NumPy array, and why does it matter for performance?
- Explain broadcasting in NumPy with an example.
- What's the difference between `axis=0` and `axis=1` in a NumPy aggregation?
- How would you use the dot product to compute a weighted score across multiple features?
- What does cosine similarity measure, and how is it different from Euclidean distance?
- What's the difference between `.loc` and `.iloc` in Pandas?
- How do you handle missing values in a dataset, and how do you decide between mean, median, and mode?
- Why might `.duplicated()` fail to catch an actual duplicate row, and how do you fix that?

## Key Takeaways
- NumPy and Pandas aren't separate topics — real projects chain them together, NumPy for the math, Pandas for the table.
- Vectorized operations (broadcasting, boolean masks, `np.where`) replace loops and make code both faster and shorter.
- Cleaning a dataset (missing values, duplicates) has to happen before scoring or ranking it, or the final result is unreliable.
- Small default behaviors (like `duplicated()` checking the whole row) can silently produce wrong results if not double-checked.

## Summary
This mini-project combined six days of separate NumPy and Pandas practice into one connected workflow: turning a raw, messy player stat sheet into a clean, ranked scouting report. It covered array creation and indexing, broadcasting and axis aggregation, dot products and similarity scoring, boolean masking and vectorized labeling, DataFrame construction and filtering, and finally missing-value/duplicate cleaning — ending with a real, usable Top 3 shortlist for the coach.
