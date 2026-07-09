# Day 17 — NumPy: Operations & Broadcasting

## Quick Overview
- **Topic:** NumPy vectorized math, broadcasting rules, axis-based aggregation, reshape & transpose
- **What I learned:** how NumPy runs math on entire arrays at once (no loops), and how it lets differently-shaped arrays work together through broadcasting
- **Tools:** Python, NumPy, Jupyter Notebook

## Introduction
Today built on Day 16's array basics by moving into what you actually *do* with arrays: math operations across whole datasets in one instruction, combining arrays of different shapes, summarizing data by row/column, and reshaping data into the format ML libraries expect. Every example used FC Lahore Lions match data — goals, assists, and shots across a 4-match stretch for a 5-player squad.

## Definitions
- **Vectorized math** — applying an operation (`*`, `+`, etc.) to every element of an array at once, instead of looping through it manually.
- **Broadcasting** — NumPy's rule set for letting arrays of different shapes work together in an operation, by "stretching" the smaller array to match the bigger one.
- **Axis** — the dimension a NumPy operation collapses. `axis=0` collapses rows (result = one value per column). `axis=1` collapses columns (result = one value per row).
- **Reshape** — changing an array's shape without changing its data or element count.
- **Transpose (`.T`)** — flipping an array's rows and columns.

## Important Concepts
- Lists and arrays behave differently under `*` — `list * 3` repeats the list, `array * 3` multiplies every element.
- Broadcasting compares shapes from the right; the trailing dimensions must match (or be 1) for the operation to work.
- `reshape(-1, 1)` is the pattern sklearn expects for single-feature input — NumPy auto-calculates the row count.
- Transposing an array changes what each axis number means — `axis=0` on the original is not the same as `axis=0` on the transpose.

## Step-by-Step Explanation
1. Start with vectorized math — multiply/add whole arrays in one line.
2. Move to broadcasting — first with a scalar, then with a 1D array against a 2D array, following the shape-matching rule.
3. Use `axis=0` / `axis=1` with `.sum()`, `.mean()`, `.max()` to aggregate a 2D array by column or row.
4. Reshape a flat array into a grid, and into a column vector with `reshape(-1,1)`.
5. Transpose a 2D array with `.T` and confirm that axis meaning flips with it.

## Examples
```python
import numpy as np

goals = np.array([2, 1, 0, 3, 1])
points = goals * 3                     # vectorized math

goals_matrix = np.array([
    [2, 1, 0, 3, 1],
    [1, 0, 2, 1, 0],
    [3, 2, 1, 0, 2],
    [0, 1, 1, 2, 1]
])

player_bonus = np.array([0, 1, 0, 0, 1])
boosted = goals_matrix + player_bonus   # broadcasting (5,) across (4,5)

per_player = goals_matrix.sum(axis=0)   # totals per player
per_match  = goals_matrix.sum(axis=1)   # totals per match

goals_column = goals.reshape(-1, 1)     # column vector for sklearn
flipped = goals_matrix.T                # transpose
```

## Common Mistakes
- Adding arrays of mismatched shapes (`(4,)` vs `(5,)`) — throws `ValueError: operands could not be broadcast together`.
- Calling `.sum()` with no `axis` when a per-row/per-column result was actually needed — collapses everything to a single number.
- Assuming `axis=0` means the same thing before and after a transpose — it doesn't, since the shape (and therefore which dimension "0" refers to) has changed.
- `reshape()` with row × column counts that don't match the original element count — throws a `ValueError`.

## Interview Questions
1. Given a `(3,2)` sales array (3 days × 2 products), find total sales per product.
2. Given `weights = np.array([0.5, 0.3, 0.2])` and a `(4,3)` feature array, apply the weights to every row using broadcasting.
3. Explain why `np.array([1,2,3]) + np.array([1,2])` throws an error, and fix it.

## Key Takeaways
- Vectorized operations replace loops entirely for array math — faster and more readable.
- Broadcasting has one strict rule: shapes must align on the trailing dimension (or be 1) — no exceptions.
- `axis` describes which dimension disappears in the output, not which one survives.
- Transposing changes axis meaning — always re-check shape after `.T` before choosing an axis.

## Summary
Day 17 covered how NumPy performs fast, loop-free math across arrays, how broadcasting lets differently-shaped arrays interact safely, how `axis` controls row-wise vs column-wise aggregation, and how reshape/transpose reformat data for downstream tools like sklearn. These four operations are the backbone of nearly every data-cleaning and feature-engineering step still to come in the roadmap.
