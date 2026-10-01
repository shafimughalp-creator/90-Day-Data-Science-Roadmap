[Uploading day_61_random_forest_sklearn_feature_importance_notes.md…]()
# Day 61: Random Forest — sklearn + Feature Importance

## Quick Overview
- **Topic:** Using sklearn's `RandomForestClassifier`, reading feature importances, and using the OOB score for free validation.
- **What I learned:** a forest beats a single overfit tree, OOB gives a validation estimate with no extra split, and impurity-based feature importance can be misleading, so it needs a cross-check.
- **Tools used:** Python, NumPy, pandas, Matplotlib, scikit-learn (`RandomForestClassifier`, `DecisionTreeClassifier`, `cross_val_score`, `permutation_importance`, `confusion_matrix`, `classification_report`).

## Introduction
- Day 60 built bagging and feature randomness by hand. Day 61 uses the real sklearn class that does all of that in one line.
- Dataset: 500 synthetic FC Lahore Lions matches (`seed = 42`), the same data as Days 59 and 60. It has `shots_on_target`, `possession_pct`, `pass_accuracy_pct`, `home_game`, `opponent_rank`, `kickoff_hour` and `won`.
- `kickoff_hour` has **no link** to the result, on purpose, so I can see how importance measures treat a useless feature.
- Split: 375 training rows, 125 test rows (`stratify=y`).

## Definitions
- **`RandomForestClassifier`:** sklearn's forest model. `.fit()` trains all the trees, `.predict()` takes the majority vote.
- **`n_estimators`:** the number of trees in the forest.
- **`feature_importances_`:** each feature's average impurity reduction across all trees, scaled to sum to 1.
- **OOB (out-of-bag) score:** accuracy where each training row is predicted using only the trees that never trained on it.
- **`oob_score=True`:** asks the forest to compute the OOB score while fitting.
- **Permutation importance:** shuffle one column of the test data and measure how much the score drops. A big drop means the model relied on that feature.

## Important Concepts
- **Fit and predict**
  - `RandomForestClassifier(n_estimators=100, random_state=42)`, then `.fit(X_train, y_train)` and `.predict(X_test)`.
  - Train accuracy was 1.0 and test accuracy 0.76. Even a forest fits its training rows perfectly here, so the real gain shows on unseen data.
- **Feature importances**
  - `shots_on_target` was clearly first (0.442). Then `possession_pct` 0.154, `opponent_rank` 0.139, `pass_accuracy_pct` 0.128, `kickoff_hour` 0.105 and `home_game` 0.032.
  - Refitting with seeds 0, 1 and 2 gave the same top feature every time (0.435 to 0.448), so averaging many trees makes the ranking fairly stable.
  - Plot it as a horizontal bar chart, sorted by importance.
- **OOB score**
  - OOB score `0.781` vs test accuracy `0.760` for 100 trees. They are close, without needing a separate validation split.
  - Across tree counts, OOB rose from 0.723 (10 trees) to about 0.78 (50 to 200 trees) and then flattened.
  - It is an estimate from a training set of only 375 rows, so small differences between the two numbers are noise.
- **Single tree vs forest (same data, same split)**
  - Test accuracy: tree `0.672`, forest `0.760`.
  - 5-fold CV mean on the training set: tree `0.731`, forest `0.792`.
  - Both models score 1.0 on training data. The forest generalises better.
- **The catch with impurity importance**
  - The useless `kickoff_hour` scored 0.105, higher than `home_game` (0.032), which does affect results in the hidden formula.
  - Impurity importance is computed on training data and tends to favour features with many distinct values (`kickoff_hour` has 10, `home_game` has 2).
  - Permutation importance on the test set: `shots_on_target` 0.252, `opponent_rank` 0.022, `pass_accuracy_pct` 0.007, `home_game` 0.006, `possession_pct` -0.008, `kickoff_hour` -0.015.
  - Negative values mean shuffling the column did not hurt at all (noise). That correctly flags `kickoff_hour` as useless.
  - Caveat: the test set is only 125 rows, so the small permutation values (including the negative `possession_pct`, which has a small real effect in the hidden formula) are noisy. Only `shots_on_target` is a clear signal.

## Step-by-Step Explanation
- **Step 1:** Split into train and test.
- **Step 2:** `rf = RandomForestClassifier(n_estimators=100, random_state=42)`, then `.fit()` and `.predict()`.
- **Step 3:** Check the confusion matrix and classification report.
- **Step 4:** Put `rf.feature_importances_` in a Series, sort it and plot a horizontal bar chart.
- **Step 5:** Refit with `oob_score=True` and compare `oob_score_` with the test score.
- **Step 6:** Fit a single `DecisionTreeClassifier` on the same split and compare test accuracy, CV accuracy and importances.
- **Step 7:** Cross-check importances with `permutation_importance` on the test set.

## Examples
- **Confusion matrix (test set):** `[[52, 10], [20, 43]]`. That is 52 losses called correctly, 43 wins caught, 10 false alarms and 20 missed wins.
- **Classification report:** Loss precision 0.72 and recall 0.84, Win precision 0.81 and recall 0.68, overall accuracy 0.76.
- **OOB vs test:**

  | Trees | OOB score | Test accuracy |
  |-------|-----------|---------------|
  | 10 | 0.723 | 0.744 |
  | 50 | 0.781 | 0.768 |
  | 100 | 0.781 | 0.760 |
  | 500 | 0.773 | 0.768 |

- **Tree vs forest:**

  | Model | Train acc | Test acc | CV mean |
  |-------|-----------|----------|---------|
  | Decision tree | 1.000 | 0.672 | 0.731 |
  | Random forest | 1.000 | 0.760 | 0.792 |

- **Practice (300 trees):** OOB `0.768`, test `0.760`, top feature `shots_on_target`, same as with 100 trees.
- **Mini challenge (`max_depth` by 5-fold CV):** depth 3 gave 0.787, depth 5 gave 0.773, depth 8 gave 0.771 and no limit gave 0.792. The best was no limit, though depth 3 is within noise of it. Test accuracy was 0.76. Top permutation features: `shots_on_target`, `opponent_rank`, `pass_accuracy_pct`.

## Common Mistakes
- Trusting `feature_importances_` as the final word on which features matter.
- Comparing importances between features with very different numbers of distinct values without a cross-check.
- Using the OOB score with too few trees (sklearn warns that some rows get no OOB estimate).
- Expecting training accuracy to fall for a forest. It can stay at 1.0.
- Reading small differences (0.76 vs 0.768, or depth 3 vs no limit) as real improvements on a small test set.
- Forgetting `random_state`, so results change every run.
- Reading a negative permutation importance as "harmful". It just means noise.

## Interview Questions
- What are the key parameters of `RandomForestClassifier`? What does `n_estimators` do?
- How is `feature_importances_` calculated?
- What is the OOB score and why is it useful?
- Why does a random forest usually beat a single decision tree?
- What is a weakness of impurity-based feature importance?
- What is permutation importance and how does it differ?
- Does adding more trees cause overfitting? Why or why not?
- How would you choose `n_estimators` and `max_depth`?

## Key Takeaways
- `RandomForestClassifier` fits and predicts like any other sklearn model.
- The forest beat the single tree on both the test split (0.760 vs 0.672) and CV (0.792 vs 0.731).
- OOB score is a free validation estimate that landed close to the test score.
- Impurity importance gave a useless feature 0.105, more than a genuinely relevant one. Cross-check with permutation importance.
- More trees make the result steadier, and the curve flattens after a while.

## Summary
- Built and evaluated a 100-tree random forest on 375 training and 125 test matches.
- Test accuracy 0.760, OOB score 0.781, and the top feature was `shots_on_target` across every seed.
- Single tree vs forest: 0.672 vs 0.760 on the test set, and 0.731 vs 0.792 on 5-fold CV.
- Permutation importance exposed the weakness of impurity importance by putting the deliberately useless `kickoff_hour` at about zero.
- **Next: Day 62.** Cross-Validation: K-Fold deep dive.
