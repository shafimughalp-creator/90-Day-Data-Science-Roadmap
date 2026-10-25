[Uploading notes.md…]()
# Day 74: ML Review — Compare All Algorithms on One Dataset

## Quick Overview
- **Topic:** Comparing Logistic Regression, KNN, Decision Tree, Random Forest, and XGBoost on the same data
- **What I learned:** A fair comparison needs the same preprocessing and the same folds, and you must read the spread (std), not just the average
- **Tools:** Python, pandas, scikit-learn (`Pipeline`, `ColumnTransformer`, `cross_val_score`, `cross_validate`), XGBoost, matplotlib, Jupyter Notebook
- **Data note:** `dataset.csv` is the real Titanic dataset (891 passengers, 38.4% survived). No test set was used to pick a winner, only cross-validation

## Introduction
- Over the last weeks I learned many algorithms one by one
- Today I put them in the same race, on the same track
- Think of five runners: to compare them fairly, they must run the same distance, on the same day
- This is what a data scientist does before choosing a model for a new problem

## Definitions
- **Cross-validation (CV):** splitting data into folds, training on some and testing on the rest, many times
- **Repeated CV:** doing that whole process several times with different splits (here 5 folds x 3 repeats = 15 scores)
- **Mean AUC:** the average score across folds
- **Std (standard deviation):** how much the score moves from fold to fold
- **Overfitting gap:** training score minus CV score
- **Feature importance:** how much a tree-based model used each feature
- **Spearman correlation:** how similarly two lists rank things (1 = same ranking)
- **Baseline:** a simple model that more complex ones must beat

## Important Concepts
- **What makes the comparison fair**
  - Same data
  - Same preprocessing (impute, scale, one-hot) inside a pipeline
  - Same 15 folds for every model
  - Only the last step (the model) changes
- **Results (mean AUC +/- std, 15 folds)**
  - XGBoost: 0.866 +/- 0.023
  - Random Forest: 0.864 +/- 0.020
  - Logistic Regression: 0.851 +/- 0.026
  - KNN (k=5): 0.847 +/- 0.021
  - Decision Tree: 0.776 +/- 0.022
- **Is the top spot real?**
  - XGBoost beat Random Forest by only 0.0029 on average
  - The fold-to-fold difference had std 0.0129, and XGBoost won only 8 of 15 folds
  - So XGBoost vs Random Forest is a tie here, not a win
  - The top four models are within about 0.02 AUC of each other, close to one std
  - Only the Decision Tree is clearly worse
- **Overfitting check (train AUC / CV AUC / gap, 5-fold)**
  - Logistic Regression: 0.857 / 0.848 / 0.009
  - KNN: 0.930 / 0.843 / 0.087
  - Decision Tree: 0.999 / 0.775 / 0.225
  - Random Forest: 0.998 / 0.855 / 0.142
  - XGBoost: 0.961 / 0.869 / 0.092
  - A big gap is not always bad for the final score (Random Forest still did well), but it tells you the model memorizes the training data
- **Do tree models agree on feature importance?** Only partly
  - All three put Sex near the top (Random Forest splits it over two columns: 0.136 + 0.146)
  - Random Forest relied heavily on Age (0.256) and Fare (0.250), but XGBoost gave them only about 0.03 each
  - XGBoost leaned on Pclass_3 (0.274), while Random Forest gave it just 0.053
  - Spearman rank agreement: Decision Tree vs XGBoost 0.71, Decision Tree vs Random Forest 0.59, Random Forest vs XGBoost 0.19
  - Impurity-based importance can favor continuous features like Age and Fare, so these numbers should not be read as exact "cause"
- **Feature matters more than model**
  - Dropping `Sex` took Random Forest from 0.864 to 0.755 (a loss of 0.109), more than the gap between any two good models

## Step-by-Step Explanation
- **Step 1:** Build one preprocessor with `ColumnTransformer`
- **Step 2:** Put each model in a pipeline with that same preprocessor
- **Step 3:** Use one `RepeatedStratifiedKFold` object so every model sees the same folds
- **Step 4:** Run `cross_val_score(..., scoring="roc_auc")` and record mean and std
- **Step 5:** Compare the top models fold by fold (differences, not just means)
- **Step 6:** Check train vs CV AUC with `cross_validate(..., return_train_score=True)`
- **Step 7:** Fit the tree-based models and compare `feature_importances_`
- **Step 8:** Write down when I would use each algorithm, and why

## Examples
- **Practice (limit the tree):** Decision Tree with `max_depth=4` had CV AUC 0.847 (train 0.891), up from 0.776 with no limit
- **Mini challenge (drop Sex):** Random Forest AUC went from 0.864 to 0.755
- **Decision guide:** see `images/decision_guide.png` and the last section of the notebook

## My Decision Guide
- **Logistic Regression:** use it for a fast, explainable baseline or small data (AUC 0.851, smallest gap 0.009)
- **KNN:** use it for small data with few, scaled features (AUC 0.847, but gap 0.087)
- **Decision Tree:** use it when I need explainable rules, and limit the depth (depth 4 fixed most of the overfitting)
- **Random Forest:** use it as a strong default for tabular data (AUC 0.864, lowest std 0.020)
- **XGBoost:** use it for the last bit of accuracy when I can tune (AUC 0.866, but only 0.003 above Random Forest)
- **Rule:** start with Logistic Regression, then Random Forest, then XGBoost, and keep the complex model only if it beats the baseline by clearly more than the std

## Common Mistakes
- Comparing models with different preprocessing or different splits
- Ranking models by the mean alone and ignoring the std
- Using a bar chart with a cut-off axis without saying so (mine starts at 0.60, so differences look bigger than they are)
- Trusting one train/test split instead of cross-validation
- Reading feature importance as proof that a feature "causes" survival
- Assuming the best model on one dataset is best everywhere (Titanic is small, 891 rows)

## Interview Questions
- How would you fairly compare several algorithms on one dataset?
- Why report the std along with the mean AUC?
- What does a large gap between training and CV score tell you?
- Why do different tree-based models give different feature importances?
- When would you choose Logistic Regression over XGBoost?
- What is a baseline, and why should you always have one?

## Key Takeaways
- Same data, same preprocessing, same folds
- Read the std, and compare fold by fold
- The top four models were close, only the unlimited Decision Tree was clearly worse
- Overfitting gaps and feature importance add context that AUC alone hides
- Good features (like Sex) mattered more than the choice of model
- Start simple, add complexity only when it clearly pays off

## Summary
- Five algorithms, one dataset, one fair test
- XGBoost (0.866) and Random Forest (0.864) tied, Logistic Regression (0.851) was close behind
- I wrote my own decision guide from real results
- Models used mostly default settings, so tuning could change the ranking
- Day 75 is a buffer day to drill my weakest Phase 4 topics
