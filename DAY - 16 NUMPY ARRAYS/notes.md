# NumPy Arrays & Why They Exist

## Quick Overview
- **Topic:** NumPy Arrays — creation, attributes, indexing, and slicing (1D & 2D)
- **What I learned:** Why NumPy arrays beat Python lists for numeric work, how to build arrays with `zeros()`, `ones()`, `arange()`, `linspace()`, how to read `.shape`/`.ndim`/`.dtype`/`.size`, and how to index/slice 1D and 2D arrays
- **Tools used:** Python, NumPy, Jupyter Notebook

## Introduction
Day 16 kicks off Phase 2 (Data Tools) of the 90-Day Data Science Roadmap. NumPy arrays are the foundation every major data science library — Pandas, scikit-learn, TensorFlow — is built on top of. Before touching Pandas DataFrames, it's essential to understand what an array actually is and why it exists as a separate data structure from a Python list.

## Definitions
- **NumPy array (`ndarray`):** A grid of values, all of the same data type, stored in one contiguous block of memory.
- **Vectorized operation:** An operation applied to an entire array at once (e.g. `arr * 2`), instead of looping element-by-element in Python.
- **Shape:** A tuple describing an array's dimensions, e.g. `(3, 3)` means 3 rows and 3 columns.
- **Broadcasting-ready structure:** Because all elements share one data type, NumPy can run fast, low-level math across the whole array in a single instruction.

## Important Concepts
- `np.array()` — builds a 1D or 2D array from a Python list (or nested lists)
- Why arrays outperform lists — contiguous memory + same data type + no per-element Python loop
- `np.zeros(n)`, `np.ones(n)` — placeholder arrays
- `np.arange(start, stop)` — stop value is **excluded**
- `np.linspace(start, stop, num)` — stop value is **included**
- `.shape`, `.ndim`, `.dtype`, `.size` — the four core attributes for inspecting any array
- 1D indexing/slicing: `arr[i]`, `arr[start:stop]`
- 2D indexing/slicing: `arr[row, col]`, `arr[:, col]` (column), `arr[row, :]` (row)

## Step-by-Step Explanation
1. Convert a familiar Python list into a NumPy array with `np.array()` to see it's just a faster container for the same data.
2. Compare doubling values the list way (loop/list comprehension) vs. the array way (`arr * 2`) to feel the vectorization difference.
3. Build placeholder/range arrays with `zeros()`, `ones()`, `arange()`, `linspace()` — each solving a different "I need N values" situation.
4. Inspect any array immediately with `.shape`, `.ndim`, `.dtype`, `.size` before doing further work — this habit prevents dimension-mismatch bugs later.
5. Pull out single values, rows, columns, and ranges using indexing and slicing — the same logic Pandas' `.iloc` will reuse later.

## Examples
```python
import numpy as np

# 1D array from a list
goals_array = np.array([5, 8, 2, 12, 6])

# Vectorized math — no loop needed
doubled = goals_array * 2

# 2D array: players x matches
lions_goals = np.array([
    [1, 0, 2],
    [0, 1, 1],
    [2, 2, 0]
])

# Attributes
print(lions_goals.shape)   # (3, 3)
print(lions_goals.dtype)   # int64

# Indexing & slicing
print(lions_goals[1, :])   # row: one player's full match history
print(lions_goals[:, 1])   # column: everyone's goals in one match
```

## Common Mistakes
- Passing multiple arguments to `np.array()` instead of one list: `np.array(1, 2, 3)` ❌ vs `np.array([1, 2, 3])` ✅
- Forgetting `np.arange(start, stop)` excludes `stop` — off-by-one errors when counting matches/weeks
- Confusing `.shape` (dimensions as a tuple) with `.size` (total element count)
- Mixing up row slice `arr[row, :]` with column slice `arr[:, col]`
- Assuming `python_list * 2` does elementwise math — it actually repeats the list

## Interview Questions
1. Given `arr = np.array([1,2,3,4,5])`, write code to get every element except the first and last using slicing.
2. Given a 2D array with shape `(4, 5)`, write code to print the last row without hardcoding the row number.
3. Explain — with code — why `np.array([1,2,3]) * 2` and `[1,2,3] * 2` give different results.

## Key Takeaways
- NumPy arrays are faster than lists because of contiguous memory + a single shared data type + vectorized operations.
- `arange()` excludes the stop value; `linspace()` includes it — easy to mix up, important to remember.
- `.shape`, `.ndim`, `.dtype`, `.size` should be checked as a habit before working with any new array.
- 2D indexing follows `[row, col]` — `:` in either slot means "give me everything along that axis."

## Summary
Day 16 built the foundation for all of Phase 2: understanding what a NumPy array is, why it exists, how to create one several different ways, how to inspect it, and how to pull out exactly the data needed through indexing and slicing. Every future NumPy, Pandas, and ML session builds directly on these mechanics.
