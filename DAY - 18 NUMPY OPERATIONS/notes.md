# Day 18 — NumPy Math Operations for Data Science

## Quick Overview
- **Topic:** NumPy math operations — matrix multiplication, sqrt/exp/log, and two ML-style metrics built from scratch.
- **What I learned:** How to turn math formulas (weighted scores, RMSE, cosine similarity) into a few lines of vectorized NumPy code.
- **Tools used:** Python, NumPy, Jupyter Notebook.
- **Dataset:** FC Lahore Lions ⚽ synthetic player stats (goals, assists, shots, passes).

## Introduction
Day 18 of the 90-Day Data Science Roadmap (Phase 2 — NumPy, Pandas, Visualization). This session covers the core math tools that show up again and again in machine learning: matrix multiplication, element-wise math functions, and two metrics (RMSE and cosine similarity) built entirely from scratch — no sklearn.

## Definitions
- **Matrix multiplication (`np.dot`)** — combines two vectors/matrices by multiplying corresponding elements and summing the result.
- **`np.sqrt()`** — square root of each element; undoes squaring.
- **`np.exp()`** — e^x for each element; models explosive growth.
- **`np.log()`** — natural log of each element; undoes `exp`.
- **RMSE (Root Mean Squared Error)** — average prediction error, expressed in the same unit as the target variable.
- **Cosine Similarity** — a score from -1 to 1 measuring how similar two vectors' *directions* are, regardless of their size.

## Important Concepts
- `np.dot(A, B)` works differently depending on shape: vector·vector gives a single number, matrix·vector gives a weighted score per row, matrix·matrix combines two matrices (columns of A must match rows of B).
- Squaring errors before averaging (not after) is what makes RMSE mathematically correct — `sqrt(mean(errors**2))`, not `sqrt(mean(errors)**2)`.
- Cosine similarity needs **both** vectors' magnitudes in the denominator — magnitude is `sqrt(sum(squares))`, not just `sum(squares)`.
- `np.log()` and `np.exp()` are inverse operations: `log(exp(x)) == x`.

## Step-by-Step Explanation
1. Build a stats matrix per player (rows = players, columns = stats).
2. Multiply by a weights vector with `np.dot()` to get one performance score per player.
3. Use `np.sqrt`, `np.exp`, `np.log` for any transformation that needs to scale, grow, or reverse values.
4. For RMSE: subtract → square → average → square root.
5. For cosine similarity: dot product of two vectors, divided by the product of their magnitudes.

## Examples
```python
# Weighted performance score
players = np.array([[2, 1, 5], [0, 3, 2], [1, 1, 4]])
weights = np.array([3, 2, 1])
scores = np.dot(players, weights)   # [13 12  9]

# Manual RMSE
rmse = np.sqrt(np.mean((y_pred - y_actual) ** 2))

# Cosine similarity
similarity = np.dot(a, b) / (np.sqrt(np.sum(a**2)) * np.sqrt(np.sum(b**2)))
```

## Common Mistakes
- Squaring the *mean* of the errors instead of the mean of the *squared* errors — gives a wrong RMSE value whenever errors have mixed signs.
- Forgetting `np.sqrt()` in the cosine similarity denominator — using raw sum of squares instead of magnitude.
- Mismatched shapes in `np.dot()` — columns of the first array must equal rows of the second.
- Calling `np.log()` or `np.sqrt()` on negative numbers — returns `nan` instead of crashing, so bad inputs can silently break a pipeline.

## Interview Questions
1. Write a function that computes RMSE between two NumPy arrays without using sklearn.
2. Given two feature vectors, write code to compute their cosine similarity from scratch.
3. What's the difference between `np.dot(A, B)` and `np.dot(B, A)` for two matrices — when do they give the same result, and when don't they?

## Key Takeaways
- `np.dot()` is the same operation used inside every linear model and neural network layer — not just a NumPy trick.
- RMSE is the standard way regression models are evaluated — always report it in the original unit, not squared.
- Cosine similarity is the same math behind real-world recommendation systems (Netflix, Spotify).
- Vectorized NumPy code replaces loops entirely — faster and more readable.

## Summary
Today connected pure math formulas to working code: weighted scoring with matrix multiplication, error measurement with manual RMSE, and similarity scoring with cosine similarity — all practiced on FC Lahore Lions player data and wrapped up in a full "Scout Report" mini-project.

---
🔗 GitHub Repository: [Add GitHub Repository Link Here]
