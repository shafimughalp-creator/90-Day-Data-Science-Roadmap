[notes.md](https://github.com/user-attachments/files/33204128/notes.md)
# Day 66: Feature Engineering — Encoding Categorical Variables

## Quick Overview
- **Topic:** Turning text categories into numbers so ML models can use them
- **What I learned:** Use OrdinalEncoder for ordered data, One-Hot for unordered data, and `drop_first=True` to avoid the dummy variable trap
- **Tools:** Python, pandas, scikit-learn (`LabelEncoder`, `OrdinalEncoder`, `OneHotEncoder`), Jupyter Notebook

## Introduction
- ML models only understand numbers, not words like "Forward" or "high"
- Encoding is the step that converts categories into numbers
- The way we encode matters, because a wrong choice teaches the model something false
- Example: if "Defender = 0" and "Midfielder = 3", the model may think a Midfielder is "more" than a Defender

## Definitions
- **Categorical variable:** a column with labels instead of numbers (position, league)
- **Nominal:** categories with **no** natural order (position, league, preferred foot)
- **Ordinal:** categories with a **real** order (low < medium < high)
- **Encoding:** converting categories into numbers
- **Label Encoding:** gives each category one integer (0, 1, 2, ...)
- **Ordinal Encoding:** like label encoding, but **you** choose the order
- **One-Hot Encoding:** one new 0/1 column per category
- **Dummy variable trap:** when one-hot columns are fully predictable from each other
- **Multicollinearity:** when input columns carry the same information

## Important Concepts
- **Nominal vs ordinal decides the method**
  - Ordinal -> OrdinalEncoder with a custom order
  - Nominal -> One-Hot Encoding
- **LabelEncoder sorts alphabetically**
  - It gave `high=0, low=1, medium=2`, which is the wrong order for fitness
  - It was built to encode target labels (y), not input features
- **One-hot avoids fake order**
  - Each category gets its own column, so no category looks "bigger"
- **Dummy variable trap**
  - If you keep every one-hot column, each row sums to 1
  - One column can always be worked out from the others
  - This causes perfect multicollinearity (a real problem for linear models)
  - Fix: `drop_first=True`

## Step-by-Step Explanation
- **Step 1:** Look at each categorical column and ask "does order matter?"
- **Step 2 (ordinal):** Use `OrdinalEncoder(categories=[["low", "medium", "high"]])`
- **Step 3 (nominal):** Use `pd.get_dummies()` or `OneHotEncoder()`
- **Step 4:** Add `drop_first=True` to drop one column and avoid the trap
- **Step 5:** Combine all encoded columns into one model-ready table

## Examples
- **LabelEncoder on nominal data (risky)**
  - `{'Defender': 0, 'Forward': 1, 'Goalkeeper': 2, 'Midfielder': 3}`
  - Creates a fake order between positions
- **LabelEncoder on ordinal data (wrong order)**
  - `{'high': 0, 'low': 1, 'medium': 2}`
- **OrdinalEncoder with custom order (correct)**
  - `low -> 0.0`, `medium -> 1.0`, `high -> 2.0`
- **pandas One-Hot**
  - `pd.get_dummies(df["position"], dtype=int)` -> 4 columns
- **sklearn One-Hot**
  - `OneHotEncoder(sparse_output=False)` -> columns like `league_Premier`
- **Dummy trap fix**
  - `pd.get_dummies(df["preferred_foot"], drop_first=True)` -> keeps only `Right`

## Common Mistakes
- Using LabelEncoder on nominal input features
- Trusting LabelEncoder to know the order of ordinal data (it sorts A-Z)
- Forgetting `drop_first=True` with linear or logistic regression
- One-hot encoding a column with hundreds of unique values (creates too many columns)
- Encoding before the train/test split (fit encoders on training data only, like with scalers)

## Interview Questions
- What is the difference between nominal and ordinal data?
- Why can't we feed text categories directly into most ML models?
- When would you use One-Hot Encoding instead of Label Encoding?
- What is the dummy variable trap, and how do you avoid it?
- Why does `LabelEncoder` give the wrong order for "low / medium / high"?
- What problem can happen with one-hot encoding on high-cardinality columns?

## Key Takeaways
- Ask first: is this column nominal or ordinal?
- Ordinal -> OrdinalEncoder with your own order
- Nominal -> One-Hot Encoding
- LabelEncoder sorts alphabetically, so be careful
- Use `drop_first=True` to avoid the dummy variable trap

## Summary
- Encoding turns categories into numbers, and the method must match the data type
- Wrong encoding creates fake relationships that mislead the model
- OrdinalEncoder keeps real order, One-Hot removes fake order
- Dropping one one-hot column avoids redundant information
- Today's practice used a small football dataset (20 players) in a Jupyter notebook
