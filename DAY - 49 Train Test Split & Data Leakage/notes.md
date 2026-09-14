[Uploading notes.md…]()
# Train/Test Split & Data Leakage

## Quick Overview
- **Today's topic:** Splitting data into train/test sets correctly, and understanding data leakage — the #1 silent mistake beginners make in ML.
- **What I learned:** Why we must evaluate a model on data it has never seen, how to use `train_test_split`, and why preprocessing must happen *after* the split, not before.
- **Tech/tools used:** Python, `pandas`, `scikit-learn` (`train_test_split`, `StandardScaler`).

## Introduction
- Day 2 of Phase 4 (Machine Learning), right after locking in the ML mental model on Day 48.
- A model that's evaluated on the same data it was trained on will always look better than it actually is — today's goal is to stop that from happening.

## Definitions
- ✂️ **Train/test split:** dividing a dataset into a training set (used to fit the model) and a test set (used only to evaluate it).
- 🧪 **Test set:** data the model never sees during training — it simulates "the real world."
- 🕳️ **Data leakage:** when information from outside the training set (often the test set) accidentally influences training — making evaluation scores look better than they really are.
- 🎲 **`random_state`:** a fixed seed so the split is reproducible — same split every time the code runs.

## Important Concepts
- The whole point of a test set is honesty: if the model has already "seen" the test data in any form (even indirectly, through preprocessing), the evaluation is no longer trustworthy.
- `train_test_split(X, y, test_size=0.2, random_state=42)` is the standard pattern — 80% train, 20% test, reproducible via the seed.
- The most common leakage trap: scaling/normalizing the *entire* dataset before splitting. This lets statistics from the test set (its mean, its std) quietly leak into the training process.
- Correct order is always: **split first → then preprocess** (fit the scaler on train only, then apply it to both train and test).

## Step-by-Step Explanation
- **Step 1 — Load the raw data:** e.g. FC Lahore Lions match stats with a result column.
- **Step 2 — Split first:** `train_test_split` on the raw, unscaled data.
- **Step 3 — Fit preprocessing on train only:** e.g. `scaler.fit(X_train)` — the scaler learns mean/std from training data only.
- **Step 4 — Transform both sets:** `scaler.transform(X_train)` and `scaler.transform(X_test)` — test data is transformed using train's statistics, never its own.
- **Step 5 — Train the model** on the scaled training data.
- **Step 6 — Evaluate** on the scaled test data — this score is now trustworthy.

## Examples
- ⚽ **Correct:** split FC Lahore Lions match stats into train/test → fit a scaler on train only → transform both → train a model → evaluate on test.
- 🚫 **Leakage (wrong):** scale the *entire* dataset (train + test combined) before splitting → the scaler's mean/std were computed partly from test data → test scores now look artificially better than they'd be in the real world.

## Common Mistakes
- ❌ Scaling/normalizing before splitting — the single most common leakage bug.
- ❌ Forgetting `random_state`, making results non-reproducible between runs.
- ❌ Fitting the scaler on the test set (or on train+test combined) instead of train only.
- ❌ Assuming a high test score always means a good model — if there's leakage, it doesn't.

## Interview Questions
- Why do we split data into train and test sets?
- What is data leakage, and how does incorrect scaling cause it?
- What does `random_state` do in `train_test_split`, and why does it matter?
- Walk through the correct order of operations: split, then scale — why does order matter here?
- What would you expect to see if a model had data leakage during evaluation?

## Key Takeaways
- Test sets exist to simulate unseen, real-world data — never let training touch them.
- `train_test_split(X, y, test_size=0.2, random_state=42)` is the standard, reproducible pattern.
- Split first, preprocess second — always.
- Data leakage makes evaluation scores lie — a leaky model looks great in testing and fails in production.

## Summary
- Day 49 turned Day 48's mental model into real `sklearn` code: `train_test_split`, and the split-before-scale rule that prevents data leakage.
- Ran the same scaling step both ways — before splitting (wrong) and after splitting (correct) — to see firsthand how the score changes when leakage is removed.
- Next: this clean, correctly-split, leakage-free data becomes the foundation for the first real model.
