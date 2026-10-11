[Uploading notes.md…]()
# Day 68: XGBoost — Boosting Theory & Why It Wins Kaggle

## Quick Overview
- **Topic:** Boosting, gradient boosting, and the XGBoost library
- **What I learned:** Boosting builds trees one after another, each fixing the errors of the last, and XGBoost makes this fast, regularized, and tolerant of missing values
- **Tools:** Python, pandas, scikit-learn, XGBoost (`XGBClassifier`), matplotlib, Jupyter Notebook

## Introduction
- Tabular data (rows and columns) is where XGBoost shines
- It is a go-to model in industry and Kaggle competitions
- To understand it, we first need the idea of **boosting**
- Think of a student re-studying only the questions they got wrong, round after round

## Definitions
- **Ensemble:** a group of models working together
- **Bagging:** train many models **in parallel** on random samples, then vote (Random Forest)
- **Boosting:** train models **one after another**, each fixing the previous errors
- **Residual:** the error left over = actual value minus predicted value
- **Gradient boosting:** each new tree is fit to the residuals of the ensemble so far
- **Learning rate:** how much each new tree can change the prediction
- **Regularization:** a penalty that keeps the model from getting too complex (`reg_lambda`, `reg_alpha`)
- **Feature importance:** how much each column helped the model
- **XGBoost:** an optimized, regularized gradient boosting library

## Important Concepts
- **Bagging vs boosting**
  - Bagging: independent trees, vote at the end, reduces variance
  - Boosting: dependent trees, each learns from mistakes, reduces bias
- **Gradient boosting, step by step**
  - Start with a simple guess (like the average)
  - Calculate residuals (the leftover errors)
  - Fit a small tree to those residuals
  - Add its prediction, scaled by the learning rate
  - Repeat
  - In my manual demo, MSE dropped from 2.873 to 2.177 to 1.934 to 1.822 after 3 trees
- **Why XGBoost is popular**
  - Built-in regularization
  - Handles missing values natively
  - Much faster than the older sklearn GBM
- **Settings to tune first**
  - `learning_rate`: smaller is slower but safer
  - `max_depth`: deeper trees can overfit
  - `n_estimators`: number of trees

## Step-by-Step Explanation
- **Step 1:** Split the data into train and test
- **Step 2:** Create `XGBClassifier(n_estimators=100, learning_rate=0.1, max_depth=3)`
- **Step 3:** Call `.fit(X_train, y_train)` (NaN values can stay in)
- **Step 4:** Use `.predict()` for classes and `.predict_proba()` for probabilities
- **Step 5:** Check `.feature_importances_`
- **Step 6:** Compare with a Random Forest on the same split
- **Step 7:** Tune `learning_rate` and `max_depth`, checking test AUC each time

## Examples
- **Boosting by hand:** 3 small trees took the training MSE from 2.873 to 1.822
- **XGBoost:** accuracy 0.715, AUC 0.764
- **Feature importances:** `home_game` 0.366, `shots_on_target` 0.229, `possession_pct` 0.207, `pass_accuracy` 0.106, `fouls` 0.092
- **Random Forest vs XGBoost:** same accuracy (0.715), AUC 0.747 vs 0.764
- **Missing values:** Logistic Regression raised "Input X contains NaN", while XGBoost trained on the same 85 rows with gaps
- **Tuning:**
  - `learning_rate=0.5` gave AUC 0.699 (worse than 0.764 at 0.1)
  - `max_depth` 2 / 3 / 6 gave AUC 0.773 / 0.764 / 0.738

## Common Mistakes
- Setting `learning_rate` too high, so the model overshoots
- Using very deep trees, which overfit the training data
- Judging XGBoost vs Random Forest on one small test set (a 0.017 AUC gap can be noise)
- Assuming XGBoost always beats simpler models (it did not by much here)
- Reading feature importance as "cause and effect" (it only shows what the model used)

## Interview Questions
- What is the difference between bagging and boosting?
- What does gradient boosting fit at each step?
- Why is XGBoost usually faster and more accurate than plain gradient boosting?
- What does `learning_rate` control, and what happens if it is too high?
- How does XGBoost handle missing values?
- How would you check that XGBoost is really better than a Random Forest?

## Key Takeaways
- Boosting = sequential trees fixing earlier errors
- Gradient boosting fits residuals
- XGBoost adds regularization, speed, and native NaN handling
- Tune `learning_rate` and `max_depth` first
- Always compare against a simpler baseline on the same split

## Summary
- Boosting turns many weak trees into one strong model
- XGBoost is the practical, fast version used for tabular data
- On my football data, XGBoost edged Random Forest on AUC (0.764 vs 0.747), with equal accuracy
- A shallower tree (`max_depth=2`) scored best, a reminder to tune
- Today's practice used a made-up football dataset (800 matches, with some missing values) in a Jupyter notebook
