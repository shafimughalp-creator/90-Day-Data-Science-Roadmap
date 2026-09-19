[Uploading notes.md…]()
# Day 52: Linear Regression — sklearn Implementation

## Quick Overview
- **Topic:** fitting and evaluating a linear regression model with `sklearn`
- **What I learned:** `fit()` / `predict()`, reading `coef_` and `intercept_`, scoring with RMSE / MAE / R², and checking a residual plot
- **Tools:** Python, pandas, NumPy, matplotlib, scikit-learn (`LinearRegression`, `train_test_split`, `metrics`)
- **Data:** 500 synthetic FC Lahore Lions player-seasons (`lions_player_seasons.csv`, seed 42)

## Introduction
- On Day 51 I built linear regression by hand: weights, MSE cost, gradient descent.
- Today the same idea runs in a few lines of sklearn code.
- The coding is the easy part. The real skill is **interpreting** what the model gives back.
- Goal: predict `goals` from `shots_on_target`, `key_passes` and `matches_played`.

## Definitions
- **Linear regression:** a model that predicts a number as a weighted sum of features plus a constant.
- **Feature (X):** an input column used to make a prediction.
- **Target (y):** the column we want to predict (here, `goals`).
- **Coefficient (`coef_`):** one weight per feature. It is the change in the prediction when that feature rises by 1, with the other features held fixed.
- **Intercept (`intercept_`):** the prediction when every feature equals 0 (the bias `b`).
- **Residual:** `actual - predicted`. How far off one prediction was.
- **MAE (Mean Absolute Error):** the average size of the residuals, ignoring direction.
- **RMSE (Root Mean Squared Error):** square root of the average squared residual. Same unit as the target.
- **R² (R-squared):** the share of the variation in the target that the model explains.

## Important Concepts
- **sklearn's pattern is always the same:** create the model, `fit()` on training data, `predict()` on new data.
- **Trailing underscore:** attributes that exist only after fitting end with `_` (`coef_`, `intercept_`).
- **Ordinary least squares:** `LinearRegression` minimizes MSE with a direct linear-algebra solution. It reaches the same answer gradient descent was walking toward on Day 51.
- **Evaluate on the test set:** scores on data the model has never seen show how it will behave in real use.
- **Train vs test score:** a big gap (high train, low test) is the overfitting warning from Day 50.
- **Coefficients and scale:** raw weights are not directly comparable when features use different scales. Multiplying each weight by its feature's standard deviation gives a fairer "typical impact".
- **RMSE vs MAE:** RMSE punishes big misses harder, so it is always greater than or equal to MAE.
- **R² meaning:** 1.0 is perfect, 0 is no better than always predicting the average. On a test set it can even go negative if the model is worse than the average.
- **Residual plot:** residuals against predictions. Random scatter around 0 is healthy. A curve, funnel or drift means the model is missing something.

## Step-by-Step Explanation
- **Step 1: Prepare the data**
  - Select the feature columns as `X` and the target column as `y`.
- **Step 2: Split**
  - `train_test_split(X, y, test_size=0.2, random_state=42)` keeps 20% of players hidden for testing.
- **Step 3: Fit**
  - `model = LinearRegression()` then `model.fit(X_train, y_train)`.
  - The model learns the weights from the training rows only.
- **Step 4: Predict**
  - `y_pred = model.predict(X_test)` returns one predicted value per test row.
- **Step 5: Read the weights**
  - `model.coef_` (one per feature, in column order) and `model.intercept_`.
- **Step 6: Score the model**
  - `np.sqrt(mean_squared_error(y_test, y_pred))` for RMSE.
  - `mean_absolute_error(y_test, y_pred)` for MAE.
  - `r2_score(y_test, y_pred)` for R².
- **Step 7: Check residuals**
  - `residuals = y_test - y_pred`, scatter them against `y_pred`, add a line at 0.

## Examples
- **Fit and predict**

```python
model = LinearRegression()
model.fit(X_train, y_train)
y_pred = model.predict(X_test)
```

- **Results from this notebook (seed 42, 500 rows, 100 test rows)**
  - `shots_on_target`: 0.312
  - `key_passes`: 0.071
  - `matches_played`: 0.142
  - intercept: 0.972
  - The data was generated with true weights 0.30, 0.08, 0.15 and intercept 1.0, so the model recovered them closely. The small differences come from the random noise.
- **Reading a coefficient**
  - `0.312` for `shots_on_target` means about 0.31 extra goals per extra shot on target, holding the other features fixed.
- **Metrics on the test set**
  - RMSE: 2.81 goals
  - MAE: 2.34 goals
  - R²: 0.857 (train R²: 0.834)
  - Meaning: predictions miss by about 2 to 3 goals on average, and the model explains about 86% of the variation in goals.
- **Fair feature comparison (weight x standard deviation)**
  - `shots_on_target`: about 6.4 goals
  - `key_passes`: about 1.2 goals
  - `matches_played`: about 1.2 goals
  - Shots on target drive most of the predictions.
- **Mini challenge result**
  - Shots only: R² 0.818, RMSE 3.18
  - All 3 features: R² 0.857, RMSE 2.81
  - The extra features help, but only a little.
- **Residual plot result**
  - Mean residual: -0.18, close to 0.
  - Points form a shapeless cloud around the zero line, with one big miss of about -10 goals. No curve, no funnel.

## Common Mistakes
- Calling `predict()` before `fit()` (sklearn raises a `NotFittedError`).
- Scoring the model on the training data only and trusting that number.
- Mixing up argument order in metrics. It is `metric(y_true, y_pred)`: actual first, predicted second.
- Forgetting `np.sqrt(...)` and reporting MSE as if it were RMSE.
- Comparing raw coefficients across features with different scales and calling the biggest one "most important".
- Reading a coefficient as cause and effect. It only describes the pattern in this data.
- Judging a residual plot from very few points. A tiny test set can look lopsided by pure chance.
- Ignoring the residual plot and looking only at R².

## Interview Questions
- **What do `fit()` and `predict()` do?**
  - `fit()` learns the parameters from training data. `predict()` applies them to new rows.
- **What does a coefficient mean in linear regression?**
  - The expected change in the target for a 1-unit increase in that feature, holding the others fixed.
- **What does `intercept_` represent?**
  - The predicted value when all features are 0.
- **What is the difference between RMSE and MAE?**
  - Both are errors in the target's unit. RMSE squares errors first, so large misses count more.
- **What does R² = 0.86 mean?**
  - The model explains about 86% of the variation in the target.
- **Can R² be negative?**
  - Yes, on test data, when the model predicts worse than simply using the average.
- **What is a residual, and what should a good residual plot look like?**
  - Residual = actual minus predicted. A good plot is random scatter around 0 with no pattern.
- **What does a curved pattern in the residual plot suggest?**
  - The relationship is not linear, so the model needs new features or a different model.
- **Does sklearn's `LinearRegression` use gradient descent?**
  - No. It solves least squares directly. Gradient descent is used by other models and by `SGDRegressor`.
- **Why evaluate on a test set instead of the training set?**
  - The training score is optimistic. The test score shows performance on unseen data.
- **Can you compare raw coefficients to rank feature importance?**
  - Only if the features are on the same scale, for example after standardizing.

## Key Takeaways
- Three lines do the work: create, `fit`, `predict`.
- `coef_` and `intercept_` tell the story of what the model learned.
- Report more than one metric: RMSE and MAE for error size, R² for variation explained.
- Always check the residual plot. A good score can still hide a pattern.
- Evaluate on the test set and compare with the train score.
- More features are not automatically a big win. Check by comparing scores.

## Summary
- `LinearRegression` in sklearn fits a weighted-sum model by least squares.
- After `fit()`, `coef_` and `intercept_` hold the learned weights.
- Test-set RMSE 2.81, MAE 2.34 and R² 0.857 show a good fit on this synthetic data.
- Residuals are centered near 0 with no visible pattern, which supports using a linear model here.
- Next: Day 53 covers Ridge and Lasso, regularization for correlated or too many features.
