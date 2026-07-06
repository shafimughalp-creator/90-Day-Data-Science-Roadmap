# Day 15: Exploratory Data Analysis (EDA) Warm-Up

## Quick Overview
- **Topic:** First full Exploratory Data Analysis (EDA) pass, practiced on a messy real-world Titanic dataset.
- **What I learned:** Before analyzing any dataset, you must check and clean it — missing values, inconsistent text, and wrong data types all break calculations if ignored.
- **Tools used:** Python, pandas, numpy.

## Introduction
Every dataset in the real world arrives messy. Day 15 marks the shift from learning individual statistics concepts (Days 1–14) to actually applying a repeatable process on raw data — starting with a full first look before asking any specific question. This session used a Titanic passenger dataset that intentionally included realistic messiness: inconsistent capitalization, stray whitespace, currency symbols in numeric columns, and a fake "missing" text marker.

## Definitions
- **EDA (Exploratory Data Analysis):** The practice of examining a dataset's structure, quality, and basic patterns before running any formal analysis or model.
- **Missing value:** A cell with no data, represented in pandas as `NaN` (Not a Number).
- **Data type (dtype):** The kind of value a column holds — text (`object`), whole numbers (`int`), or decimal numbers (`float`).
- **Data cleaning:** The process of fixing inconsistent, incorrect, or improperly formatted data before analysis.

## Important Concepts
- Text values that "look the same" to a human (`"male"`, `"MALE"`, `" male "`) are treated as different values by Python unless explicitly standardized.
- A single stray symbol (like `$` in a Fare column) can force an entire numeric column to be read as text, silently breaking every later calculation.
- Placeholder text like `"N/A"` is not automatically recognized as missing — it must be manually converted to a real missing value (`NaN`).
- Cleaning should be done one column, one fix at a time, checking the result after every step — this makes mistakes easy to catch.

## Step-by-Step Explanation
1. **Load the data** and preview the first few rows.
2. **Check for missing values** in every column using `.isna().sum()`.
3. **Check for inconsistent text** in categorical columns using `.unique()`.
4. **Clean each problem one at a time:**
   - Strip whitespace with `.str.strip()`
   - Standardize case with `.str.lower()`
   - Remove stray symbols with `.str.replace()`
   - Convert cleaned text back to numbers with `.astype(float)`
   - Replace placeholder text with real missing values using `.replace('N/A', np.nan)`
5. **Run basic statistics** (`.describe()`, `.mean()`) once the data is clean.
6. **Compare simple groups** (e.g., survival rate by gender) to spot early patterns.

## Examples
```python
# Cleaning inconsistent text in a column
df['Sex'] = df['Sex'].str.strip()
df['Sex'] = df['Sex'].str.lower()

# Fixing a numeric column stored as text because of a currency symbol
df['Fare'] = df['Fare'].astype(str)
df['Fare'] = df['Fare'].str.replace('$', '')
df['Fare'] = df['Fare'].astype(float)

# Comparing survival rate between two groups
female_survival = df[df['Sex'] == 'female']['Survived'].mean()
male_survival = df[df['Sex'] == 'male']['Survived'].mean()
```

## Common Mistakes
- Assuming a column is clean just because it "looks numeric" at a glance — always check `.dtype`.
- Forgetting that placeholder text like `"N/A"` is not the same as a real missing value to pandas.
- Averaging or comparing groups *before* cleaning inconsistent category labels — this silently splits one real group (e.g., "female") into several fake ones.
- Doing all cleaning steps in one dense line — harder to debug than fixing and checking one issue at a time.

## Interview Questions
1. What is EDA, and why is it usually the first step in any data science project?
2. What's the difference between a missing value (`NaN`) and a placeholder string like `"N/A"`?
3. How would you detect that a numeric column has accidentally been loaded as text?
4. Why might `.str.strip()` and `.str.lower()` be necessary before grouping categorical data?
5. Give an example of how unclean data could produce a misleading statistic.

## Key Takeaways
- Cleaning always comes before analysis — skipping it produces wrong or broken results.
- Fix messy data one column and one issue at a time, verifying after each fix.
- `.unique()` and `.isna().sum()` are the two fastest ways to spot data quality problems early.
- Even a simple grouped comparison (survival rate by gender) is a basic form of hypothesis testing — the same question later formal tests (t-test, chi-square) answer more rigorously.

## Summary
Day 15 shifted from learning isolated statistics concepts to practicing the full beginner EDA workflow on a realistic, messy dataset. The main skill built here isn't a new formula — it's the discipline of checking data quality first, fixing issues one at a time, and only then moving on to basic statistics and group comparisons.
