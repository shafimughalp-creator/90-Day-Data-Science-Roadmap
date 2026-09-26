[day_57_knn_sklearn_cross_validation_notes.md](https://github.com/user-attachments/files/32679839/day_57_knn_sklearn_cross_validation_notes.md)
# Day 57: KNN — sklearn + Cross-Validation for K Selection

## Quick Overview
- **Topic:** Building KNN in sklearn and choosing K with cross-validation instead of guessing.
- **What I learned:** `cross_val_score` gives a steadier score than one split, and scaling must happen *inside* each fold (with a pipeline) to avoid leakage.
- **Tools used:** Python, NumPy, pandas, Matplotlib, scikit-learn (`KNeighborsClassifier`, `StandardScaler`, `make_pipeline`, `cross_val_score`, `classification_report`, `load_wine`).

## Introduction
- Day 56 was the intuition: distance, K, and why scaling matters.
- Day 57 is the professional workflow: baseline, cross-validation over K, final model, test once.
- Main dataset: 300 synthetic FC Lahore Lions players (`seed = 42`) with `sprint_speed_kmh`, `aerial_duels_won`, `crosses_per_90`, `minutes_played` and `is_winger`. Minutes has no link to the role (it is there as a noisy, large-scale column).
- Practice dataset: sklearn's **Wine** dataset (3 classes, 13 features).
- Split: 225 training rows, 75 test rows (`stratify=y`).

## Definitions
- **Baseline model:** a simple first model used as a reference point.
- **Cross-validation (CV):** splitting the training data into folds, rotating which fold is held out for scoring, and averaging.
- **Fold:** one part of the split. 5-fold CV means 5 parts.
- **`cross_val_score(model, X, y, cv=5)`:** returns one score per fold.
- **Hyperparameter:** a setting chosen before training (K is one). It is not learned from the data.
- **Pipeline (`make_pipeline`):** chains steps such as scaler then model, so they run together.
- **Data leakage:** information from outside the training part (test data or a held-out fold) influencing the model.
- **Elbow:** the point where a metric stops improving meaningfully as a setting increases.
- **Classification report:** per-class precision, recall, F1 and support.

## Important Concepts
- **Why not pick K on the test set?**
  - Each look at the test set makes it less of a fair, unseen exam.
  - Use CV on the training set to choose K, then touch the test set once.
- **How 5-fold CV works**
  - Train on 4 folds, score on the 5th. Rotate 5 times. Average the 5 scores.
  - The fold scores varied a lot (0.756 to 0.889 for K = 5), so one split alone is not reliable.
- **Scaling inside CV**
  - Scaling the whole training set before CV lets each fold's scaler see the held-out fold.
  - `make_pipeline(StandardScaler(), KNeighborsClassifier(...))` re-fits the scaler on the training folds only.
  - In this data the numbers barely changed (mean 0.813 leaky vs 0.818 pipeline), but the habit is what matters, and the effect can be bigger on other data.
- **Searching K from 1 to 20**
  - Mean CV accuracy went from about 0.82 to 0.85 for small K to about 0.86 to 0.88 for larger K.
  - The highest mean was 0.880 at K = 20, the edge of the search range. The standard deviations (0.02 to 0.07) overlap, so many K values are statistically similar.
- **Elbow rule used**
  - Find the smallest K whose mean is within 1 standard deviation of the best mean.
  - Cutoff = 0.880 - 0.027 = 0.853, so the elbow was K = 8 (mean 0.862).
  - Simpler K, similar accuracy.
- **Final step**
  - Retrain on the full training set with the chosen K, then score the test set once.
- **Classification report**
  - Shows precision, recall and F1 for each class, not only overall accuracy (Day 55 metrics).

## Step-by-Step Explanation
- **Step 1:** Split into train and test (`train_test_split`, `stratify=y`, `random_state=42`).
- **Step 2:** Baseline: `StandardScaler` fit on train only, `KNeighborsClassifier(n_neighbors=5).fit().predict()`.
- **Step 3:** Build a pipeline `make_pipeline(StandardScaler(), KNeighborsClassifier(k))`.
- **Step 4:** Loop K = 1 to 20 with `cross_val_score(pipe, X_train, y_train, cv=5)`, saving the mean and std.
- **Step 5:** Plot K against mean CV accuracy and choose the elbow.
- **Step 6:** Retrain on all training data with that K and check the test set once.
- **Step 7:** Print `classification_report` on the test predictions.

## Examples
- **Baseline (K = 5, one split):** test accuracy `0.893`.
- **5-fold CV at K = 5:** fold scores `[0.889, 0.756, 0.867, 0.756, 0.822]`, mean `0.818`, std `0.055`.
- **K search:** best mean `0.880` at K = 20, elbow at K = 8 with mean `0.862`.
- **Final model (K = 8):** test accuracy `0.907`. The gap from the baseline is about one player out of 75, so it is not strong evidence that K = 8 is better.
- **Classification report:** precision, recall and F1 were about 0.90 for both classes (support 39 and 36).
- **Wine practice:** best mean CV accuracy `0.977` at K = 15, elbow K = 3, test accuracy `0.956` on 45 wines.
- **Wine mini challenge (K = 5, 5-fold CV):** unscaled `0.677` vs scaled `0.955`. `proline` has values above 1500 while many other features are below 10.

## Common Mistakes
- Choosing K by watching the test score.
- Fitting the scaler on all the data before CV (or on the test set).
- Treating one CV mean as exact. Look at the standard deviation too.
- Searching K only up to a small range and not noticing the best K sits at the edge.
- Forgetting to retrain on the full training set after choosing K.
- Reporting only accuracy instead of a classification report.
- Reading a difference of one or two predictions on a small test set as a real improvement.

## Interview Questions
- What is cross-validation and why use it?
- How does `cross_val_score` work with `cv=5`?
- How do you choose K for KNN?
- Why is scaling inside a pipeline better than scaling before CV?
- What is data leakage? Give an example.
- What is a hyperparameter? How is it different from a learned parameter?
- What does the elbow in a K vs accuracy plot mean?
- Why should the test set be used only once?

## Key Takeaways
- Choose K with cross-validation on the training data, not with the test set.
- Use a pipeline so the scaler is fitted only on training folds.
- Look at both the mean and the spread of CV scores.
- The elbow gives a simpler K with similar accuracy.
- The same pattern (CV over a hyperparameter, then one final test) works for every algorithm.

## Summary
- Baseline: scaled KNN with K = 5 scored 0.893 on the test set.
- 5-fold CV over K = 1 to 20 gave an elbow at K = 8 (mean CV accuracy 0.862).
- The final KNN with K = 8 scored 0.907 on the test set, with precision and recall near 0.90 for both classes.
- On Wine, scaling raised 5-fold CV accuracy from 0.677 to 0.955.
- **Next: Day 58.** Decision Tree: entropy and information gain (theory).
