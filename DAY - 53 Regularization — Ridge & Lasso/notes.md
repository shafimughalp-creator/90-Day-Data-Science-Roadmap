[notes.md](https://github.com/user-attachments/files/32416298/notes.md)
# Regularization — Ridge & Lasso

## Quick Overview
- **Topic:** Regularization (Ridge & Lasso Regression)
- **What I learned:** How adding a penalty term to a model's cost function stops overfitting, and the difference between Ridge (shrinks weights) and Lasso (can zero them out).
- **Tools used:** Python, scikit-learn (`Ridge`, `Lasso`, `LinearRegression`)

## Introduction
Plain Linear Regression has one job: minimize the error between predictions and actual values. But when features are correlated, or there are too many of them relative to the data, the model overfits — it memorizes the training data instead of learning a general pattern. Regularization fixes this by punishing the model for having overly large weights.

## Definitions
- **Overfitting:** Model performs great on training data but poorly on new (test) data.
- **Regularization:** Adding a penalty term to the cost function that discourages large weights.
- **Ridge Regression (L2):** Penalty = λ × Σ(w²) — shrinks all weights toward zero, but rarely to exactly zero.
- **Lasso Regression (L1):** Penalty = λ × Σ|w| — can shrink some weights all the way to zero, effectively removing those features.
- **Lambda (λ) / alpha:** The regularization strength. Higher λ = stronger penalty = simpler model.

## Important Concepts
- Regularization trades a bit of training accuracy for much better generalization on unseen data.
- Ridge keeps every feature in the model — good when you believe all features matter somewhat.
- Lasso can perform automatic feature selection — good when you suspect many features are irrelevant.
- Both need feature scaling first (e.g. `StandardScaler`), since the penalty term is sensitive to the scale of the weights.
- Alpha/λ is a hyperparameter — too high underfits, too low barely regularizes at all.

## Step-by-Step Explanation
1. Split data into train/test sets.
2. Scale the features so all coefficients are penalized fairly.
3. Fit a plain `LinearRegression` as a baseline — check the train vs test R² gap.
4. Fit `Ridge(alpha=...)` — compare coefficients and R² to the baseline.
5. Fit `Lasso(alpha=...)` — check which coefficients became exactly zero.
6. Try a few different alpha values to see how the coefficients shrink as alpha increases.

## Examples
```python
from sklearn.linear_model import LinearRegression, Ridge, Lasso

lr = LinearRegression().fit(X_train, y_train)
ridge = Ridge(alpha=1.0).fit(X_train, y_train)
lasso = Lasso(alpha=0.5).fit(X_train, y_train)

print("LinearRegression:", lr.score(X_test, y_test))
print("Ridge:", ridge.score(X_test, y_test))
print("Lasso:", lasso.score(X_test, y_test))
```

## Common Mistakes
- Forgetting to scale features before fitting Ridge/Lasso — the penalty punishes large-scale features unfairly.
- Assuming a higher alpha is always better — too high underfits the data.
- Confusing Ridge and Lasso — remember: **L**asso **L**oses features (zeroes them out), Ridge just shrinks.
- Not comparing against a plain LinearRegression baseline, so you can't tell if regularization actually helped.

## Interview Questions
1. What is the difference between L1 and L2 regularization?
2. Why does Lasso produce sparse (zero) coefficients but Ridge doesn't?
3. What happens if alpha/λ is set too high? Too low?
4. When would you choose Lasso over Ridge, and vice versa?
5. Why is feature scaling important before applying regularization?
6. What is Elastic Net, and how does it relate to Ridge and Lasso?

## Key Takeaways
- Regularization = penalty on the cost function to prevent overfitting.
- Ridge (L2) shrinks all weights, keeps all features.
- Lasso (L1) can zero out weights, doing automatic feature selection.
- Always scale features first and compare against a plain LinearRegression baseline.

## Summary
Regularization is the fix for overfitting in linear models. Ridge and Lasso both add a penalty to the cost function, but Ridge shrinks weights smoothly (L2) while Lasso can eliminate features entirely (L1). Picking between them — and tuning alpha — is one of the most commonly tested concepts in ML interviews.
