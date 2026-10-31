[Uploading notes.md…]()
# Day 77: Project 1 — Feature Engineering

## Quick Overview
- **Topic:** Building features for the Rossmann sales forecast: date features, lag features, one-hot encoding, and a correlation check
- **What I learned:** A feature is only useful if it will exist at forecast time, and a good-looking score can be fake
- **Tools:** Python, pandas, NumPy, scikit-learn (`OneHotEncoder`, `ColumnTransformer`, `HistGradientBoostingRegressor`), matplotlib, Jupyter Notebook
- **Data note:** the real Rossmann data again (`train.csv`, `store.csv`). The raw files are not in this repo because of competition data rules, see `data/README.md`
- **Code:** the feature steps are saved as functions in `features.py`, so Day 78 can reuse them

## Introduction
- Yesterday I defined the problem and explored the data
- Today I turned raw columns into features a model can learn from
- Think of cooking: raw ingredients are not a meal, preparation matters
- The big rule for this project: we forecast **6 weeks ahead**, so every feature must be knowable 6 weeks before

## Definitions
- **Feature engineering:** creating new input columns from existing data
- **Date feature:** a piece of the date, like month or day of week
- **Lag feature:** the value of a column some days ago (for example, sales 7 days ago)
- **Forecast horizon:** how far ahead we predict (42 days here)
- **One-hot encoding:** turning a category into 0/1 columns
- **Multicollinearity:** features that carry almost the same information
- **Correlation (r):** how strongly two columns move together (-1 to +1)
- **Target encoding / store history:** a feature built from past target values (like each store's average sales)
- **RMSPE:** root mean squared percentage error, the project metric

## Important Concepts
- **Date features:** `year`, `month`, `day`, `day_of_week` (0 = Monday), `week_of_year`, `is_weekend`, `is_month_end`
- **Lags must be matched by date, not by row**
  - 181 stores have missing dates, so shifting rows would pick the wrong day
  - The function looks up each store's sales on `Date - k days`
- **Lag correlations with Sales (open days)**
  - lag_1: 0.392, lag_7: 0.556, lag_42: 0.674, lag_49: 0.620
  - Some lag days were closed (zero sales): lag_1 19.1% of rows, lag_7 3.4%, lag_42 3.7%, lag_49 3.2%
  - Without those rows: lag_1 0.869, lag_7 0.627, lag_42 0.750, lag_49 0.680
- **The forecast-horizon trap**
  - Validation window: 42 days starting 2015-06-20
  - Share of validation rows where the lag is known at forecast time: lag_1 2.8%, lag_7 16.7%, lag_42 100%, lag_49 100%
  - So `lag_1` and `lag_7` (the lags in the roadmap) cannot be used for a 6-week forecast, only lags of 42 days or more can
- **Even-week lags are better (a test of my own guess)**
  - Promo status matches today's: 25.1% one week ago, 84.7% two weeks ago, 73.4% four weeks ago, 47.8% five weeks ago, 68.6% six weeks ago, 51.5% seven weeks ago
  - Correlation with Sales (open lag days): lag_7 0.627, lag_14 0.832, lag_28 0.794, lag_35 0.666, lag_42 0.750, lag_49 0.680, lag_56 0.717
  - Promotions seem to alternate by week for many stores, so lags of an even number of weeks share today's promo status
- **One-hot encoding in a pipeline**
  - `store_type` (a, b, c, d), `assortment` (a, b, c), `state_holiday` (0, a, b, c)
  - Encoder fitted on the past only, with `handle_unknown="ignore"`
  - Example: 4 columns became 12 columns
- **Correlation heatmap (|r| > 0.9)**
  - `DayOfWeek` vs `day_of_week`: r = 1.000, so one is an exact copy (dropped `day_of_week`)
  - `month` vs `week_of_year`: r = 0.961 (dropped `month`)
  - Rule: keep the feature more correlated with Sales
- **Does it help? (gradient boosting, RMSPE on the 42-day validation, lower is better)**
  - A) raw columns only: 0.364
  - B) + date features, store info, safe lags (42, 49): 0.174
  - C) B without the correlated pairs: 0.178
  - D) B + lag_1 and lag_7 from real validation sales: 0.131 (**fake**, those values would not exist at forecast time)
  - E) B + store history (store average and store-weekday average from the past): 0.148
  - Day 76 baseline (store + weekday + promo average): 0.147

## Step-by-Step Explanation
- **Step 1:** Write feature steps as functions, so train and test get the same treatment
- **Step 2:** Add date features from the `Date` column
- **Step 3:** Add lags by looking up `Date - k days` for the same store
- **Step 4:** Check which lags are known at forecast time (only 42 days or more)
- **Step 5:** Merge store details and one-hot encode categories, fitted on the past only
- **Step 6:** Use the heatmap to drop one feature from each pair with |r| > 0.9
- **Step 7:** Test feature sets with a quick model on a time-based validation window
- **Step 8:** Compare with the simple baseline from Day 76

## Examples
- **Practice (smoothed lag):** `lag_42` alone has correlation 0.674 with Sales, while the average of `lag_42`, `lag_49`, and `lag_56` has 0.769
- **Mini challenge (month end):** average sales are 8,069 on month-end days (28,039 rows) vs 6,918 on other days (816,299 rows), about 17% higher, not adjusted for weekday or promo
- **What the results mean:** features cut the error by more than half compared with raw columns (0.364 to 0.148), but a plain store + weekday + promo average (0.147) is just as good

## Common Mistakes
- Using lags that will not exist at forecast time (set D looks best but is not usable)
- Shifting by row position when some dates are missing
- Fitting encoders or averages on data that includes the validation period
- Assuming dropping correlated features always improves a model (it did not for this tree model)
- Trusting one validation window too much (42 days is a single slice of time)
- Declaring features "good" without comparing against a simple baseline

## Interview Questions
- What is a lag feature, and why can it leak information?
- How does the forecast horizon decide which lags you can use?
- Why match lags by date instead of by row?
- Why fit a OneHotEncoder on the past only?
- What does `handle_unknown="ignore"` do?
- Why can a tree model tolerate correlated features better than a linear model?

## Key Takeaways
- A feature must be available at forecast time
- Test your guesses (the even-week lag idea) before believing them
- Features can cut error a lot, but always compare against a strong simple baseline
- Save feature code as functions for reuse
- A better-looking score is not always a better model

## Limits (honest notes)
- Store average features use the training period, so training rows include their own sales in that average (a mild leak inside the training data, the validation rows are not affected)
- One 42-day validation window, with default gradient boosting settings and no tuning
- `Store` is treated as a plain number by the model, which is why store history helped
- Dropping correlated features matters more for linear models, which Day 78 will test

## Summary
- Built date, lag, store, and encoded features, saved in `features.py`
- Found that the roadmap's 1-day and 7-day lags are not usable for a 6-week forecast
- Found that even-week lags carry more signal because promos seem to alternate by week
- Features took RMSPE from 0.364 to 0.148, and the simple baseline still ties it at 0.147
- Next: Day 78, model training and evaluation
