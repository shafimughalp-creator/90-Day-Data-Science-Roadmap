[Uploading notes.md…]()
# Day 75: Phase 4 Buffer — Drill Your Weak Spots

## Quick Overview
- **Topic:** Review day for Phase 4 (Machine Learning, Days 48 to 75)
- **What I did:** Redid two weak concepts on new datasets, wrote out-loud interview answers, built a Kaggle-style Random Forest baseline, and organized a clean Phase 4 repo
- **Tools:** Python, pandas, scikit-learn, matplotlib, Jupyter Notebook, Git
- **Data note (all in `data/`):** real breast cancer data (downsampled so cancer is rare, 30 of 387 rows), real diabetes data, and the real Titanic training data

## Introduction
- Phase 4 was dense: 28 days of algorithms, metrics, pipelines, and review
- A buffer day is for going back to the topics that were shaky and testing them again on new data
- I picked the two topics that behaved most surprisingly in my earlier results:
  - **Precision vs recall** (and threshold choice)
  - **Bias vs variance** (and overfitting)

## Definitions
- **Precision:** of the cases I flagged, how many were truly positive
- **Recall:** of the truly positive cases, how many I caught
- **Threshold:** the probability cutoff that turns a score into a yes/no
- **Average Precision (AP):** the area under the precision-recall curve
- **Bias:** error from a model that is too simple (underfitting)
- **Variance:** error from a model that is too sensitive to the training data (overfitting)
- **R2:** how much better a model is than always predicting the average (1 is perfect, below 0 is worse than the average)
- **Ridge regression:** linear regression with a penalty that shrinks large weights (lowers variance)
- **Submission file:** the CSV a Kaggle competition expects (`PassengerId`, `Survived`)

## Important Concepts
- **Weak spot A: precision vs recall (breast cancer, malignant = 7.8% of rows)**
  - "Always say benign" is already 0.922 accurate
  - The model's accuracy was 0.979, but at threshold 0.5 it caught only 23 of 30 cancers
  - Threshold 0.5: precision 0.958, recall 0.767, 24 flagged
  - Threshold 0.3: precision 0.962, recall 0.833, 26 flagged
  - Threshold 0.1: precision 0.718, recall 0.933, 39 flagged
  - So lowering the threshold caught more cancers but made more false alarms
  - ROC AUC was 0.956 and Average Precision 0.913 (a random guess scores 0.078)
  - On this well-separated data both scores agree, unlike my Day 67 weaker model, where AP was much lower than ROC AUC
- **Weak spot B: bias-variance (diabetes, 5-fold CV)**
  - Degree 1 (straight line): train R2 0.520, CV R2 0.478
  - Degree 2: train R2 0.609, CV R2 0.366
  - Degree 3: train R2 0.880, CV R2 -42.933
  - Higher training score but worse CV score = variance (overfitting)
  - A CV R2 of -42.9 means a few folds were wildly wrong, far worse than predicting the average
  - Ridge on degree 3: alpha 1 gave CV -0.828, alpha 10 gave -0.025, alpha 100 gave 0.327, alpha 1000 gave 0.383
  - Regularization rescued the complex model, but it never beat the simple line (0.478)
- **Kaggle-style baseline**
  - Random Forest inside a pipeline (impute, scale, one-hot, model)
  - 5-fold CV AUC 0.855 +/- 0.039, hold-out accuracy 0.816
  - A `make_submission` function writes `PassengerId` and `Survived` to a CSV
  - **Honest limit:** I could not download the competition `test.csv` or submit from here, so `submission_example.csv` is a format example built from a held-out 20% of the training rows

## Interview Prep: Say It Out Loud
Practice each one out loud, with a timer. If you stumble, write down where and try again.

**Bias vs variance (about 40 seconds)**
- Bias is error from a model that is too simple. It misses the real pattern, like a straight line through a curve
- Variance is error from a model that is too sensitive to its training data, like memorizing answers
- Simple = high bias, low variance. Complex = low bias, high variance. I want the middle
- Check: compare train score with CV score. Both low = bias. Train high, CV low = variance
- Example: on diabetes data, a line got CV R2 0.478, while degree 3 got 0.88 on training but -42.9 in CV

**Precision vs recall (about 40 seconds)**
- Precision: of everything I flagged, how much was really positive
- Recall: of everything really positive, how much did I catch
- Smoke alarm: high recall = rarely misses a fire, high precision = rarely rings for nothing
- Lowering the threshold raises recall and lowers precision
- Cancer screening cares most about recall, a spam filter cares most about precision
- Example: threshold 0.5 gave precision 0.958 and recall 0.767, threshold 0.1 gave 0.718 and 0.933

**Self-test (answer without looking)**
- Why can 98% accuracy be a bad result?
- What does a train score of 0.88 with a CV score of -42.9 tell you?
- To catch more positives, do you raise or lower the threshold?
- What is the AP of a random guess, and why?

## Step-by-Step Explanation
- **Step 1:** Pick two weak topics and a new dataset for each
- **Step 2:** Get out-of-fold predictions with `cross_val_predict` so every row is scored fairly
- **Step 3:** Compare accuracy with a "do nothing" baseline
- **Step 4:** Sweep the threshold and watch precision and recall move
- **Step 5:** Sweep model complexity and compare train vs CV scores
- **Step 6:** Add regularization and see if variance drops
- **Step 7:** Build a pipeline model and a function that writes the submission file
- **Step 8:** Organize the repo and write the README

## GitHub: Phase 4 Repo
- Bundle: `Phase_4_ML_Repo.zip` (README, requirements, .gitignore, and my Day 66 to 75 folders)
- Days 48 to 65 are not in the bundle, they need to be added to the same repo
- Before pushing, restart the kernel and Run All in each notebook
- Commands:
  - `git init`
  - `git add .`
  - `git commit -m "Phase 4: Machine Learning notebooks, Days 48-75"`
  - `git branch -M main`
  - `git remote add origin <your-repo-url>`
  - `git push -u origin main`

## Common Mistakes
- Trusting accuracy when one class is rare
- Using only the default 0.5 threshold without thinking about the cost of each mistake
- Assuming a more complex model is a better model
- Judging a model on its training score
- Calling a Kaggle workflow "submitted" before actually uploading the file
- Pushing notebooks with stale outputs or no README

## Interview Questions
- Explain the bias-variance tradeoff in plain words
- Explain precision and recall with an example
- When would you lower the classification threshold?
- How do you detect overfitting?
- How does regularization reduce variance?
- Walk me through a pipeline from raw data to a submission file

## Key Takeaways
- Accuracy can hide the real story, check precision, recall, and a baseline
- The threshold is a business decision, not a fixed number
- Train-vs-CV gaps show overfitting
- Simpler models often win on small data
- Regularization helps, but it is not magic
- A clean repo and README are part of the work

## Summary
- Redid precision/recall and bias-variance on new datasets, with real numbers
- Wrote 40-second out-loud explanations for both
- Built a Random Forest baseline and a submission function (real Kaggle submission still to do)
- Packaged Phase 4 into one clean repo structure
- Next: Day 76 starts Phase 5 with Project 1, Sales Prediction (Problem + EDA)
