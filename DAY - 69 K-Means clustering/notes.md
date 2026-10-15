[Uploading notes.md…]()
# Day 69: K-Means Clustering — Unsupervised Learning

## Quick Overview
- **Topic:** Finding natural groups in data with K-Means, with no target label
- **What I learned:** K-Means repeats "assign to nearest centroid, then move the centroid" until nothing changes, and the elbow method helps pick K
- **Tools:** Python, pandas, NumPy, scikit-learn (`KMeans`, `StandardScaler`, `silhouette_score`), matplotlib, Jupyter Notebook

## Introduction
- So far, almost every model had a target column `y` to predict
- Clustering has **no** `y`: the model looks for groups on its own
- Example: sorting football players into groups using only their stats
- Think of a teacher sorting students into study groups by how they behave, without being told the "right" groups

## Definitions
- **Unsupervised learning:** learning from data without labels
- **Clustering:** grouping similar rows together
- **Centroid:** the center point of a cluster (the average of its members)
- **K:** the number of clusters we ask for
- **Inertia:** sum of squared distances from points to their centroid (lower = tighter clusters)
- **Elbow method:** plot inertia for several K values and look for the bend
- **k-means++:** a smarter way to pick the starting centroids by spreading them out
- **Silhouette score:** how well separated the clusters are (higher is better)

## Important Concepts
- **The K-Means algorithm**
  - Pick K starting centroids
  - Assign every point to its nearest centroid
  - Move each centroid to the mean of its points
  - Repeat until the centroids stop moving
  - My by-hand version converged after 8 iterations
- **Scale first**
  - K-Means uses distance
  - `passes_per_90` (about 40) would swamp `goals_per_90` (about 0.2) without `StandardScaler`
- **Inertia always drops as K grows**
  - K=1: 1200.0, K=2: 640.9, K=3: 389.0, K=4: 334.1
  - So the lowest inertia is not the goal, the **bend** is
  - The big drop stops after K=3
- **k-means++ vs random start**
  - Over 20 single runs: mean inertia 398.8 (k-means++) vs 408.5 (random)
  - The worst case was the same (584.6), so on easy data the gain is small
  - k-means++ is the sklearn default and is a safe choice
- **Check the clusters mean something**
  - Cluster 0 (goals 0.53, tackles 0.84) looks like forwards
  - Cluster 1 (passes 55.18) looks like midfielders
  - Cluster 2 (tackles 3.15) looks like defenders

## Step-by-Step Explanation
- **Step 1:** Choose numeric feature columns
- **Step 2:** Scale them with `StandardScaler`
- **Step 3:** Create `KMeans(n_clusters=3, init="k-means++", n_init=10, random_state=42)`
- **Step 4:** Call `.fit_predict(X)` to get a cluster number for each row
- **Step 5:** Look at the average stats per cluster to understand them
- **Step 6:** Use the elbow method (and silhouette score) to test other K values

## Examples
- **Clusters found:** sizes 90, 104, 106 with inertia 389.0
- **Check against hidden real positions:**
  - Cluster 0 = 90 Forwards (all 90)
  - Cluster 1 = 104 Midfielders
  - Cluster 2 = 100 Defenders + 6 Midfielders
  - Only 6 of 300 players landed in a different group than their real position
- **Silhouette scores:** K=2: 0.452, K=3: 0.446, K=4: 0.388, K=5: 0.340, K=6: 0.276
  - K=2 and K=3 are almost tied, so here the metrics do not give one clear winner
- **Practice (K=4):** inertia 334.1, lower than K=3 (389.0), but lower is not always better

## Common Mistakes
- Forgetting to scale the features
- Picking K only because inertia gets smaller (it always does)
- Treating the elbow as exact (the bend can be unclear)
- Assuming clusters are "real" groups without checking what they contain
- Using K-Means on categorical columns (it needs numbers and distances)
- Trusting a single random start (use `n_init` and a fixed `random_state`)

## Interview Questions
- What is the difference between supervised and unsupervised learning?
- Walk through the steps of the K-Means algorithm
- What is inertia, and why can't we just minimize it?
- How does the elbow method work?
- Why is feature scaling important for K-Means?
- What problem does k-means++ solve?
- What is a weakness of K-Means? (you must choose K, it likes round clusters of similar size)

## Key Takeaways
- Clustering finds groups with no labels
- K-Means = assign, move, repeat
- Always scale before clustering
- Elbow method and silhouette score help choose K
- k-means++ gives safer starting points
- Always inspect what each cluster actually contains

## Summary
- K-Means grouped 300 football players into 3 clusters using only 4 stats
- The clusters matched real positions for 294 of 300 players
- The elbow pointed to K=3, while silhouette was nearly tied between K=2 and K=3
- Today's practice used a made-up football dataset in a Jupyter notebook (the real positions were kept hidden until the final check)
