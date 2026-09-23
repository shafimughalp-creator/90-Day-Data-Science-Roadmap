[day_55_logistic_regression_sklearn_metrics_notes.md](https://github.com/user-attachments/files/32549660/day_55_logistic_regression_sklearn_metrics_notes.md)
# Day 55: Logistic Regression — sklearn + Evaluation Metrics

## Quick Overview
- **Topic:** Fitting logistic regression in sklearn and judging it with a confusion matrix, precision, recall and F1.
- **What I learned:** Accuracy alone can mislead. Precision and recall show *which* mistakes the model makes, and the threshold trades one against the other.
- **Tools used:** Python, NumPy, pandas, Matplotlib, scikit-learn (`LogisticRegression`, `train_test_split`, `confusion_matrix`, `precision_score`, `recall_score`, `f1_score`).

## Introduction
- Day 54 was the idea (sigmoid, threshold, log loss). Day 55 is the practical version with sklearn.
- sklearn does the training. My job is to **split the data properly** and **evaluate the model honestly**.
- Dataset: 300 synthetic FC Lahore Lions matches (`seed = 42`) with `shots_on_target`, `possession_pct` and `won` (1 = win, 0 = no win).
- Split: 225 training rows, 75 test rows, using `stratify=y` so both parts keep a similar win rate.

## Definitions
- **`.fit(X_train, y_train)`:** learns the weights from the training data.
- **`.predict(X_test)`:** returns predicted classes (0 or 1).
- **`.predict_proba(X_test)`:** returns probabilities. Column 0 = P(class 0), column 1 = P(class 1).
- **Confusion matrix:** a 2x2 table counting correct and wrong predictions.
- **TP (true positive):** predicted win, was a win.
- **TN (true negative):** predicted no win, was no win.
- **FP (false positive):** predicted win, was not a win (false alarm).
- **FN (false negative):** predicted no win, was a win (missed case).
- **Precision:** `TP / (TP + FP)`.
- **Recall:** `TP / (TP + FN)`.
- **F1 score:** the harmonic mean of precision and recall.
- **Accuracy:** `(TP + TN) / total predictions`.

## Important Concepts
- **Fit on train, judge on test**
  - The model only ever learns from `X_train` and `y_train`.
  - Metrics are calculated on `X_test`, data it has never seen (same idea as Day 49).
- **predict vs predict_proba**
  - `predict()` is just `P(win) > 0.5` from Day 54. I checked this in code and it matched.
  - `predict_proba()` keeps the probabilities so I can choose my own threshold.
- **Reading the confusion matrix in sklearn**
  - Rows are **actual** classes, columns are **predicted** classes.
  - `cm.ravel()` unpacks it in the order `TN, FP, FN, TP`.
- **Precision vs recall**
  - Precision asks: of the wins I *called*, how many were real?
  - Recall asks: of the real wins, how many did I *catch*?
  - Football picture: precision is shot accuracy, recall is chance conversion.
- **F1** is one number that only stays high when both precision and recall are high.
- **The accuracy trap**
  - With only 5 hat-tricks in 100 matches, a lazy model that always says "no hat-trick" gets 95% accuracy and 0 recall.
  - On rare events, accuracy hides the failure.
- **Threshold trade-off**
  - Lower threshold: more positives predicted, recall goes up, precision goes down.
  - Higher threshold: fewer positives predicted, precision stays high, recall goes down.
- **Which metric matters?**
  - **Cancer detection:** missing a real case is terrible, so favour **high recall**.
  - **Spam filter:** marking a good email as spam is annoying, so favour **high precision**.

## Step-by-Step Explanation
- **Step 1:** Load the data and pick features (`X`) and the target (`y`).
- **Step 2:** `train_test_split(..., test_size=0.25, random_state=42, stratify=y)`.
- **Step 3:** `model = LogisticRegression()` then `model.fit(X_train, y_train)`.
- **Step 4:** `y_pred = model.predict(X_test)` and `proba = model.predict_proba(X_test)`.
- **Step 5:** Draw the 2x2 grid on paper, then `confusion_matrix(y_test, y_pred)`.
- **Step 6:** Calculate `precision_score`, `recall_score`, `f1_score`.
- **Step 7:** Try other thresholds on `proba[:, 1]` and see how precision and recall move.

## Examples
- **Confusion matrix on the 75 test matches:** `TN = 30`, `FP = 5`, `FN = 7`, `TP = 33`.
- **Metrics at threshold 0.5:** precision `0.868`, recall `0.825`, F1 `0.846`. The by-hand formulas gave the same numbers.
- **Accuracy trap:** a model that always predicts "no hat-trick" scores accuracy `0.95` and recall `0.0`.
- **Threshold table:**

  | Threshold | Precision | Recall |
  |-----------|-----------|--------|
  | 0.3 | 0.77 | 0.93 |
  | 0.5 | 0.87 | 0.82 |
  | 0.7 | 0.87 | 0.68 |

- **Screening challenge:** the highest threshold that still keeps recall at 0.90 or more was `0.35`, at a precision of `0.818`.
- **Learned weights:** shots on target `0.608`, possession `0.064`, bias `-6.697`. Shots on target carries more weight, but the features are on different scales, so this is not a full importance ranking.

## Common Mistakes
- Judging a classifier by accuracy alone, especially on rare events.
- Mixing up the matrix layout: in sklearn, rows are actual and columns are predicted.
- Confusing precision and recall. Precision looks at *predicted* positives, recall looks at *actual* positives.
- Fitting or scoring on the training data and reporting that as performance.
- Assuming 0.5 is always the right threshold.
- Reading model weights as feature importance when features are on different scales.
- Trusting one small test set too much. 75 rows is a small sample.

## Interview Questions
- What is a confusion matrix? Explain TP, TN, FP, FN.
- Define precision and recall in one sentence each.
- Why can accuracy be misleading? Give an example.
- When would you prefer high recall? High precision?
- What does F1 measure and why use it?
- What is the difference between `predict()` and `predict_proba()`?
- How does changing the threshold affect precision and recall?
- Why do we evaluate on a test set instead of the training set?

## Key Takeaways
- `.fit()` on train data, `.predict()` and `.predict_proba()` on test data.
- The confusion matrix is the foundation of every classification metric.
- Precision and recall answer different questions, and both are needed.
- Accuracy can look great while the model finds nothing.
- The threshold is a decision about which mistake costs more.

## Summary
- Logistic regression in sklearn is `LogisticRegression().fit(X_train, y_train)` followed by `.predict()` or `.predict_proba()`.
- On 75 test matches: 33 wins caught, 7 missed, 5 false alarms, giving precision 0.87, recall 0.82 and F1 0.85.
- A lazy model on rare events can score 95% accuracy with 0 recall.
- Lowering the threshold to 0.3 raised recall to 0.93 and dropped precision to 0.77.
- **Next: Day 56.** KNN and distance-based intuition.
