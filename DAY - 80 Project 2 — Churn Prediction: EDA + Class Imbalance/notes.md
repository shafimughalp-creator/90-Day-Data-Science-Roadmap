[notes.md](https://github.com/user-attachments/files/34521302/notes.md)
# Day 80: Project 2 — Churn Prediction: EDA + Class Imbalance

## Quick Overview
- **Topic:** Starting Project 2: define the churn problem, explore the Telco Customer Churn data, and check the class imbalance
- **What I learned:** In a churn problem, accuracy hides the real story, and a feature like monthly charges can look important for the wrong reason
- **Tools:** Python, pandas, NumPy, SciPy (chi-square test), scikit-learn (metrics), matplotlib, Jupyter Notebook
- **Data note:** the Telco Customer Churn sample dataset (7,043 customers, 21 columns). The raw file is not in this folder, see `data/README.md`

## Introduction
- Project 1 predicted a number (sales). Project 2 predicts a yes/no: will this customer leave?
- Think of a gym: if you can spot who is about to quit, a friendly call might keep them
- Before modeling, I wrote the problem down, then explored the data, then set simple baselines

## Definitions
- **Churn:** a customer leaving the company
- **Binary classification:** predicting one of two classes (here, Yes or No)
- **Class imbalance:** one class is much rarer than the other
- **Precision:** of the customers I flag as churners, how many really churn
- **Recall:** of the customers who really churn, how many I catch
- **F1:** one number that balances precision and recall
- **Stratified split:** a train/test split that keeps the churn share the same in both parts
- **Confounding:** a third factor that tangles two things together (internet service tangles price and churn)
- **Cramer's V:** how strongly two categories are linked (0 = not at all, 1 = perfectly)
- **Rule baseline:** a simple if-then rule that a model must beat

## Important Concepts
- **The problem, written first**
  - Target: `Churn` (Yes or No). Features: contract, tenure, services, payment method, charges
  - `customerID` is a label, not information, so it is not a feature
  - Missing a churner (false negative) loses a customer. Flagging a loyal customer (false positive) wastes an offer. The balance is a business decision, so the threshold will be tuned later
  - Validation: the data is one snapshot with no dates, so a stratified random split is fine (unlike Project 1)
- **Data inspection**
  - 7,043 rows, 21 columns, no duplicate rows, no duplicate customer IDs, no missing values at load
  - **Trap:** `TotalCharges` is stored as text. 11 values are blank, and all 11 customers have tenure 0 (brand new) and did not churn
  - `SeniorCitizen` is 0/1 while the other yes/no columns are text
  - "No internet service" and "No phone service" are real categories, not missing data
- **Class imbalance**
  - Stayed: 5,174 (73.5%). Churned: 1,869 (26.5%). Ratio 2.77 : 1
  - The roadmap rule says a split past 70/30 needs special handling. This one is just past it (73.5/26.5), a moderate imbalance
  - "Always predict No" is 73.5% accurate and catches 0 of 1,869 churners
  - Plan: stratified split, judge models with recall, precision, F1, and PR-AUC, try class weights (`scale_pos_weight` is about the 2.77 ratio), and tune the threshold. Resampling comes later, only if needed
- **Churn by contract**
  - Month-to-month: 42.7% (3,875 customers)
  - One year: 11.3% (1,473)
  - Two year: 2.8% (1,695)
- **Churn by tenure (months)**
  - 0-12: 47.4% (2,186), 13-24: 28.7% (1,024), 25-48: 20.4% (1,594), 49-72: 9.5% (2,239)
  - Median tenure: customers who stayed 38 months, customers who churned 10 months
- **Is contract just a tenure effect? No.** Churn rate (customers) by contract and tenure:
  - Month-to-month: 51.4% (1,994), 37.7% (737), 32.9% (802), 26.0% (342)
  - One year: 10.5% (124), 8.1% (197), 10.6% (518), 12.9% (634)
  - Two year: 0.0% (68), 0.0% (90), 2.2% (274), 3.3% (1,263)
  - The month-to-month gap holds in every tenure group. Some cells are small (68 and 90 customers), so those rates are rough
- **Monthly charges: a confounded feature**
  - Churners pay more: mean $74.4 vs $61.3, median $79.6 vs $64.4
  - Overall churn by charge quartile: 11.2%, 24.6%, 37.5%, 32.9%
  - But within DSL, churn falls as charges rise (36.0%, 21.1%, 6.4%, 2.0%). Within fiber optic it falls too (59.0%, 50.9%, 33.8% across the three quartiles it spans)
  - Why the overall line rises: customers without internet pay little (about $21) and rarely churn (7.4%), while fiber customers pay much more (about $92) and churn more (41.9%). Mixing them makes churn look like it rises with price
  - I did not test why higher-priced customers within a service churn less (one guess: they have more add-on services, but that is only a guess)
- **Which features are most linked to churn? (Cramer's V, with the churn-rate gap between the highest and lowest group)**
  - Contract 0.410 (gap 39.9 points), OnlineSecurity 0.347 (34.4), TechSupport 0.343 (34.2), InternetService 0.322 (34.5), PaymentMethod 0.303 (30.0), OnlineBackup 0.292 (32.5), DeviceProtection 0.282 (31.7), StreamingMovies 0.231 (26.3)
  - All p-values are tiny (strong evidence against independence), but with 7,043 customers almost everything is "significant", so the size of V matters more
  - Correlation of numbers with churn: tenure -0.352, MonthlyCharges 0.193, TotalCharges -0.199
- **Rule baselines (the bar for the models)**
  - Always predict No: accuracy 0.735, precision 0, recall 0
  - Month-to-month contract: accuracy 0.654, precision 0.427, recall 0.886, F1 0.576, flags 3,875 customers
  - Month-to-month and tenure <= 12: accuracy 0.742, precision 0.514, recall 0.548, F1 0.530, flags 1,994
  - The month-to-month rule has **lower accuracy than doing nothing**, but catches 88.6% of churners

## Step-by-Step Explanation
- **Step 1:** Write the problem, target, features, metrics, and validation plan
- **Step 2:** Load the data, check shape, types, duplicates, and missing values
- **Step 3:** Find traps (`TotalCharges` as text) and fix them
- **Step 4:** Check the churn rate and the imbalance
- **Step 5:** Compare churn rates across contract, tenure, and monthly charges
- **Step 6:** Check for confounding (contract vs tenure, charges vs internet service)
- **Step 7:** Rank features by association with churn
- **Step 8:** Build simple rule baselines and score them with recall, precision, and F1

## Examples
- **Practice (service and payment):** fiber optic 41.9% (3,096), DSL 19.0% (2,421), no internet 7.4% (1,526). Electronic check 45.3% (2,365), mailed check 19.1% (1,612), bank transfer 16.7% (1,544), credit card 15.2% (1,522)
- **Mini challenge (top segments with at least 100 customers):**
  - Month-to-month, fiber, electronic check: 60.4% (1,307)
  - Month-to-month, fiber, mailed check: 50.7% (201)
  - Month-to-month, fiber, bank transfer: 45.6% (327)
  - Month-to-month, fiber, credit card: 41.6% (293)
  - Month-to-month, DSL, electronic check: 40.5% (474)

## Common Mistakes
- Judging a churn model by accuracy
- Reading "churners pay more" as "higher prices cause churn"
- Treating a blank-text column as numeric without checking
- Reporting a churn rate for a tiny group without showing how many customers it covers
- Mixing up association and cause (everything here is an association)
- Using a time-based split on data with no dates, or a random split on data with dates

## Interview Questions
- Why is accuracy a poor metric for churn?
- What is a stratified split, and why use it here?
- How would you handle a 70/30 class imbalance?
- What is confounding? Give an example from this data
- What would you do about the 11 blank `TotalCharges` values?
- How do you decide between favoring recall or precision?

## Key Takeaways
- Write the problem and the metric before exploring
- Check the imbalance and what "do nothing" scores
- Always check whether a pattern survives after splitting by another variable
- Show group sizes next to rates
- Simple rule baselines tell you what a model must beat

## Summary
- Churn rate is 26.5% (2.77 : 1), moderate imbalance that needs stratification, the right metrics, and class weights
- Contract type is the strongest single signal, and it holds within every tenure group
- Monthly charges look related to churn mostly because of internet service
- The "month-to-month" rule catches 88.6% of churners with 42.7% precision, a baseline for tomorrow's pipeline
- Next: Day 81, feature engineering and preprocessing
