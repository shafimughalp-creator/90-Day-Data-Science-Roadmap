[Uploading notes.md…]()
# Overfitting & Underfitting — Visual Intuition

## Quick Overview
- **Topic:** Overfitting vs Underfitting — why models fail, and how to *see* it happening.
- **What I learned:** Every model either memorizes noise (overfits) or misses the pattern entirely (underfits) — learning curves make this visible instead of theoretical.
- **Tools used:** Python, Pandas, Scikit-learn (`DecisionTreeClassifier`, `learning_curve`), Matplotlib.

## Introduction
Day 50 of the 90-Day Data Science Roadmap. Up to this point I've trained models and checked accuracy — but never asked *why* a model performs the way it does on unseen data. Today's session is about diagnosing that: is the model too simple, or too obsessed with the training data?

I used FC Lahore Lions match data (shots, possession, pass accuracy → win/loss) and a Decision Tree at different depths to watch bias and variance play out in real numbers, not just definitions.

## Definitions
- **Underfitting:** the model is too simple to capture the real pattern in the data. It performs poorly on *both* the training set and the test set.
- **Overfitting:** the model is too complex — it memorizes the training data (including its noise) instead of learning the general pattern. It performs great on training data but poorly on new, unseen data.
- **Bias:** error from a model being too simple / making strong assumptions (→ underfitting).
- **Variance:** error from a model being too sensitive to the specific training data it saw (→ overfitting).
- **Learning curve:** a plot of training score and validation score as training set size (or model complexity) increases — it's the visual fingerprint of bias vs variance.

## Important Concepts
- **High bias signature:** train error is high AND test error is high, and they're close to each other. The model is "too dumb" — adding more data won't fix it, the model itself needs to get more expressive.
- **High variance signature:** train error is low but test error is high — there's a big *gap* between them. The model has learned the training set by heart, including its noise.
- **The sweet spot:** somewhere between underfitting and overfitting is a model complexity where test error is minimized — that's the goal, not perfect training accuracy.
- **Three fixes for overfitting**, and when to reach for each:
  - **More training data** → works when the model is fundamentally right but hasn't seen enough variety to generalize.
  - **Simpler model** → works when the model has more capacity than the problem needs (e.g. reduce `max_depth`, use fewer features).
  - **Regularization** → works when you want to keep model capacity but *penalize* complexity directly (e.g. `ccp_alpha` pruning in trees, L1/L2 in linear models).

## Step-by-Step Explanation
1. Load FC Lahore Lions match stats and split into train/test sets.
2. Train a `DecisionTreeClassifier` with `max_depth=1` (too shallow) → observe both train and test accuracy are low → underfitting.
3. Train the same model with `max_depth=None` (unlimited) → observe train accuracy near 100%, but test accuracy drops → overfitting.
4. Use `sklearn.model_selection.learning_curve` to plot train vs validation score across a range of `max_depth` values (1 to 15).
5. Read the curve to shortlist a depth where validation score peaks.
6. Try both remaining fixes — the depth picked from the curve, and regularization via cost-complexity pruning — and compare, instead of assuming the curve's pick is automatically the best fix.

## Examples
- **Underfit tree (`max_depth=1`):** train accuracy ≈ 58%, test accuracy ≈ 54% — both low, both close together. One yes/no split can't capture a pattern that depends on the *combination* of two stats, so it barely beats a coin flip.
- **Overfit tree (`max_depth=None`):** train accuracy ≈ 100%, test accuracy ≈ 77% — a 23-point gap. It memorized every match, including the noisy exceptions, instead of learning the general pattern.
- **Simpler-model fix (`max_depth=10`, the depth the learning curve pointed to):** train accuracy ≈ 98%, test accuracy ≈ 74% — better than unlimited depth, but still a real gap. The curve's pick wasn't a clean fix on its own.
- **Regularization fix (`ccp_alpha=0.02` pruning):** train accuracy ≈ 84%, test accuracy ≈ 90% — the smallest gap of all three, and the highest test score. Pruning the noise-memorizing branches generalized better than simply capping depth.

## Common Mistakes
- Judging a model only by training accuracy — a 99% training score can be a red flag, not a win.
- Assuming more data *always* fixes overfitting — it only helps when the model's complexity is otherwise appropriate.
- Confusing "the model got worse on test data" with "the test data is bad" — it's usually the model that's the problem.
- Tuning `max_depth` by eyeballing one train/test split instead of using a learning curve or cross-validation — a single split can mislead.

## Interview Questions
- **Q: What's the difference between bias and variance?**
  A: Bias is error from an overly simple model that misses real patterns (underfitting). Variance is error from a model being too sensitive to the exact training data it saw (overfitting).
- **Q: How would you detect overfitting without touching the test set?**
  A: Use cross-validation on the training set, or plot a learning curve — a large, persistent gap between training and validation score signals overfitting even before touching held-out test data.
- **Q: Your model has 98% train accuracy and 65% test accuracy. What do you do?**
  A: Reduce model complexity (e.g. lower `max_depth`), add regularization, or gather more training data — and re-check with a learning curve rather than guessing.
- **Q: Does adding more data always fix overfitting?**
  A: No — only when the model is capable of representing the pattern but was starved of examples. If the model itself is too complex for the problem, more data delays but doesn't remove the overfitting.

## Key Takeaways
- Underfitting = high error everywhere. Overfitting = low train error, high test error, big gap.
- Learning curves turn "is my model okay?" from a guess into something you can see on a plot.
- The goal isn't the lowest training error — it's the lowest **test** error.
- Three levers to fight overfitting: more data, simpler model, regularization — pick based on *why* it's overfitting, not by default, and don't assume the first fix you try is the best one.

## Summary
Today was about learning to read a model's behavior instead of just trusting its accuracy score. A Decision Tree at different depths on FC Lahore Lions match data made bias and variance concrete: too shallow and it misses the pattern, too deep and it memorizes noise. The real surprise was that "pick the depth from the learning curve" wasn't the best fix here — regularization (pruning) beat it. Comparing fixes instead of trusting the first one is now part of my toolkit before deploying any model.
