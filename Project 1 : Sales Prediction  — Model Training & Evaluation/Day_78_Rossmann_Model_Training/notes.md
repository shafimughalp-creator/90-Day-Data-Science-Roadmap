# Day 78: Project 1 — Model Training & Evaluation

## Quick Overview
- **Topic:** Training and evaluating the Rossmann sales models: a Linear Regression baseline vs XGBoost, with proper cross-validation
- **What I learned:** The model name matters less than the baseline you compare against and how you test. A plain average with no machine learning was surprisingly hard to beat
- **Tools:** Python, pandas, NumPy, scikit-learn (`Pipeline`, `ColumnTransformer`, `LinearRegression`, `cross_validate`), XGBoost, matplotlib, Jupyter Notebook
- **Data note:** the real Rossmann data again. The raw files are not in this repo because of competition data rules, see `data/README.md`
- **Code:** `features.py` (Day 77 features) and `modeling.py` (the pipeline, the store-history transformer, the baseline, the metrics)

## Introduction
- Days 76 and 77 were about the problem and the features. Today I finally trained models
- Plan: a simple baseline first, then XGBoost, then test both fairly, then study the mistakes
- Think of a race: you need a slow runner to compare against, and a fair track

## Definitions
- **Baseline model:** a simple model that sets the bar to beat
- **Pipeline:** one object that holds all steps (features, scaling, encoding, model)
- **RMSE:** typical error size, in sales units. Big stores dominate it
- **MAE:** average absolute error, in sales units
- **R2:** share of the variation the model explains (1 is perfect)
- **RMSPE:** root mean squared percentage error, the project metric (relative error)
- **Cross-validation (CV):** testing on several different slices of data
- **Backtest (rolling origin):** CV for time data, where each fold trains on the past and tests on the next period
- **Residual:** actual minus predicted
- **Feature importance:** how much the model used each feature

## Important Concepts
- **How the models are built**
  - Each model is one pipeline: store history features, then impute and scale numbers, one-hot encode categories, then the model
  - Store history (each store's average sales) uses the target, so it is learned from the training part of each fold only
  - Same features for every model (Day 77), `Customers`, `lag_1`, and `lag_7` stay out
- **Cross-validation: 5 time-ordered windows of 42 days**
  - W1 2015-01-03 to 2015-02-13, W2 2015-02-14 to 2015-03-27, W3 2015-03-28 to 2015-05-08, W4 2015-05-09 to 2015-06-19, W5 2015-06-20 to 2015-07-31
  - Each window trains on everything before it, so it mimics a real 6-week forecast
  - W5 is the same validation period as Days 76 and 77
- **Last 42 days (W5)**
  - Linear baseline: RMSE 1,199, MAE 866, R2 0.846, RMSPE 0.184
  - XGBoost (200 trees): RMSE 1,054 (12.1% lower), R2 0.881, RMSPE 0.154
  - XGBoost with a log target: RMSE 1,167, R2 0.854, RMSPE 0.168
  - Day 76 plain average (store + weekday + promo): RMSE 1,109, R2 0.868, RMSPE 0.147
- **Mean and std across the 5 windows**
  - Plain average: RMSE 1,127 +/- 220, RMSPE 0.170 +/- 0.020
  - Linear Regression: RMSE 1,200 +/- 161, RMSPE 0.193 +/- 0.019
  - XGBoost (200 trees): RMSE 1,043 +/- 149, RMSPE 0.161 +/- 0.017
  - XGBoost (log target): RMSE 1,053 +/- 152, RMSPE 0.158 +/- 0.016
- **RMSPE per window (plain average, Linear, XGBoost, XGBoost log)**
  - W1: 0.184, 0.218, 0.176, 0.160
  - W2: 0.194, 0.210, 0.177, 0.176
  - W3: 0.171, 0.174, 0.161, 0.152
  - W4: 0.153, 0.181, 0.136, 0.133
  - W5: 0.147, 0.184, 0.154, 0.168
- **What this says**
  - XGBoost beat Linear Regression in all 5 windows, but the gain is moderate, not dramatic (RMSE about 13% lower)
  - The plain average beat Linear Regression in all 5 windows
  - XGBoost beat the plain average in W1 to W4 and lost in W5, and its average edge (0.158 to 0.161 vs 0.170) is smaller than the window-to-window std (about 0.02)
  - The two XGBoost versions are basically tied
- **Shuffled 5-fold vs time-ordered windows (same XGBoost)**
  - Shuffled: RMSE 775, RMSPE 0.179
  - Time-ordered: RMSE 1,043, RMSPE 0.161
  - The shuffled version looks better on RMSE but worse on RMSPE, and the two cover different dates, so this is not a clean comparison. The real point: shuffled folds test days that sit between training days, which is not how a forecast works
- **Residuals (log-target XGBoost, last 42 days)**
  - Mean residual -99.3 (over-predicts a little on average), median -28.4
  - 57.3% of rows are within 10% of the actual, 85.2% within 20%
  - The worst 1% of rows have errors above 60%
  - The scatter plot hugs the diagonal, but predictions fall below it for the biggest sales days (above about 15,000), so peaks are under-predicted
- **Patterns in the errors (last 42 days, RMSPE)**
  - By weekday: Mon 0.125, Tue 0.129, Wed 0.151, Thu 0.232, Fri 0.140, Sat 0.204, Sun 0.138
  - By promo: no promo 0.157, promo 0.182
  - By store type: a 0.165, b 0.114, c 0.166, d 0.176
  - By store size: small 0.177, mid-small 0.177, mid-large 0.157, large 0.160
  - The Thursday and Saturday numbers come from a few dates: 2015-07-02 (Thu) RMSPE 0.492 with an average error of 44%, 2015-07-04 (Sat) 0.401 (36%), 2015-07-01 (Wed) 0.267 (21%). A typical day is 0.123
  - I do not know what happened on those days, the data has no weather or event columns
- **Feature importance (log-target XGBoost)**
  - store_dow_mean 0.597, Promo 0.211, is_month_end 0.031, DayOfWeek 0.025, day 0.018, week_of_year 0.018, store_mean 0.012, lag_42 0.011
  - The model leans mostly on "this store on this weekday", which is the same idea as the plain-average baseline, so it is no surprise that the gain over it is small

## Step-by-Step Explanation
- **Step 1:** Load the data and build features with the Day 77 functions
- **Step 2:** Define the metrics (RMSE, MAE, R2, RMSPE)
- **Step 3:** Build one pipeline per model, with the same preprocessing
- **Step 4:** Create the 5 time-ordered train/test windows
- **Step 5:** Fit and score each model on each window, collect mean and std
- **Step 6:** Compare with the plain-average baseline in every window
- **Step 7:** Plot actual vs predicted and the residuals
- **Step 8:** Break the errors down by weekday, promo, store type, store size, and date

## Examples
- **Practice (feature importance):** top 10 listed above, store_dow_mean dominates
- **Mini challenge (max_depth, last window only, log-target XGBoost):** depth 4 gave RMSPE 0.146, depth 6 gave 0.168, depth 8 gave 0.167
  - I chose between these on the test window, so treat it as a hint, not a final result
  - A possible reason (not tested): store history features include each row's own sales in the training data, and deeper trees may exploit that

## Common Mistakes
- Using shuffled CV on time-ordered data
- Judging a model without a simple baseline next to it
- Looking only at RMSE (big stores dominate it) when the project metric is a percentage error
- Reading a small average gain as a clear win when the windows vary more than the gain
- Trusting day-of-week "patterns" without checking whether a few bad dates cause them
- Choosing settings on the test window and then reporting that score as final

## Interview Questions
- Why use a time-ordered backtest instead of shuffled k-fold for forecasting?
- Why compare against a plain average before using XGBoost?
- What is the difference between RMSE and RMSPE, and when does each matter?
- How would you check whether the error is spread evenly or concentrated?
- Why must target-based features (like store average) be learned inside each CV fold?
- How do you tell if a model's improvement is real or just noise?

## Key Takeaways
- Set up a simple baseline first, and keep it in every comparison
- Test the way you will use the model (train on the past, predict the future)
- Report mean and std, and look at every fold
- Break the errors down to find where the model is weak
- A modest, honest improvement is a result worth reporting

## Limits (honest notes)
- All models use mostly default settings, no tuning
- Store history features include each training row's own sales (a mild in-sample leak), which a cleaner out-of-fold version could fix
- Only 5 windows, all in 2015
- The plots and error tables use the log-target XGBoost, chosen because its average RMSPE across windows was a hair lower (0.158 vs 0.161), a tie in practice
- The cause of the July 1 to 4 errors is unknown

## Summary
- XGBoost was moderately better than Linear Regression in every window (RMSE 1,043 vs 1,200 on average)
- A plain store + weekday + promo average beat Linear Regression and was close to XGBoost
- XGBoost edged the average in 4 of 5 windows, but not by more than the window-to-window noise
- Errors are concentrated on a few dates and on very large sales days
- Next: Day 79, project visuals, README, and GitHub
