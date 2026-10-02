# Day 63: Hyperparameter Tuning — GridSearchCV

**Phase 4 · Machine Learning**  
**Dataset:** FC Lahore Lions matches (synthetic, `seed = 42`)

---

## 📌 Overview & Learning Objectives

This notebook demonstrates the theory and application of hyperparameter tuning using scikit-learn's `GridSearchCV`.

By the end of this module, you will understand:
- The distinction between **model parameters** and **hyperparameters**.
- How to define a parameter grid (`param_grid`) and execute a exhaustive grid search across hyperparameter space.
- How to evaluate tuning outputs: `best_params_`, `best_score_`, `cv_results_`, and the refitted `best_estimator_`.
- How to tune multi-step Machine Learning **Pipelines** using the standard `stepname__param` syntax.
- How to evaluate tuning results objectively while preventing test set contamination/data leakage.

---

## 💡 Key Theoretical Concepts

### 1. Parameters vs. Hyperparameters
* **Parameters:** Learned directly from the training data during the fitting process (e.g., weights/coefficients $\beta$ in Logistic Regression, decision tree split points).
* **Hyperparameters:** Configured prior to model training to control algorithm behavior (e.g., `max_depth` or `n_estimators` in Random Forest, $K$ in KNN, regularization strength $C$ in Logistic Regression).

### 2. How `GridSearchCV` Works
* **Grid Search:** Systematically evaluates every unique combination within a user-defined grid.
* **Cross-Validation Integration:** For each combination, it executes $K$-Fold cross-validation and records the mean test score across folds.
  $$\text{Total Fits} = (\text{Number of Parameter Combinations}) \times (\text{Number of Folds})$$
  *Example:* A $3 \times 3$ grid evaluated using $5$-fold CV requires **45 total fits** (plus $1$ final refit).
* **Automatic Refitting (`refit=True`):** Once searching finishes, `GridSearchCV` automatically trains the winning hyperparameter combination on the **entire training set**, storing the resulting model in `best_estimator_`.

### 3. Core Principles for Honest Model Evaluation
1. **Train-Set Only:** Perform hyperparameter search and cross-validation strictly on the training set. Never expose the test set to the tuning process.
2. **Single Final Test:** Use the held-out test set **once** at the very end to measure true generalization error.
3. **Optimism Bias:** `best_score_` represents the peak score across many attempts and may be slightly optimistic. If multiple configurations lie within 1 standard deviation ($\sigma$) of each other, differences in rank may simply be due to random variation.

### 4. Tuning Scikit-Learn Pipelines
* To tune hyperparameters within a `Pipeline` object (e.g., `StandardScaler` + classifier), reference specific step parameters using double underscores:
  $$\text{\texttt{<stepname>\_\_ <parameter>}}$$
  *Example:* `make_pipeline(StandardScaler(), LogisticRegression())` uses the grid key `'logisticregression__C'`.

---

## 🛠️ Code Implementation Walkthrough

### 1. Setup & Environment
```python
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import GridSearchCV, cross_val_score, train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler

plt.rcParams["axes.grid"] = True
