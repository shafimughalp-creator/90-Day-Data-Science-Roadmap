[notes.md](https://github.com/user-attachments/files/33858489/notes.md)
# Day 73: sklearn Pipeline — Production-Ready ML

## Quick Overview
- **Topic:** Chaining preprocessing and a model into one object with `Pipeline` and `ColumnTransformer`
- **What I learned:** A pipeline fits every step on training data only, so leakage cannot sneak in, and one saved object can take raw data to predictions
- **Tools:** Python, pandas, NumPy, scikit-learn (`Pipeline`, `ColumnTransformer`, `SimpleImputer`, `StandardScaler`, `OneHotEncoder`, `GridSearchCV`), joblib, Jupyter Notebook
- **Data note:** `dataset.csv` is the real Titanic dataset (891 passengers, 38.4% survived)

## Introduction
- Until now, I scaled, encoded, and trained in separate steps
- Separate steps are easy to mess up: one wrong order and test data leaks into training
- A pipeline puts all the steps in one chain, like an assembly line
- Raw data goes in one end, a prediction comes out the other

## Definitions
- **Pipeline:** an ordered chain of steps, ending with a model
- **Step:** one named stage, like `("scaler", StandardScaler())`
- **ColumnTransformer:** applies different steps to different columns
- **Imputer:** fills in missing values
- **OneHotEncoder:** turns categories into 0/1 columns
- **`handle_unknown="ignore"`:** a new, unseen category becomes all zeros instead of crashing
- **Data leakage:** test-set information influencing training
- **GridSearchCV:** tries every combination of settings using cross-validation
- **joblib:** saves a fitted object to a file so it can be reloaded later

## Important Concepts
- **Pipeline basics**
  - `fit` runs each step on the training data in order
  - `predict` runs the same steps on new data automatically
  - Step names let you reach settings like `model__max_depth`
- **Leakage, shown with numbers**
  - A scaler fitted on all rows had a Fare mean of 32.204
  - Fitted on training rows only, it was 31.820
  - So the "wrong" way let test rows shift the scaler
  - In cross-validation the effect was tiny here (AUC 0.725 leaky vs 0.723 with a pipeline)
  - The pipeline matters because it makes leakage impossible, not because it always changes the score
- **ColumnTransformer**
  - Numeric columns: impute (median) then scale
  - Categorical columns: impute (most frequent) then one-hot encode
  - 7 input columns became 12 after encoding
- **GridSearchCV on the whole pipeline**
  - Can tune preprocessing settings and model settings together
  - Names use double underscores, like `prep__num__imputer__strategy`
- **Production-ready**
  - The pipeline accepted a raw passenger with a missing age and a port it had never seen (`"X"`) and still returned a prediction
  - The reloaded pipeline gave identical predictions to the original

## Step-by-Step Explanation
- **Step 1:** Split columns into numeric and categorical lists
- **Step 2:** Build a numeric pipeline (imputer, scaler) and a categorical pipeline (imputer, one-hot)
- **Step 3:** Combine them in a `ColumnTransformer`
- **Step 4:** Add a model as the final step of a `Pipeline`
- **Step 5:** Check it with `cross_val_score`
- **Step 6:** Tune it with `GridSearchCV` using `step__setting` names
- **Step 7:** Save it with `joblib.dump` and predict on raw data later

## Examples
- **Numeric columns only:** test accuracy 0.575, which is worse than always guessing "died" (0.615), because `Sex` was missing
- **Full pipeline (numeric + categorical):** CV AUC 0.853 +/- 0.036, test accuracy 0.816, test AUC 0.831
- **After GridSearchCV:** best settings were `max_depth=5`, `n_estimators=300`, and mean imputation, with CV AUC 0.872 and test AUC 0.847
  - The CV score is a little optimistic because the settings were picked using those same folds, so the test score (0.847) is the fairer number
  - The mean vs median imputation difference is probably noise
- **Raw prediction:** a first-class woman aged 28 got a survival probability of 0.974, and 0.970 with a missing age and an unknown port
- **Practice (swap the model):** Logistic Regression CV AUC 0.855 +/- 0.023 vs Random Forest 0.853 +/- 0.036, basically a tie
- **Mini challenge (FamilySize feature):** test AUC went from 0.831 to 0.828, so no real improvement

## Common Mistakes
- Scaling or encoding before the train/test split
- Imputing with statistics from the whole dataset
- Forgetting `handle_unknown="ignore"` in `OneHotEncoder`
- Wrong step names in the `GridSearchCV` grid (check with `pipeline.get_params().keys()`)
- Reporting the best CV score as if it were the final test score
- Using only numeric columns and ignoring strong categorical ones like `Sex`

## Interview Questions
- What is data leakage, and how do pipelines help prevent it?
- Why use `ColumnTransformer` instead of preprocessing columns by hand?
- What does the double-underscore naming in `GridSearchCV` mean?
- What does `handle_unknown="ignore"` do?
- Why is the best CV score from a grid search slightly optimistic?
- How would you ship a trained model to production?

## Key Takeaways
- A pipeline fits every step on training data only
- `ColumnTransformer` handles numeric and categorical columns in one object
- Put the whole pipeline inside `GridSearchCV`
- One saved pipeline takes raw data to predictions
- Swapping a model is a one-line change

## Summary
- Built a complete Titanic pipeline: imputation, scaling, one-hot encoding, and a Random Forest
- Cross-validated AUC was 0.853, and tuning raised test AUC to 0.847
- The pipeline handled missing values and unseen categories with no extra code
- Day 74 compares all the algorithms on one dataset, and pipelines will keep that comparison fair
