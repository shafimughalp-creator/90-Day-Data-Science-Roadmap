[notes.md](https://github.com/user-attachments/files/35216135/notes.md)
# Day 83: Project 2 — Business Insights + README

## Quick Overview
- **Topic:** Finishing Project 2 (Telco customer churn): confusion matrices at two thresholds, a business threshold, churn drivers, business insights, and the project README
- **What I learned:** The threshold is a business decision, not a model setting, and "importance" and "segments" are associations that need checking
- **Tools:** Python, pandas, scikit-learn (`confusion_matrix`, `classification_report`), XGBoost, matplotlib, Jupyter Notebook, Git
- **Deliverable:** `Customer_Churn_Prediction.zip`, a ready-to-push repo with 4 notebooks, `src/`, `outputs/`, `README.md`, `requirements.txt`, and `.gitignore`

## Introduction
- Days 80 to 82 built and tested the churn model. Today I asked: so what should the business do with it?
- Think of a smoke alarm: the alarm is one thing, deciding how sensitive to set it is another. Too sensitive, it rings for toast. Too weak, it misses a fire
- I set the rules before running anything, again to keep the test set honest

## Definitions
- **Confusion matrix:** a table of right and wrong predictions (true/false positives and negatives)
- **Classification report:** precision, recall, and F1 for each class
- **Decision threshold:** the score above which we flag a customer
- **Net benefit:** the money gained from catching churners minus the cost of the offers
- **Cumulative gains:** how many churners we reach if we contact customers in order of risk
- **Lift:** how many times higher a group's churn rate is than the overall rate
- **Segment:** a group of customers sharing some traits
- **Feature importance:** how much the model uses a feature (not the same as cause)

## The rules (set before running)
- The final model is the tuned XGBoost from notebook 03, trained on the training data only
- The business threshold is chosen on the **training** data (out-of-fold predictions), using cost assumptions written down first
- Customer segments are searched on the training data, then **checked** on the test data
- The test set is only used to report results

## Important Concepts
- **Cost assumptions (illustrative, replace with real numbers)**
  - A saved customer is worth $800, an offer costs $50, and an offer saves 30% of churners
  - So a caught churner is worth $240 on average, and a flag pays off if its chance of being a real churner is above about 21% (the overall churn rate is 26.5%)
- **Choosing the threshold (training out-of-fold)**
  - Best threshold: 0.46
  - The benefit curve is flat: every threshold from 0.39 to 0.49 is within 1% of the best
  - Net benefit per 1,000 customers: $31,521 at 0.46, $31,166 at 0.50, $13,685 if we flag everyone, $0 if we flag nobody
  - The scores are **not true probabilities**, because the class weight inflates them. A threshold of 0.46 does not mean a 46% chance of churn
- **The assumptions matter more than the exact threshold**
  - The best threshold changes a lot with the cost of an offer and its success rate (from about 0.10 for a very cheap offer to about 0.95 for a very expensive one)
  - Recall targets: recall of 80% needs threshold 0.51 (flags 41% of customers, precision 0.52), 90% needs 0.35 (flags 53%, precision 0.45), 95% needs 0.21 (flags 65%, precision 0.39)
- **Test set, threshold 0.50:** flagged 598 of 1,409 customers, TN 741, FP 294, FN 70, TP 304. Churn class: precision 0.508, recall 0.813, F1 0.626. Accuracy 0.742
- **Test set, threshold 0.46:** flagged 636, TN 714, FP 321, FN 59, TP 315. Churn class: precision 0.495, recall 0.842, F1 0.624. Accuracy 0.730
  - Lowering the threshold caught 11 more churners (315 vs 304) and raised 27 more false alarms (321 vs 294)
  - Accuracy fell (0.742 to 0.730) while recall rose, accuracy is not the goal here
  - Net benefit per 1,000 customers on the test set: $31,086 at 0.46, $30,561 at 0.50, $13,705 if we flag everyone
- **Cumulative gains (test set, overall churn rate 26.5%)**
  - Top 10% of customers by risk reach 27.8% of churners (group churn rate 74.3%)
  - Top 20% reach 49.7% (66.2%), top 30% reach 66.3% (58.8%), top 40% reach 77.5% (51.5%)
- **Churn drivers (XGBoost importance, with direction from Logistic Regression)**
  - Contract_Two year 0.261 (lowers risk), Contract_One year 0.164 (lowers), InternetService_Fiber optic 0.153 (raises), PaymentMethod_Electronic check 0.153 (raises), InternetService_No 0.070 (lowers), tenure 0.040 (lowers), OnlineSecurity 0.030 (lowers), PaperlessBilling 0.024 (raises), StreamingMovies 0.014 (raises), StreamingTV 0.013 (raises)
  - Grouped by original column: Contract 0.425, InternetService 0.223, PaymentMethod 0.155, tenure 0.040
  - Importance shows what the model **uses**, not what **causes** churn
- **The roadmap's example claim, tested on real data**
  - "Month-to-month, tenure under 6 months, charges over $70 churn about 3x more"
  - Training data: 410 customers, churn 72.9%, lift 2.75. Test data: 106 customers, churn 74.5%, lift 2.81. So the claim holds, at about 2.8x rather than exactly 3x
- **A wider segment search (training data only, then checked on test)**
  - Fiber optic + 0-5 months + electronic check: train 75.4% (325), test 79.1% (86)
  - Fiber optic + 0-5 months + no tech support: 75.0% (416), 77.4% (115)
  - Month-to-month + fiber optic + 0-5 months: 74.6% (453), 75.4% (122)
  - 0-5 months + over $70 + no tech support: 74.2% (365), 76.0% (100)
  - 0-5 months + over $70 + electronic check: 74.0% (292), 77.6% (76)
  - These five overlap a lot (all are slices of "new fiber customers"), and the test groups are small (76 to 122), so the rates are rough. I saw no drop on the test set

## Step-by-Step Explanation
- **Step 1:** Rebuild the final model and write down the cost assumptions
- **Step 2:** Get out-of-fold scores on the training data and sweep the threshold
- **Step 3:** Pick the threshold with the best expected net benefit, and see how it changes with the assumptions
- **Step 4:** On the test set, compare the confusion matrix and classification report at 0.50 and at the business threshold
- **Step 5:** Build a cumulative gains table (who to call first)
- **Step 6:** Show the drivers, with direction
- **Step 7:** Test the example claim and search for segments, checking on the test set
- **Step 8:** Write the README with the results, insights, and limits

## Examples
- **Practice (highest-risk customers):** the 5 highest-scoring test customers were all month-to-month, tenure 1 month, fiber optic, paying by electronic check, with monthly charges of $76 to $95, and all 5 did churn
- **Mini challenge (threshold for a recall target):** see the recall targets above

## README Checklist (what I included)
- Problem statement, dataset, approach, key findings
- Results tables (models, and thresholds on the test set) with the assumptions stated
- Business insights, labeled as associations
- Figures, with the most useful one (cumulative gains) at the top
- How to run, repo structure, limitations, and next steps

## GitHub: Push Checklist (you do this part)
```
cd Customer_Churn_Prediction
git init
git add .
git status            # check: no .csv files should be listed
git commit -m "Project 2: Telco customer churn prediction"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```
- Create an empty repo on GitHub first (no README, so there is no conflict)
- After pushing, check that the figures show in the README on GitHub
- Fill in the `[Add your name and LinkedIn link here]` line at the bottom of the README

## Common Mistakes
- Picking the threshold by looking at the test set
- Treating the model score as a true probability when class weights were used
- Using made-up costs without saying so
- Reading feature importance as cause
- Reporting segments found by searching without checking them on new data
- Judging a churn model by accuracy

## Interview Questions
- How would you choose a classification threshold for a business?
- What does a confusion matrix show that accuracy hides?
- What is a cumulative gains chart, and how would you use it?
- Why is feature importance not the same as cause?
- How did you check that your customer segments were not just noise?
- What would you need from the business to make the threshold decision properly?

## Key Takeaways
- The threshold is a business decision, so write down the costs and show how the answer changes
- A flat benefit curve means the exact threshold is not fragile, but the assumptions are what matter
- Rank customers by risk, and contact the top group first
- Importance and segments are associations, so check them and test them with experiments
- A good README, with honest limits, is part of the project

## Summary
- Compared the default threshold (0.50) with a business threshold (0.46), both fixed before looking at the test set
- Top 20% of customers by risk reach about half of all churners
- Contract type dominates what the model uses, and new fiber customers churn most
- The roadmap's example segment holds (about 2.8x), also on the test set
- Project 2 is packaged as a repo with a README, results tables, and honest limitations
- Next: Day 84 starts Project 3 (Customer Segmentation: EDA + Clustering)
