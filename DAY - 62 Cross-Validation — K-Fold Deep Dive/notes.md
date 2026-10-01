[day_62_cross_validation_kfold_deep_dive_notes.md](https://github.com/user-attachments/files/32892967/day_62_cross_validation_kfold_deep_dive_notes.md)
# Day 62: Cross-Validation — K-Fold Deep Dive

## Quick Overview
- **Topic:** Why one train/test split is unreliable, and how K-Fold and Stratified K-Fold cross-validation give a steadier estimate.
- **What I learned:** the same model can score anywhere in a wide range depending on the random split, and the mean ± std from K folds shows both the estimate and how stable it is.
- **Tools used:** Python, NumPy, pandas, Matplotlib, scikit-learn (`KFold`, `StratifiedKFold`, `RepeatedStratifiedKFold`, `cross_val_score`, `train_test_split`, `RandomForestClassifier`, `LogisticRegression`, `load_iris`).

## Introduction
- Day 57 used cross-validation to choose K for KNN. Day 62 goes deeper into how it works and where it can go wrong.
- Main dataset: 500 synthetic FC Lahore Lions matches (`seed = 42`), the same data as Days 59 to 61. Target: `won`.
- Imbalanced dataset: 200 synthetic matches with a `red_card` target. Only 28 matches (14%) have a red card. Features: `fouls_committed`, `yellow_cards`, `opponent_rank`, `derby_match`.
- Sorted-data example: sklearn's Iris dataset, whose rows are ordered by class.

## Definitions
- **Fold:** one of K equal-sized parts of the data.
- **K-Fold CV:** train on K-1 folds, test on the left-out fold, rotate K times, average the K scores.
- **`cross_val_score(model, X, y, cv=5, scoring="accuracy")`:** returns one score per fold.
- **Mean ± std:** the mean is the estimate, and the std shows how much the score moves from fold to fold.
- **Stratified K-Fold:** each fold keeps roughly the same class proportions as the full data.
- **`shuffle=True`:** mixes the rows before splitting into folds.
- **Repeated CV:** running K-Fold several times with different shuffles and pooling the scores.
- **Imbalanced data:** one class is much rarer than the other.

## Important Concepts
- **The problem with a single split**
  - Same random forest, same data, 100 different `random_state` values for `train_test_split`.
  - Test accuracy ranged from **0.680 to 0.856** (mean 0.765, std 0.038).
  - So a single reported accuracy could be a lucky or unlucky draw.
- **How K-Fold works**
  - 5 folds of 500 rows: every split had 400 training rows and 100 test rows.
  - Every row was a test row exactly once (checked in code).
  - A hand-coded loop gave exactly the same fold scores as `cross_val_score`.
- **Reading mean ± std**
  - 5-fold CV: `[0.85, 0.71, 0.80, 0.78, 0.76]`, mean **0.780**, std **0.046**.
  - The std tells you the score is not perfectly stable. The fold scores ranged from 0.71 to 0.85.
- **Choosing K (folds)**

  | K | Mean | Std |
  |---|------|-----|
  | 3 | 0.774 | 0.037 |
  | 5 | 0.780 | 0.046 |
  | 10 | 0.770 | 0.071 |

  - The means are similar. With K = 10, each test fold has only 50 rows, so individual fold scores spread out more.
  - More folds also means more fits (slower).
- **What `cv=5` really does**
  - For classifiers it uses stratified folds without shuffling.
  - Its fold scores (`[0.79, 0.77, 0.72, 0.79, 0.80]`, mean 0.774) differ from the shuffled `KFold` run, but the means are close.
- **The sorted-data trap**
  - Iris is sorted: 50 setosa, then 50 versicolor, then 50 virginica.
  - Plain `KFold(3)` without shuffling gave test folds of `[50 0 0]`, `[0 50 0]`, `[0 0 50]`. Each test fold was a class the model never trained on, so accuracy was `[0, 0, 0]`.
  - `shuffle=True` gave `[1.0, 0.92, 0.98]`, and the default stratified `cv=3` gave `[0.98, 0.96, 0.98]`.
- **Stratified K-Fold on imbalanced data**
  - Always predicting "no red card" already scores 0.86 accuracy, so accuracy is a poor guide here (Day 55). I used recall and F1.
  - Red cards per test fold (10 folds): plain KFold `[5, 3, 1, 7, 1, 3, 1, 2, 1, 4]`, stratified `[2, 2, 3, 3, 3, 3, 3, 3, 3, 3]`.
  - Recall per fold was more erratic with plain folds (std 0.381) than stratified (std 0.241). F1 mean ± std: plain 0.302 ± 0.195, stratified 0.361 ± 0.144.
  - I used `class_weight="balanced"` so the model actually tries to catch the rare class. It is a small preview, not today's topic.
  - **Honest note:** repeating 5-fold F1 with 30 different shuffles gave the same overall estimate for both (0.324) with almost the same spread (std 0.027 plain vs 0.025 stratified). On this small dataset, stratifying mainly makes each fold usable. It matters more as the rare class gets rarer.
- **Repeated CV**
  - `RepeatedStratifiedKFold(n_splits=5, n_repeats=10)` gave 50 scores: mean 0.771, std 0.027.
  - The 10 repeat means varied only by 0.007 (range 0.758 to 0.780).
  - The single 5-fold run (0.780) sat at the top of that range, so even one CV run depends on the shuffle.

## Step-by-Step Explanation
- **Step 1:** Choose K (5 or 10 is a common default) and create `KFold(n_splits=K, shuffle=True, random_state=42)`, or `StratifiedKFold` for a classifier with uneven classes.
- **Step 2:** For each fold, train the model on the other K-1 folds.
- **Step 3:** Score the model on the left-out fold.
- **Step 4:** Repeat until every fold has been the test fold once.
- **Step 5:** Report the mean ± std of the K scores.
- **Step 6:** For imbalanced data, score with recall or F1 instead of accuracy.
- **Step 7:** Keep a final test set for one last check after choosing settings with CV.

## Examples
- **Fold sizes:** 5 folds of 500 rows gave 400 train and 100 test rows in each split.
- **Single split vs CV:** single splits ranged from 0.680 to 0.856, while 5-fold CV gave 0.780 ± 0.046.
- **Iris trap:** `[0, 0, 0]` with unshuffled `KFold(3)` vs `[0.98, 0.96, 0.98]` with stratified folds.
- **Practice (stratified 5-fold F1 on red cards):** `[0.22, 0.45, 0.50, 0.35, 0.24]`, mean 0.353 ± 0.111, with 5 or 6 red-card matches in every test fold.
- **Mini challenge (repeated stratified CV):** 50 scores, mean 0.771, std 0.027. Repeat means varied by only 0.007.

## Common Mistakes
- Trusting one train/test split as "the" accuracy.
- Using `KFold` without `shuffle=True` on data that is sorted by class or by date.
- Ignoring the std and only reporting the mean.
- Using accuracy on imbalanced data. A model that always predicts the majority class scores 0.86 here.
- Assuming stratified folds always change the average. They mostly improve fold quality, and the effect here was small.
- Fitting a scaler on all the data before CV instead of inside a pipeline (Day 57).
- Using cross-validation results as the final test. Keep a separate test set for one last check.
- Reading small differences between K values (0.774 vs 0.780 vs 0.770) as meaningful.

## Interview Questions
- Why is a single train/test split unreliable?
- Explain K-Fold cross-validation step by step.
- What does the std of the CV scores tell you?
- How do you choose K? What changes between K = 5 and K = 10?
- What is Stratified K-Fold and when do you need it?
- What is the risk of running K-Fold without shuffling on sorted data?
- What does `cross_val_score` use by default for a classifier?
- What is repeated K-Fold and why use it?
- Why is accuracy a poor metric for imbalanced data?

## Key Takeaways
- One split is one draw. K-Fold averages K draws and shows their spread.
- Report mean ± std, not just the mean.
- Shuffle (or stratify) when rows are in a meaningful order.
- Stratified folds keep rare classes evenly spread, which makes each fold usable.
- Use recall or F1 instead of accuracy for imbalanced targets.
- CV is for choosing and evaluating. Keep a test set for a final check.

## Summary
- The same random forest scored between 0.680 and 0.856 depending on the split, so one split cannot be trusted alone.
- 5-fold CV gave 0.780 ± 0.046, and a hand-coded loop matched `cross_val_score` exactly.
- On sorted Iris data, unshuffled `KFold(3)` scored 0.0, and shuffling or stratifying fixed it.
- Stratified folds spread the 28 red-card matches evenly (2 to 3 per fold vs 1 to 7), though the overall F1 estimate barely changed on this small dataset.
- Repeated stratified CV gave 0.771, with the repeat means varying by just 0.007.
- **Next: Day 63.** Hyperparameter tuning with GridSearchCV.
