[Uploading notes.md…]()
# Day 82: Project 2 — Model Comparison + Best Model

## Quick Overview
- **Topic:** Comparing Logistic Regression, Random Forest, and XGBoost for churn, tuning the best one, and checking it on the hold-out test set
- **What I learned:** Three models can score almost the same, so how you choose and how you test matters more than which model wins
- **Tools:** Python, pandas, scikit-learn (`Pipeline`, `cross_validate`, `GridSearchCV`, `roc_curve`), XGBoost, matplotlib, Jupyter Notebook
- **Data note:** the Telco Customer Churn sample dataset (7,043 customers). The raw file is not in this folder, see `data/README.md`
- **Code:** `churn_pipeline.py` (cleaning, from Day 81) and `churn_models.py` (one preprocessing pipeline for any model)
- **Run with:** scikit-learn 1.9, XGBoost 3.4, pandas 3.0

## Introduction
- Day 81 built the preprocessing. Today three different models got the same inputs, so the only difference is the model
- Think of three runners on the same track: the track, the start, and the stopwatch must be identical
- I wrote three rules **before** running anything, to keep the test set honest

## Definitions
- **ROC curve:** true positive rate against false positive rate as the decision threshold moves
- **ROC-AUC:** the area under that curve (0.5 = random guessing, 1.0 = perfect ranking)
- **PR-AUC (average precision):** the area under the precision-recall curve, more focused on the rare class
- **Out-of-fold predictions:** each customer is predicted by a model that never saw them
- **GridSearchCV:** tries every combination of settings with cross-validation
- **Bootstrap interval:** resample the test set many times to see how much a score can wobble
- **Overfitting gap:** training score minus cross-validated score
- **Hold-out test set:** customers kept aside and used once at the end

## The three rules (set before running)
- **Rule 1:** the best model is chosen by cross-validation on the training data only (highest mean ROC-AUC)
- **Rule 2:** `GridSearchCV` also uses the training data only
- **Rule 3:** the test set (1,409 customers) is looked at once, at the end, and nothing is changed afterwards

## Important Concepts
- **Setup:** 5,634 training and 1,409 test customers (same split as Day 81). Stayed : churned = 2.77 : 1
  - Logistic Regression and Random Forest use `class_weight="balanced"`
  - XGBoost has no such option, so `scale_pos_weight = 2.77` does the same job
  - All settings are untuned starting values
- **Cross-validated results (5 folds x 3 repeats = 15 scores, same folds for every model)**
  - Logistic Regression: ROC-AUC 0.846 +/- 0.012, PR-AUC 0.660 +/- 0.017
  - Random Forest: ROC-AUC 0.828 +/- 0.013, PR-AUC 0.620 +/- 0.030
  - XGBoost: ROC-AUC 0.847 +/- 0.013, PR-AUC 0.665 +/- 0.021
- **Is the ranking real? (paired, fold by fold)**
  - XGBoost beat Logistic Regression by 0.0015 on average (std of the differences 0.0035), and was better in 11 of 15 folds
  - That is a **tie** for practical purposes. By rule 1 the code picked XGBoost, but Logistic Regression is simpler and nearly as good
  - Random Forest is clearly behind the other two
- **ROC curves (pooled out-of-fold predictions on the training data)**
  - Logistic Regression 0.845, Random Forest 0.828, XGBoost 0.847
  - The curves for Logistic Regression and XGBoost almost overlap
  - The Day 80 rule "month-to-month means churn" is a single point: recall 0.887 at a false positive rate of 0.429. It sits just under the two best curves, so at that operating point a one-line rule is almost as good as the models
- **Overfitting (train vs 5-fold CV ROC-AUC)**
  - Logistic Regression: 0.849 vs 0.846 (gap 0.004)
  - XGBoost: 0.879 vs 0.847 (gap 0.031)
  - Random Forest: 1.000 vs 0.828 (gap 0.172), it memorizes the training data
- **Tuning XGBoost with GridSearchCV (27 settings x 5 folds, training data only)**
  - Best: learning_rate 0.1, max_depth 2, n_estimators 100
  - CV ROC-AUC 0.847 with the starting settings, 0.849 with the best (the best-of-27 score is a bit optimistic)
  - The top 10 settings span only 0.0023 in CV ROC-AUC, while the fold-to-fold std of a single score is about 0.013, so the settings are practically interchangeable
- **The one look at the test set**
  - XGBoost, starting settings: ROC-AUC 0.843
  - XGBoost, tuned: ROC-AUC 0.846, PR-AUC 0.660
  - Bootstrap 95% interval for the tuned ROC-AUC: 0.823 to 0.867
  - For context (not used to choose anything): Logistic Regression untuned 0.842, Random Forest untuned 0.827
  - The test score (0.846) agrees with the cross-validated score (0.849), which is reassuring
  - The tuned vs untuned and XGBoost vs Logistic Regression differences are all far inside the interval, so the test set cannot separate them
- **Class weights and ranking (Mini challenge):** Logistic Regression without class weights has ROC-AUC 0.8461 and with `balanced` 0.8459 (paired difference -0.00016). Weights change the recall/precision balance, not the ranking, as Day 81 suggested

## Step-by-Step Explanation
- **Step 1:** Write the rules for choosing and testing before running anything
- **Step 2:** Build one preprocessing pipeline and put each model at the end
- **Step 3:** Compare with repeated stratified cross-validation (same folds for all)
- **Step 4:** Check whether the winner's lead is real with paired fold differences
- **Step 5:** Plot ROC curves from out-of-fold predictions, with the simple rule as a reference point
- **Step 6:** Tune only the best model with `GridSearchCV` on the training data
- **Step 7:** Freeze the model and look at the test set once
- **Step 8:** Add a bootstrap interval, so the score is not read as exact

## Examples
- **Practice (overfitting):** Random Forest has the biggest gap (0.172), Logistic Regression the smallest (0.004)
- **Mini challenge (class weights):** no change in ROC-AUC for Logistic Regression

## Common Mistakes
- Choosing the best model by looking at the test set
- Tuning on the test set, or going back to tune again after seeing the test score
- Ranking models by the mean alone, without checking fold-by-fold differences
- Reporting the best grid-search CV score as if it were the final score
- Reading a test AUC as exact (it has a wide interval with 1,409 customers)
- Using a bar chart axis that does not start at 0 without saying so (mine starts at 0.75, and the grid-search chart is zoomed on purpose)

## Interview Questions
- Why use `class_weight="balanced"` or `scale_pos_weight`?
- What does ROC-AUC measure, and what does it not tell you?
- How do you decide between two models that score almost the same?
- Why is the best score from a grid search slightly optimistic?
- Why look at the test set only once?
- What does a bootstrap interval for a test score tell you?

## Key Takeaways
- Fix the selection rules before you run anything
- A tie is a tie: report it, and prefer the simpler model when scores match
- Random Forest overfit the most (gap 0.172)
- Tuning gave almost nothing here (CV 0.847 to 0.849, test 0.843 to 0.846)
- A one-line rule is a surprisingly strong reference point
- A test score needs an interval

## Limits (honest notes)
- All models use mostly default settings, and Random Forest was not tuned at all because it did not win
- One dataset, one split, one seed for the test set
- The grid-search chart zooms into a very narrow range on purpose, and its note shows the spread against the noise
- After a reset of my work environment, the notebook was rebuilt from scratch on newer library versions (scikit-learn 1.9). The conclusions did not change

## Summary
- Logistic Regression (0.846) and XGBoost (0.847) tied on cross-validated ROC-AUC, Random Forest was behind (0.828) and overfit
- XGBoost was picked by the pre-set rule and tuned: test ROC-AUC 0.846 (95% interval 0.823 to 0.867)
- Tuning changed very little, and a simple one-line rule sits close to the model curves
- Next: Day 83, confusion matrix, choosing a business threshold, and insights
