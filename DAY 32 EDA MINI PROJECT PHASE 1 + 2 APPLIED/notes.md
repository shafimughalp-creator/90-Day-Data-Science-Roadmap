[day_32_notes.md](https://github.com/user-attachments/files/30666878/day_32_notes.md)# Full EDA on Telco Customer Churn — Mini Project #1

## Quick Overview
- Topic: applying every EDA skill learned so far (cleaning, univariate/bivariate analysis, stats) to one real dataset end-to-end
- What I learned: how to turn a raw, messy CSV into clean, statistically-backed insights without being told each step
- Tech/tools used: Pandas, NumPy, Matplotlib, Seaborn, SciPy (`skew`, `ttest_ind`)

## Introduction
- This is the first Mini Project of the roadmap — no new syntax, just applying Days 1–31 to a real dataset
- Dataset: Telco Customer Churn (Kaggle) — one row per customer, with account info and whether they churned (left the company)
- Goal: load → clean → explore → apply stats → summarize insights, solo, with review after each section

## Definitions
- **EDA (Exploratory Data Analysis):** the process of getting to know a dataset before modeling — checking shape, types, missing values, distributions, and relationships
- **Churn:** when a customer stops using a company's service (cancels/leaves)
- **Skewness:** a measure of how lopsided a distribution is — 0 means symmetric, positive means a long tail to the right
- **Two-sample t-test:** a statistical test that compares the means of two independent groups to see if the difference is likely real or just random noise

## Important Concepts
- **Dtype correctness matters before analysis** — `TotalCharges` looked numeric but was stored as `object` (text), which would break any math or plotting on that column
- **Missing values need a reason, not a default action** — the 11 missing `TotalCharges` values weren't random; they were new customers with 0 tenure, so `fillna(0)` was the logical choice over dropping rows
- **Univariate before bivariate** — understand each column on its own (distribution, skew) before comparing columns against each other
- **Groupby + `value_counts(normalize=True)`** turns raw counts into percentages, which is what actually reveals churn *rate* differences between groups
- **A visual difference isn't proof** — the boxplot showing churned customers with shorter tenure was confirmed to be statistically significant with a t-test, not just assumed from the picture

## Step-by-Step Explanation
- **Kickoff (Setup & Load):** imported Pandas, NumPy, Matplotlib, Seaborn, and `skew`/`ttest_ind` from SciPy; loaded the CSV and checked its shape
- **Scouting Report (Initial Inspection):** used `.info()`, `.describe()`, and `.dtypes` to get a first read on the data — spotted `TotalCharges` as the wrong dtype
- **Fitness Check (Cleaning):** converted `TotalCharges` to numeric with `pd.to_numeric(..., errors="coerce")`, filled the resulting 11 NaNs with 0, and confirmed no duplicate customer rows
- **Formation Analysis (Univariate EDA):** looked at the `Churn` distribution (counts and %), then plotted and checked skew for `tenure`, `MonthlyCharges`, and `TotalCharges`
- **Head-to-Head (Bivariate EDA):** grouped `Churn` by `Contract` and by `PaymentMethod` to compare churn rates; compared `tenure` between churned and loyal customers with a boxplot and medians
- **VAR Review (Stats Application):** built a correlation heatmap across the three numeric columns, then ran a two-sample t-test on tenure between churned vs. non-churned groups
- **Full-Time Whistle (Insights Summary):** pulled every finding together into a short list of business-relevant takeaways

## Examples
- Fixing the dtype: `df['TotalCharges'] = pd.to_numeric(df['TotalCharges'], errors='coerce')`
- Filling missing values with intent: `df['TotalCharges'] = df['TotalCharges'].fillna(0)`
- Comparing group churn rates: `df.groupby('Contract')['Churn'].value_counts(normalize=True)`
- Testing a difference statistically: `t_stat, p_value = ttest_ind(churned, not_churned)`

## Common Mistakes
- Assuming a column's dtype is correct just because the values "look like" numbers
- Dropping rows with missing values automatically, without checking *why* they're missing
- Reading a boxplot or bar chart as final proof of a difference, instead of backing it up with a test
- Only checking raw counts (`value_counts()`) instead of normalized percentages when comparing groups of different sizes

## Interview Questions
- Why would you use `pd.to_numeric(..., errors="coerce")` instead of just casting with `.astype(float)`?
- How do you decide whether to fill or drop missing values in a column?
- What's the difference between a one-sample and a two-sample t-test, and how do you know which one to use?
- Why check skewness of a numeric column before deciding how to visualize or transform it?
- What does a low p-value (like 8e-205) actually tell you, and what doesn't it tell you?

## Key Takeaways
- Cleaning isn't just "fix the errors" — it's understanding *why* the data looks the way it does before deciding how to fix it
- Univariate → bivariate → statistical test is a repeatable order for any EDA project
- `normalize=True` is the difference between comparing counts and comparing rates
- A hypothesis test turns "it looks different" into "it's statistically different"

## Summary
- Completed a full solo EDA pipeline on the Telco Customer Churn dataset: cleaned a mistyped column, handled missing values with reasoning, explored distributions, compared churn across contract types and payment methods, and confirmed the tenure difference with a t-test
- Churn is imbalanced (~73% No / 27% Yes), month-to-month contracts and electronic-check payments churn the most, and tenure is the strongest signal separating churned from loyal customers (median 10 vs. 38 months, p ≈ 8e-205)
