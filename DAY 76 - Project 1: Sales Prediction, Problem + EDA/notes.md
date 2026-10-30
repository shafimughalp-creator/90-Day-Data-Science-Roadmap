[Uploading notes.md…]()
# Day 76: Project 1 — Sales Prediction: Problem + EDA

## Quick Overview
- **Topic:** Starting Project 1 (Phase 5): define the sales prediction problem and explore the Rossmann data before any modeling
- **What I learned:** Write the problem down first (target, features, metric, validation), then let EDA find the patterns and the traps
- **Tools:** Python, pandas, NumPy, matplotlib, Jupyter Notebook
- **Data note:** the real Rossmann Store Sales data from Kaggle (`train.csv` with 1,017,209 rows, `store.csv` with 1,115 stores). The raw files are not in this repo because of competition data rules, see `data/README.md`

## Introduction
- Phase 5 is about portfolio projects, and Project 1 is a sales forecast
- Rossmann is a drug store chain. Store managers must predict their daily sales up to 6 weeks ahead
- Before touching any model, I wrote down the problem and explored the data
- Think of it like a doctor: first ask what is wrong and what to measure, then run tests

## Definitions
- **Regression:** predicting a number (here, sales)
- **Target (y):** what we predict (`Sales`)
- **Features (X):** the inputs we use to predict it
- **Data leakage:** using information that would not be available at prediction time
- **RMSPE:** root mean squared percentage error, the Kaggle metric. It measures relative error
- **Time-based validation:** train on the past, test on a later period, never shuffle time
- **Baseline:** a simple prediction rule that any model must beat
- **Right-skewed:** a long tail of very large values on the right
- **Rolling average:** the average of the last N days, used to smooth a line
- **EDA:** exploratory data analysis

## Important Concepts
- **The problem, written first**
  - Predict daily `Sales` per store, 6 weeks ahead
  - Features: store, day of week, date parts, `Promo`, holidays, store details
  - **Not** `Customers`: correlation with Sales is 0.82, but we would not know future customers (leak)
  - Metric: RMSPE, because a 500 error means more on a 5,000 sale day than on a 10,000 one
  - Validation: the last 42 days (from 2015-06-20), not a random split
- **Structure and missing values**
  - 1,017,209 rows, 9 columns, 1,115 stores, 942 days (2013-01-01 to 2015-07-31)
  - `train.csv` has no missing values
  - `store.csv`: CompetitionDistance 0.3%, CompetitionOpenSince month and year 31.7%, Promo2Since week and year 48.8%, PromoInterval 48.8%
  - The 48.8% gaps are not lost data: all 544 stores with `Promo2 = 0` have them blank, and none of the Promo2 stores do
- **Closed days**
  - 17.0% of rows are closed days, and every closed row has zero sales
  - 54 rows have zero sales even though the store was open (odd rows to look at later)
  - Open days (`Open == 1` and `Sales > 0`): 844,338 rows
- **Sales distribution (open days)**
  - Mean 6,956, median 6,369, std 3,104, min 46, max 41,551, skew 1.59
  - Right-skewed, and `log(1 + Sales)` looks close to symmetric
- **Sales over time**
  - A strong weekly wave (Sunday totals dip because most stores are closed)
  - December peaks in both 2013 and 2014
- **Day of week (average sales)**
  - Mon 8,216, Tue 7,088, Wed 6,729, Thu 6,768, Fri 7,073, Sat 5,875, Sun 8,225
  - Sunday looks high, but only 3,593 Sunday rows are open days (vs 135,000 to 145,000 for other days), so those are a special group of stores, not proof that Sundays are busy
- **Month:** December averages 8,609, about 24% above the overall average (6,956). Other months range from 6,547 to 7,189
- **Stores:** the top store (817) averages 21,757 per day, about 3.1 times the average store (6,935). Next are 262 (20,719) and 1114 (20,667)
- **Promotions**
  - Average sales: 5,930 without promo, 8,229 with promo (+38.8%)
  - The uplift depends on the weekday: about 57% on Mon, 45% Tue, 37% Wed, 32% Thu, 22% Fri
  - Promos only run Monday to Friday, so the weekday table is the fairer comparison
  - This is an association, stores do not get promos at random
- **Stores with missing days**
  - 181 stores have fewer than 942 days
  - 180 of them are missing exactly the same 184 days: 2014-07-01 to 2014-12-31
  - Total sales per day fell from 6.52M (Jul to Dec 2013) to 5.66M (Jul to Dec 2014), about 13% lower
  - But stores open per day dropped from 937 to 787, and sales per open store actually rose from 7,202 to 7,520
  - So the dip comes from missing stores, not weaker demand
- **Baselines (RMSPE on the last 42 days, 40,282 rows)**
  - Global average: 0.583
  - Store average: 0.331
  - Store + day of week: 0.236
  - Store + day of week + promo: 0.147
  - Any model I build must beat 0.147 to be worth it

## Step-by-Step Explanation
- **Step 1:** Write the problem (target, features, metric, validation) before looking at the data
- **Step 2:** Load the data and check shape, date range, and number of stores
- **Step 3:** Check data types and missing values (and why they are missing)
- **Step 4:** Look for traps: closed days, zero sales, missing dates
- **Step 5:** Plot the target (distribution and over time)
- **Step 6:** Group by day of week, month, store, and promo to find patterns
- **Step 7:** Check suspicious features for leakage (`Customers`)
- **Step 8:** Build simple baselines and score them with the real metric

## Examples
- **Practice (store types):** type a has 602 stores averaging 6,926, type b has 17 stores averaging 10,233, type c has 148 stores averaging 6,933, and type d has 348 stores averaging 6,822
  - Type b is high, but with only 17 stores it may reflect a few special stores
- **Mini challenge (promo by weekday):** uplift shrinks from Monday to Friday, see above
- **State holidays:** open stores on holidays averaged more (a: 8,487, b: 9,888, c: 9,744 vs 6,954 on normal days), but there are only 910 such open rows, so they are a special group

## Common Mistakes
- Starting to model before defining the metric and the validation
- Using `Customers` as a feature (it leaks future information)
- Averaging in the closed days (zeros) and getting misleading numbers
- Using a random train/test split on time-ordered data
- Reading a drop in total sales as lower demand without checking how many stores were open
- Treating the promo uplift as proof of cause

## Interview Questions
- How would you set up a sales forecasting problem?
- Why is `Customers` a leak here, even though it predicts sales well?
- Why use RMSPE instead of RMSE?
- Why must validation be time-based?
- How do you decide if a group of missing values is a problem?
- What is a baseline, and why compute one first?

## Key Takeaways
- Define target, features, metric, and validation first
- Check for leaks and traps before modeling
- Compare like with like (per-store averages, not just totals)
- EDA findings become the feature list for tomorrow
- Simple baselines show how much a model really adds

## Summary
- Defined the problem as daily sales forecasting for 1,115 stores, scored with RMSPE on a time-based split
- Found strong effects from day of week, month, promo, and store
- Found that 180 stores vanish for 6 months, which explains a dip that looks like lower demand
- Set the baseline to beat: RMSPE 0.147
- Next: Day 77, feature engineering (date features, lags, encoding)
