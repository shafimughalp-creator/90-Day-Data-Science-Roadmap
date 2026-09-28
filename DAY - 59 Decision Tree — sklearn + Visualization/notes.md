[Uploading day_59_decision_tree_sklearn_visualization_notes.md…]()
# Day 59: Decision Tree — sklearn + Visualization

## Quick Overview
- **Topic:** Building a decision tree in sklearn, visualizing it, and seeing overfitting happen live.
- **What I learned:** a fully grown tree can memorise the training data, and `plot_tree` plus `feature_importances_` make a tree easy to inspect and explain.
- **Tools used:** Python, NumPy, pandas, Matplotlib, scikit-learn (`DecisionTreeClassifier`, `plot_tree`, `train_test_split`, `cross_val_score`, `confusion_matrix`).

## Introduction
- Day 58 was the hand-worked theory (entropy, information gain). Today sklearn does that automatically.
- Dataset: 500 synthetic FC Lahore Lions matches (`seed = 42`) with `shots_on_target`, `possession_pct`, `pass_accuracy_pct`, `home_game`, `opponent_rank`, `kickoff_hour` and `won`.
- `kickoff_hour` was built to have **no link** to the result, on purpose, to see whether the tree picks up on noise.
- Split: 375 training rows, 125 test rows (`stratify=y`).

## Definitions
- **`DecisionTreeClassifier`:** sklearn's tree model. `.fit()` builds the tree, `.predict()` uses it.
- **`plot_tree()`:** draws the tree. Each box shows the split rule, Gini impurity, sample count, class counts and majority class.
- **`max_depth`:** the maximum number of splits from root to leaf. `None` means no limit (fully grown).
- **Overfitting:** a model that fits the training data very closely but fails to generalise to new data.
- **`feature_importances_`:** for each feature, its total share of impurity reduction across the tree. Values sum to 1.

## Important Concepts
- **Reading a tree diagram**
  - The root box in this tree: `shots_on_target <= 7.5`, Gini `0.5`, 375 samples.
  - Each arrow is `True` (left) or `False` (right) for the condition above it.
  - A leaf's `class =` row is the majority prediction for that leaf.
- **Overfitting, shown directly**
  - Fully grown tree: depth 13, 84 leaves, train accuracy **1.0**, test accuracy **0.672**.
  - `max_depth=3`: depth 3, 8 leaves, train accuracy **0.813**, test accuracy **0.768**.
  - The simpler tree scored **lower on train but higher on test** — the classic overfitting signature.
- **Choosing depth with CV, not eyeballing**
  - 5-fold CV mean accuracy: depth 1 → 0.789, depth 2 → 0.784, depth 3 → 0.773, depth 5 → 0.736, unlimited → 0.731.
  - The best depth here was **1** (a single split, sometimes called a "stump").
  - This makes sense for this dataset: one feature (`shots_on_target`) carries almost all of the signal, so extra splits mostly add noise rather than real structure.
- **Feature importances**
  - `max_depth=3` tree: `shots_on_target` 0.899, `opponent_rank` 0.051, `possession_pct` 0.050, and `pass_accuracy_pct`, `home_game`, `kickoff_hour` all 0.000.
  - Fully grown tree: `shots_on_target` 0.484, then `possession_pct` 0.145, `opponent_rank` 0.144, `pass_accuracy_pct` 0.133, `kickoff_hour` 0.057, `home_game` 0.037.
  - `kickoff_hour` was designed to be irrelevant. It scored **0** in the shallow trees, and only got a small, non-zero importance (0.057) once the fully grown tree had enough splits to fit noise.
  - A feature at 0 does not mean "definitely useless" — only that this particular tree never needed it.

## Step-by-Step Explanation
- **Step 1:** Split into train and test.
- **Step 2:** `tree = DecisionTreeClassifier(max_depth=3, random_state=42)`, then `.fit(X_train, y_train)`.
- **Step 3:** `plot_tree(tree, feature_names=..., class_names=..., filled=True)` to see it.
- **Step 4:** Compare a fully grown tree (`max_depth=None`) against a limited one on train and test accuracy.
- **Step 5:** Use `cross_val_score` across several `max_depth` values to choose depth honestly.
- **Step 6:** Read `feature_importances_` to see which features actually mattered.

## Examples
- **Confusion matrix (max_depth=3, test set):** `[[55, 7], [22, 41]]` — 55 losses called correctly, 41 wins called correctly, 7 false alarms, 22 missed wins.
- **Root split:** `shots_on_target <= 7.5`, covering all 375 training matches.
- **Overfitting table:**

  | Tree | Depth | Leaves | Train acc | Test acc |
  |------|-------|--------|-----------|----------|
  | Fully grown | 13 | 84 | 1.000 | 0.672 |
  | max_depth=3 | 3 | 8 | 0.813 | 0.768 |

- **CV across depths:** best was depth 1, mean CV accuracy 0.789.
- **Practice:** `max_depth=2` scored 0.744 on the test set, with `shots_on_target` at importance 1.0 (the only feature used) — the same top feature as `max_depth=3`.
- **Mini challenge:** the CV-chosen depth was 1, matching the earlier scan, with a final test accuracy of 0.744.

## Common Mistakes
- Growing a tree with no depth limit and assuming perfect training accuracy means a good model.
- Reading `feature_importances_` as "the truth" about which features matter in the real world, rather than which features this specific tree happened to use.
- Choosing `max_depth` by eye instead of with cross-validation.
- Forgetting that importances are specific to one tree; a different depth or a different random seed can shift them.
- Treating an importance of 0 as proof that a feature is useless in general.
- Not checking the confusion matrix, and only looking at accuracy.

## Interview Questions
- What does `plot_tree()` show at each node?
- How do fully grown and shallow trees differ in bias and variance?
- What is `feature_importances_` measuring? What is a common misreading of it?
- Why can train accuracy be misleadingly high?
- How would you choose `max_depth` properly?
- What did the deliberately irrelevant feature show you in this experiment?
- Give an example where a shallow tree beats a fully grown one on test data.

## Key Takeaways
- A fully grown tree can hit perfect training accuracy while doing worse on new data.
- A shallow tree can score lower on train but higher on test — that gap is the overfitting signal.
- Choose tree depth with cross-validation, the same pattern as choosing K for KNN (Day 57).
- `feature_importances_` shows what a specific tree relied on, not an absolute ranking of real-world importance.
- `plot_tree()` is a genuinely useful way to explain a model to someone non-technical.

## Summary
- Built a decision tree in sklearn on 500 synthetic matches and visualized it with `plot_tree()`.
- Fully grown tree: train 1.0, test 0.672. `max_depth=3`: train 0.813, test 0.768 — overfitting shown directly.
- 5-fold CV across depths chose depth 1 as the strongest, since one feature carries almost all the signal here.
- `feature_importances_` correctly gave the deliberately irrelevant feature an importance of 0 in the shallow trees.
- **Next: Day 60.** Random Forest: ensemble and bagging theory.
