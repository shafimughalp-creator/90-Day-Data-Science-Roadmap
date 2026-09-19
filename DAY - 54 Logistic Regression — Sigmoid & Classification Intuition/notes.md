[notes.md](https://github.com/user-attachments/files/32416345/notes.md)
# Logistic Regression — Sigmoid & Classification Intuition

## Quick Overview
- **Topic:** Logistic Regression, the Sigmoid function, and decision boundaries
- **What I learned:** Why linear regression can't be used for classification, how sigmoid squashes any number into a valid probability, and how log loss (not MSE) is the right way to score classification errors.
- **Tools used:** Python, NumPy, Matplotlib, scikit-learn (`LogisticRegression`, `log_loss`)

## Introduction
Linear Regression predicts any real number — but a classification label is just 0 or 1. If you fit a straight line to 0/1 data, it can predict values below 0 or above 1, which makes no sense as a probability. Logistic Regression fixes this with the sigmoid function, which squashes any real number into the [0, 1] range.

## Definitions
- **Classification:** Predicting a discrete category (e.g. spam/not spam) instead of a continuous number.
- **Sigmoid function:** σ(z) = 1 / (1 + e⁻ᶻ) — maps any real number z to a value between 0 and 1.
- **Decision boundary:** The threshold (commonly 0.5) used to convert a probability into a class label.
- **Log loss (binary cross-entropy):** A loss function that heavily penalizes confident wrong predictions — the correct way to score classification, unlike MSE.

## Important Concepts
- Linear regression's output is unbounded; classification needs a bounded [0, 1] output — that's exactly what sigmoid gives you.
- The sigmoid curve is S-shaped: near 0 for very negative inputs, near 1 for very positive inputs, and 0.5 at z=0.
- The 0.5 threshold isn't fixed — it can be moved depending on whether false positives or false negatives are more costly.
- MSE treats all errors the same regardless of confidence; log loss punishes a confidently wrong prediction (e.g. predicting 0.99 when the true label is 0) far more than an unsure one.

## Step-by-Step Explanation
1. Understand why a straight line can't cleanly separate 0/1 labels.
2. Apply the sigmoid function to raw linear scores to get valid probabilities.
3. Plot the sigmoid curve to see the S-shape and the 0.5 midpoint.
4. Apply a threshold (default 0.5) to turn a probability into a predicted class.
5. Compare log loss vs MSE on the same predictions to see why log loss is used for classification.
6. Fit an actual `LogisticRegression` model and check accuracy + predicted probabilities.

## Examples
```python
import numpy as np
from sklearn.linear_model import LogisticRegression

def sigmoid(z):
    return 1 / (1 + np.exp(-z))

clf = LogisticRegression().fit(X_train, y_train)
print("Accuracy:", clf.score(X_test, y_test))
print(clf.predict_proba(X_test[:3]))
```

## Common Mistakes
- Using plain LinearRegression for a classification problem — outputs can go outside [0, 1].
- Assuming 0.5 is always the right decision threshold — it depends on the cost of false positives vs false negatives.
- Using MSE as the loss function for classification — it doesn't punish confident wrong predictions the way log loss does.
- Forgetting that `predict_proba` gives probabilities for both classes, not just the positive one.

## Interview Questions
1. Why can't you use plain linear regression for a classification problem?
2. What does the sigmoid function do, mathematically and intuitively?
3. What is a decision boundary, and how would you change it?
4. Why is log loss used instead of MSE for classification problems?
5. What happens to the sigmoid output as z → +∞ and as z → -∞?
6. What's the difference between `predict` and `predict_proba` in scikit-learn?

## Key Takeaways
- Logistic Regression = Linear Regression + sigmoid, used for classification.
- Sigmoid maps any real number into a valid [0, 1] probability.
- The decision boundary (default 0.5) converts a probability into a class label — and it's tunable.
- Log loss, not MSE, is the correct loss function for classification because it penalizes confident mistakes harder.

## Summary
Logistic Regression solves classification by first computing a linear score, then squashing it through the sigmoid function into a probability between 0 and 1. A decision boundary (usually 0.5) turns that probability into a class label. Because classification errors aren't scored the same way as regression errors, log loss — not MSE — is used to train and evaluate the model. These same sigmoid and log loss ideas reappear later in neural networks, which is why this is considered the "hello world" of classification.
