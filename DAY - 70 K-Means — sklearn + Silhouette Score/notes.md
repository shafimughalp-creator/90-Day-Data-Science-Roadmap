[notes.md](https://github.com/user-attachments/files/33628792/notes.md)
# Day 70: K-Means — sklearn + Silhouette Score

## Quick Overview
- **Topic:** Clustering customers with K-Means and judging the clusters with the silhouette score
- **What I learned:** Silhouette score (-1 to +1) tells how well separated clusters are, and a scatter plot plus cluster averages turn clusters into business stories
- **Tools:** Python, pandas, scikit-learn (`KMeans`, `StandardScaler`, `silhouette_score`, `silhouette_samples`), matplotlib, Jupyter Notebook
- **Data note:** `dataset.csv` is a made-up lookalike of the Mall Customers data (200 customers, same column names), built with 5 hidden customer groups

## Introduction
- Yesterday I found clusters and picked K with the elbow method
- The elbow can be hard to read, so today I added a second opinion: the **silhouette score**
- It answers: "Are these clusters actually well separated, or just drawn on the data?"
- Then I turned the clusters into plain business groups, like a marketing team would

## Definitions
- **Cluster:** a group of similar customers
- **Silhouette score (one point):** how well that point fits its own cluster compared with the nearest other cluster
- **Silhouette score (overall):** the average over all points
- **a:** average distance to points in the same cluster
- **b:** average distance to points in the nearest other cluster
- **Customer segment:** a cluster described in business words
- **Centroid:** the center of a cluster

## Important Concepts
- **How to read the score**
  - Close to +1: the point sits well inside its cluster
  - Close to 0: the point is on the border between two clusters
  - Negative: the point may be in the wrong cluster
  - 0.5 and above: clusters are usually meaningful
- **Silhouette vs inertia**
  - Inertia always drops as K grows
  - Silhouette goes up **and down**, so it can point to a best K
  - My scores: K=2 0.340, K=3 0.481, K=4 0.527, **K=5 0.605**, K=6 0.498, K=7 0.469, K=8 0.412
- **Per-cluster check**
  - Cluster averages ranged from 0.564 to 0.655, and no customer had a negative score
  - The weakest cluster was the biggest one: mid income, average spender (0.564)
- **Always scale**
  - When I wrote income in dollars instead of thousands, the clusters changed a lot
  - Agreement with the scaled clusters was only 0.447 (1.0 would mean identical)
- **More features is not always better**
  - Adding `Age` dropped the silhouette from 0.605 to 0.403 (age overlapped the groups in my data)

## Step-by-Step Explanation
- **Step 1:** Pick the feature columns (income and spending score)
- **Step 2:** Scale them with `StandardScaler`
- **Step 3:** Run `KMeans(n_clusters=5, n_init=10, random_state=42).fit_predict(X_scaled)`
- **Step 4:** Check `silhouette_score(X_scaled, labels)`
- **Step 5:** Repeat for K = 2 to 8 and compare scores
- **Step 6:** Plot the clusters (income on x, spending on y, color by cluster)
- **Step 7:** Take each cluster's average income, spending, and age, and give it a business name

## Examples
- **Cluster sizes:** 34, 83, 38, 22, 23
- **Overall silhouette (K=5):** 0.605
- **Business segments found**
  - Low income, high spender (22 customers)
  - Low income, low spender (23 customers)
  - Mid income, average spender (83 customers)
  - High income, high spender (38 customers)
  - High income, low spender (34 customers)
- **Business ideas (my interpretation)**
  - High income, high spender: loyalty or VIP offers
  - High income, low spender: the biggest opportunity, they can afford more but are not buying
  - Low income, high spender: budget-friendly deals and installment offers
  - Low income, low spender: low priority, keep marketing cost small
- **Border customers (lowest silhouette):** customers 63 and 14 have mid income but spend a lot (scores 79 and 77), so they sit between the "average" and "high spender" groups

## Common Mistakes
- Skipping `StandardScaler`
- Trusting the elbow alone, or the silhouette alone
- Assuming a high silhouette means the clusters are useful for business (it only means they are well separated)
- Adding every column as a feature without checking if the score gets worse
- Forgetting that this data is made up with 5 groups, so K=5 winning is **by design**, and real data is usually messier

## Interview Questions
- What does a silhouette score of 0 mean?
- What do `a` and `b` stand for in the silhouette formula?
- Why can silhouette pick a K, while inertia cannot?
- What does a negative silhouette value mean for a single point?
- Why do we scale features before K-Means?
- How would you explain a cluster to a marketing manager?

## Key Takeaways
- Scale, then `fit_predict`
- Silhouette: -1 to +1, higher is better, 0.5+ is meaningful
- Compare silhouette across K, then check the elbow and common sense
- Scatter plots and cluster averages give clusters their meaning
- Name segments in business words, not cluster numbers

## Summary
- K=5 gave the best silhouette (0.605) on the customer data
- The weakest cluster was the large "average" group, where border customers live
- Wrong scaling or extra features can change the result a lot
- Today's practice used a made-up Mall-style dataset in a Jupyter notebook
