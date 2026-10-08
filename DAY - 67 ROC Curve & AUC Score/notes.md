[notes.md](https://github.com/user-attachments/files/33204319/notes.md)
# Day 67: ROC Curve & AUC Score

## Quick Overview
- **Topic:** Judging a classifier at every threshold using the ROC curve and AUC
- **What I learned:** ROC plots TPR vs FPR, AUC summarises it in one number, and Precision-Recall is the better check when positives are rare
- **Tools:** Python, pandas, scikit-learn (`roc_curve`, `roc_auc_score`, `precision_recall_curve`, `average_precision_score`), matplotlib, Jupyter Notebook

## Introduction
- A classifier usually outputs a **probability**, not just a yes/no
- We turn that probability into a class using a **threshold** (the default is 0.5)
- Accuracy at one threshold can hide how the model behaves at other thresholds
- The ROC curve checks **every** threshold at once
- AUC squeezes that whole curve into a single score

## Definitions
- **Threshold:** the cutoff that turns a probability into a class (e.g. 0.5)
- **TPR (True Positive Rate / Recall):** real positives the model caught
- **FPR (False Positive Rate):** real negatives the model wrongly flagged as positive
- **ROC curve:** a plot of TPR (y-axis) vs FPR (x-axis) across all thresholds
- **AUC:** Area Under the ROC Curve
- **Precision:** of everything flagged positive, how much was truly positive
- **Precision-Recall curve:** a plot of precision vs recall across all thresholds
- **Average Precision (AP):** area under the Precision-Recall curve
- **Imbalanced data:** one class is much rarer than the other

## Important Concepts
- **Use probabilities, not predictions**
  - Use `predict_proba(X_test)[:, 1]`
  - `predict()` gives only 0/1, so the curve would have almost no points
- **How to read the ROC curve**
  - Top-left corner = ideal (high TPR, low FPR)
  - The diagonal line = random guessing
  - Further above the diagonal = better model
- **How to read AUC**
  - 0.5 = random guessing
  - 1.0 = perfect
  - 0.7+ = generally useful
  - AUC does **not** depend on the 0.5 cutoff
- **Small test sets are noisy**
  - A random guess scored 0.481 here, not exactly 0.5
- **Precision-Recall for rare positives**
  - ROC uses FPR, which can look good when negatives are huge in number
  - PR focuses on the rare class directly
  - A random guess scores AP equal to the positive rate (0.11 here), not 0.5

## Step-by-Step Explanation
- **Step 1:** Split the data into train and test
- **Step 2:** Train a model that can give probabilities
- **Step 3:** Get scores with `predict_proba(X_test)[:, 1]`
- **Step 4:** Call `roc_curve(y_test, probs)` to get FPR, TPR, thresholds
- **Step 5:** Call `roc_auc_score(y_test, probs)` for the AUC
- **Step 6:** Plot several models on one chart to compare them
- **Step 7:** If positives are rare, also check `precision_recall_curve` and `average_precision_score`

## Examples
- **Probabilities (win model):** `[0.5, 0.89, 0.34, 0.63, 0.65]`
- **Thresholds table:** at threshold 0.93, FPR = 0.01 and TPR = 0.06 (very strict, catches few wins)
- **AUC:** Logistic Regression = 0.755, Random Forest = 0.742 (both above random, close to each other)
- **Random baseline:** random scores gave AUC 0.481
- **Rare target (red cards, 10.9% of matches):**
  - ROC AUC = 0.743
  - Average Precision = 0.264
  - Random AP baseline = 0.11
  - AP looks small, but it is about 2.4x the baseline

## Common Mistakes
- Passing `predict()` (0/1) into `roc_auc_score` instead of probabilities
- Thinking AUC above 0.5 always means "good" (0.7+ is a more useful guide)
- Judging a model on ROC AUC alone when positives are very rare
- Comparing AUC and AP numbers directly (they have different baselines)
- Trusting a small test set too much (scores can move a lot)

## Interview Questions
- What do the axes of a ROC curve represent?
- What does an AUC of 0.5 mean? What about 1.0?
- Why is AUC called threshold-independent?
- Why do we use `predict_proba` instead of `predict` for ROC?
- When would you prefer a Precision-Recall curve over a ROC curve?
- What is the baseline Average Precision of a random classifier?

## Key Takeaways
- ROC curve = TPR vs FPR at all thresholds
- AUC: 0.5 random, 1.0 perfect, 0.7+ generally useful
- Always feed probabilities, not class predictions
- Plot multiple models on one chart for a fair comparison
- Rare positives -> also check Precision-Recall and Average Precision

## Summary
- ROC and AUC tell us how well a model separates the two classes, no matter the threshold
- Precision-Recall is the better lens when the positive class is rare
- On the football data: win model AUC about 0.75, red-card model ROC AUC 0.743 but AP only 0.264
- Today's practice used a made-up football dataset (800 matches) in a Jupyter notebook
