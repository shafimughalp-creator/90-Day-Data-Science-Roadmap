# NumPy Boolean Masking & The Random Module

## Quick Overview
Day 19 of the Data Science Roadmap. Learned how to filter NumPy arrays using
conditions instead of loops, and how to generate reproducible random data.
Tools used: Python, NumPy.

## Introduction
Real datasets are rarely used in full — you almost always need a *subset* that
meets some condition ("players who ran more than 10km", "prices under $50").
Boolean masking is NumPy's built-in way to do this filtering, and the random
module lets you simulate data or sample from it when real data isn't available.

## Definitions
- **Boolean mask** — an array of `True`/`False` values, same shape as the
  original array, produced by applying a condition to it
- **Vectorized operation** — an operation applied to every element of an array
  at once, without writing an explicit loop
- **Seed (`np.random.seed()`)** — a starting number that makes NumPy's "random"
  number generator produce the same sequence every time
- **Sampling** — picking a subset of items from an array, with or without
  allowing repeats (`replace=True`/`False`)

## Important Concepts
- A condition like `distances > 10.5` doesn't return the matching values —
  it returns a **mask** of True/False, one per element
- Applying the mask with `array[mask]` is what actually pulls out the values
- Combining conditions requires bitwise operators: `&` (AND), `|` (OR) — not
  Python's `and`/`or`, which don't work element-wise on arrays
- Every condition in a combined expression needs its own parentheses
- `np.where(condition, value_if_true, value_if_false)` replaces or labels
  values in one line — it's a vectorized if/else
- `np.random.seed(n)` must be called *before* the random function to lock
  results — the same seed always produces the same "random" output

## Step-by-Step Explanation
1. Create or load a NumPy array of numbers
2. Write a condition on the array (e.g. `arr > 10`) — NumPy applies it to
   every element and returns a Boolean mask
3. Pass that mask inside square brackets — `arr[mask]` — to extract only the
   `True` positions
4. For multiple conditions, wrap each one in parentheses and join with `&`
   or `|`
5. For labeling instead of filtering, use `np.where(condition, "label_if_true",
   "label_if_false")`
6. For random data, call `np.random.seed(42)` first, then generate numbers with
   `np.random.randint()`, `np.random.randn()`, or `np.random.choice()`

## Examples
- Filtering: `elite_runners = distances[distances > 10.5]` — extracts only
  distances over 10.5km
- Multi-condition: `optimal_zone = (distances > 10.0) & (distances < 11.8)`
- Labeling: `fitness_labels = np.where(distances >= 10.5, "High", "Normal")`
- Sampling without repeats: `np.random.choice(squad_numbers, size=3, replace=False)`

## Common Mistakes
- Forgetting parentheses around each condition when using `&`/`|` — causes a
  confusing error or wrong result due to operator precedence
- Using Python's `and`/`or` instead of `&`/`|` on arrays — raises a
  "truth value of an array is ambiguous" error
- Forgetting to set the seed before generating random numbers — makes results
  impossible to reproduce for testing or sharing
- Confusing `np.random.randint(low, high)` bounds — `high` is exclusive, not
  inclusive

## Interview Questions
- What's the difference between Python's `and`/`or` and NumPy's `&`/`|`?
- Why does `np.random.seed()` matter for reproducibility in data science?
- How would you extract all rows in an array meeting two conditions at once?
- What does `np.where()` return, and how is it different from Boolean masking?
- What's the difference between sampling `replace=True` and `replace=False`?

## Key Takeaways
- Boolean masks let you filter arrays by condition without loops
- `&` and `|` combine conditions — always with parentheses around each one
- `np.where()` is a vectorized if/else for labeling or replacing values
- `np.random.seed()` makes random results reproducible — essential for
  sharing and debugging code
- `np.random.choice()` samples from an array, with control over repeats

## Summary
Today covered how to filter NumPy arrays using Boolean masks, combine
multiple conditions safely, replace values conditionally with `np.where()`,
and generate reproducible random data with the random module. These are core
tools for cleaning and exploring data before any real analysis begins.
