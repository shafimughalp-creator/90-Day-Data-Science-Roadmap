# Day 81: Project 2 — Feature Engineering + Preprocessing

## Quick Overview
- **Topic:** Turning the raw Telco churn table into model-ready features, inside one leak-free pipeline
- **What I learned:** Cleaning steps can fail silently (a hidden third category created thousands of missing values), and class weights change the recall/precision balance more than the ranking quality
- **Tools:** Python, pandas, scikit-learn (`Pipeline`, `ColumnTransformer`, `OneHotEncoder`, `cross_validate`), XGBoost, matplotlib, Jupyter Notebook
- **Data note:** the Telco Customer Churn sample dataset (7,043 customers). The raw file is not in this folder, see `data/README.md`
- **Code:** `churn_pipeline.py` holds the cleaning functions and the pipeline builder
- **Test set rule:** 20% of customers (1,409) were split off first and not touched today

## Introduction
- Yesterday I explored the churn data. Today I prepared it for a model
- Think of a kitchen: before cooking you wash, peel, and chop. If you chop with a dirty knife, everything after is spoiled
- The goal is one object that takes a raw customer row and returns a churn probability

## Definitions
- **Preprocessing:** cleaning and encoding data before a model sees it
- **Binary encoding:** turning Yes/No into 1/0
- **One-hot encoding:** one 0/1 column per category
- **`drop_first`:** dropping one dummy column per feature (the reference category), because it can be worked out from the others
- **ColumnTransformer:** applies different steps to different groups of columns
- **Pipeline:** one chain from raw data to prediction, fitted on training data only
- **`scale_pos_weight`:** XGBoost setting that makes each churner count more in training
- **ROC-AUC / PR-AUC:** how well the model ranks churners above stayers (PR-AUC focuses on the rare class)
- **Data leakage:** test-set information influencing training

## Important Concepts
- **Step 1: drop `customerID`, fix `TotalCharges`**
  - Columns 21 to 20
  - `TotalCharges` was text. `pd.to_numeric(errors="coerce")` turns the 11 blanks into NaN (all brand-new customers with tenure 0)
- **Step 2: the hidden trap in `map({'Yes': 1, 'No': 0})`**
  - Six add-on columns (OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies) have **three** values: No, No internet service, Yes
  - The plain map turned "No internet service" into **NaN: 1,526 missing values in each of the 6 columns**, with no error message
  - Those rows are exactly the customers with `InternetService = No`, so I replaced the value with "No". No information is lost, because `InternetService` is kept
  - After the fix: 0 NaN left, and the binary columns hold only 0 and 1
  - `MultipleLines` has a similar "No phone service" value, which I kept as a category in the one-hot step
- **Step 3: one-hot with `drop_first=True`**
  - 4 columns become 9: MultipleLines (3 categories, 2 columns), InternetService (3, 2), Contract (3, 2), PaymentMethod (4, 3)
  - Reference categories dropped: 'No', 'DSL', 'Month-to-month', 'Bank transfer (automatic)'
  - The table goes from 20 to 25 columns (including the Churn target), which means 24 features
  - `pd.get_dummies` on the whole table is fine for fixed categories, but a pipeline is safer for new data
- **Step 4: the pipeline**
  - `clean_telco` (no learned statistics, so it cannot leak) then `ColumnTransformer` then `XGBClassifier(scale_pos_weight=3)`
  - Features by type: 3 numeric (median-filled and scaled), 12 binary (passed through), 9 one-hot, total 24
  - Model settings (200 trees, learning rate 0.05, depth 3) are modest starting values I chose before seeing results, not tuned
  - The encoder uses `handle_unknown="ignore"`, so a new category does not crash it
- **Train and test split:** 5,634 training and 1,409 test customers, both with a churn rate of 26.5%. Everything below uses 5-fold stratified cross-validation on the training part only
- **What class weights do (5-fold CV means)**
  - Stayed : churned in the training data = 2.77 : 1
  - weight 1: ROC-AUC 0.848, PR-AUC 0.667, precision 0.670, recall 0.520, F1 0.586
  - weight 2.77: ROC-AUC 0.847, PR-AUC 0.665, precision 0.519, recall 0.807, F1 0.631
  - weight 3: ROC-AUC 0.847, PR-AUC 0.665, precision 0.509, recall 0.823, F1 0.629
  - Fold-to-fold std of ROC-AUC is 0.012 for all three
  - So weighting raised recall by about 30 points and cut precision by about 16 points, while ranking quality did not change. That suggests threshold tuning can do much of the same job
- **Three new features (5 folds x 3 repeats, same folds for both versions)**
  - `n_addons` (how many of the 6 add-ons), `autopay` (pays automatically), `avg_monthly_spend` (TotalCharges / tenure)
  - Base: ROC-AUC 0.847 +/- 0.013, PR-AUC 0.665 +/- 0.021
  - With new features: ROC-AUC 0.847 +/- 0.013, PR-AUC 0.663 +/- 0.021
  - Fold by fold: ROC-AUC difference -0.0001 (better in 6 of 15 folds), PR-AUC difference -0.0022 (better in 5 of 15 folds)
  - Verdict: no sign that they help, so they stay out of the base pipeline
- **Pipeline vs the simple rule**
  - Month-to-month rule (training data): precision 0.427, recall 0.887, F1 0.577
  - XGBoost pipeline, weight 3 (CV): precision 0.509, recall 0.823, F1 0.629
  - The pipeline wins on F1 by about 0.05, with better precision and a bit lower recall
- **Top features (XGBoost importance)**
  - Contract_Two year 0.326, Contract_One year 0.196, InternetService_Fiber optic 0.136, InternetService_No 0.075, StreamingMovies 0.043, PaymentMethod_Electronic check 0.038, tenure 0.035, OnlineSecurity 0.024, PaperlessBilling 0.020, TechSupport 0.011
  - This matches Day 80: contract type is the strongest signal

## Step-by-Step Explanation
- **Step 1:** Split off a test set first and leave it alone
- **Step 2:** Clean (drop ID, convert `TotalCharges`)
- **Step 3:** Encode binary columns, checking for hidden extra categories
- **Step 4:** One-hot encode the multi-category columns with `drop_first`
- **Step 5:** Put it all in a `ColumnTransformer` inside a `Pipeline`, with the model as the last step
- **Step 6:** Compare class weights with stratified cross-validation
- **Step 7:** Test new features fairly (same folds, fold-by-fold differences)
- **Step 8:** Check that the pipeline scores a raw, messy new customer

## Examples
- **Practice (is `TotalCharges` just tenure x MonthlyCharges?):** correlation about 1.0 (rounds to 1.000), median absolute gap $28.6, correlation with tenure alone 0.826. So `TotalCharges` is almost fully explained by the other two. That is harmless for trees, but it would be a multicollinearity problem for a linear model
- **Mini challenge (a brand-new raw customer):** a month-to-month fiber customer with tenure 0, a blank `TotalCharges`, and a payment method never seen in training ("Crypto wallet") went straight through the pipeline, with a churn probability of 0.923 and no error

## Common Mistakes
- Using `map({'Yes': 1, 'No': 0})` without checking for a third value (silent NaN)
- Fitting scalers or encoders on all data before splitting
- Trusting `get_dummies` on training data and then scoring new data with different columns
- Reading a higher recall from class weights as a better model (the ranking did not improve)
- Adding new features and not testing them fairly
- Touching the test set while still comparing options

## Interview Questions
- Why put preprocessing inside a pipeline?
- What does `drop_first=True` do, and why?
- What does `handle_unknown="ignore"` do?
- What does `scale_pos_weight` change, and what does it not change?
- How would you check that a Yes/No map did not create missing values?
- Why keep a test set untouched until the end?

## Key Takeaways
- Check every encoding for NaN afterward
- A pipeline is the safe way to preprocess, and it makes new data easy to score
- Class weights trade precision for recall, they do not rank better
- Test new features against a baseline before keeping them
- Keep the test set clean

## Limits (honest notes)
- Model settings are not tuned, and only one model type was used
- The charts for the new-features comparison start their y-axis at 0.4, so bar differences look bigger than they are
- The rule baseline is measured on the training data (it has nothing to fit), and the pipeline on cross-validated folds
- Every result is from one dataset split with one random seed

## Summary
- Built a pipeline from raw table to churn probability, with 24 features
- Caught a silent bug: 1,526 missing values in each of 6 columns from a hidden third category
- Class weights moved recall from 0.52 to 0.82 and precision from 0.67 to 0.51, with the same ROC-AUC (0.847)
- Three new features did not help
- The pipeline beat the simple rule on F1 (0.629 vs 0.577)
- Next: Day 82, model comparison and the final test-set evaluation
