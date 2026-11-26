[Uploading notes.md…]()
# Day 84: Project 3 — Customer Segmentation: EDA + Clustering

## Quick Overview
- **Topic:** Starting Project 3: check and explore the Mall Customers data, scale it, and use the elbow method to choose K for K-Means
- **What I learned:** The elbow is a judgment call. It was clear with two columns and gentle with three, so I cross-checked it with the silhouette score and with resampling
- **Tools:** Python, pandas, seaborn, matplotlib, scikit-learn (`StandardScaler`, `KMeans`, `silhouette_score`, `adjusted_rand_score`), Jupyter Notebook
- **Data note:** the Mall Customers sample dataset (200 customers). The raw file is not in this folder, see `data/README.md`
- **Code:** `segmentation_data.py` (loading and scaling, reused on Day 85)
- **Run with:** scikit-learn 1.9, pandas 3.0, seaborn 0.13

## Introduction
- Projects 1 and 2 had a target to predict. Project 3 has none: this is **clustering**, so nobody tells us the right answer
- The goal is to find groups of customers a marketing team could treat differently
- Day 84 prepares the data and picks K. Day 85 fits K-Means, draws the PCA picture and profiles the clusters
- Today I did not look at what the clusters contain. Clustering was used only to choose K, so there are no cluster names yet

## Definitions
- **Clustering:** grouping similar rows without a target column (unsupervised learning)
- **K-Means:** pick K centers, assign each customer to the nearest center, move each center to the middle of its group, repeat
- **Inertia:** total squared distance from each customer to its own center. It always falls as K grows
- **Elbow method:** plot inertia against K and look for the bend where extra clusters stop paying off
- **Silhouette score:** from -1 to 1, how well separated the clusters are (higher is better)
- **`n_init`:** how many random starts K-Means tries. It keeps the best one
- **Adjusted Rand index (ARI):** how similar two groupings are. 1.0 = identical, 0 = no more alike than random
- **IQR rule:** a value is an outlier if it is more than 1.5 x IQR beyond the quartiles
- **Bootstrap:** resample the data with replacement many times to see how much a result moves

## Important Concepts
- **The data is clean**
  - 200 rows, 5 columns. No missing values, no duplicate rows, no repeated CustomerID
  - Age 18 to 70, Annual Income 15 to 137 (k$), Spending Score 1 to 99
  - Gender: 112 female, 88 male. It is a label, not a number, so it does not go into K-Means
  - The Spending Score is a score the mall assigned (1 to 100), not money spent
- **EDA, one column at a time**

  | Column | Mean | Median | Std | Skew | IQR outliers |
  |---|---|---|---|---|---|
  | Age | 38.9 | 36.0 | 14.0 | 0.49 | 0 |
  | Income | 60.6 | 61.5 | 26.3 | 0.32 | 2 |
  | Spending | 50.2 | 50.0 | 25.8 | -0.05 | 0 |

  - Age leans young. Income has two outliers (both 137k, CustomerID 199 and 200). I kept them: only 2 of 200. Spending covers the whole range with a peak around 40 to 60
- **EDA, how columns relate**
  - Age and Spending: r = -0.33 (younger customers tend to have higher spending scores)
  - Age and Income: r = -0.01. Income and Spending: r = 0.01
  - The Income vs Spending scatter shows visible clumps. This is a hint, not a result
  - Gender: average spending score is 51.5 for women and 48.5 for men. The difference is +3.0 with a 95% bootstrap interval of -4.3 to +10.4, which includes 0, so there is no clear gap. Gender also does not separate anything in the scatter plots
- **Scaling**
  - K-Means works with distances, so `StandardScaler` puts Age, Income and Spending on one scale (mean 0, std 1)
  - Clustering has no train/test split, so the scaler is fitted on all 200 customers
  - Scaling changed the K = 5 groups: agreement between the scaled and unscaled groupings was 0.60 (ARI), not 1.0
  - The effect is moderate because the raw spreads were already similar (14.0, 26.3, 25.8). Without scaling, Age (the narrowest) has less say. On other data the effect can be much larger
- **The elbow, K = 2 to 10**

  | K | Inertia, all three columns | Drop vs previous | Inertia, Income + Spending | Drop vs previous |
  |---|---|---|---|---|
  | 2 | 389.4 | | 269.7 | |
  | 3 | 295.2 | 24% | 157.7 | 42% |
  | 4 | 205.2 | 30% | 108.9 | 31% |
  | 5 | 168.2 | 18% | 65.6 | 40% |
  | 6 | 133.9 | 20% | 55.1 | 16% |
  | 7 | 117.0 | 13% | 44.9 | 19% |

  - **Income + Spending only:** a clear elbow at K = 5 (a 40% drop into K = 5, then only 16%)
  - **All three columns (the plan):** no sharp elbow. The bend is somewhere between K = 4 and K = 6. The "furthest from the straight line" rule picks K = 4 on the full data
- **Cross-check 1: silhouette**
  - Income + Spending: highest at K = 5 (0.555), with K = 6 close (0.540)
  - All three columns: flat. K = 4 gives 0.404, K = 5 gives 0.417, K = 6 gives 0.428 (the top), and every K from 4 to 10 stays between 0.40 and 0.43
- **Cross-check 2: random starts**
  - With `n_init=1`, the K = 5 inertia over 20 random seeds ranged from 168.2 to 194.4. A single start was worse than the best solution in 9 of 20 seeds
  - With `n_init=10`, all 20 seeds gave 168.2. I use `n_init=10` and a fixed `random_state`
- **Cross-check 3: how stable is the K choice? (Mini Challenge)**
  - Resample the 200 customers 30 times, redo the elbow each time, and count the K picked by the straight-line rule
  - All three columns: K = 5 in 16 of 30, K = 4 in 11 of 30, K = 6 in 3 of 30
  - Income + Spending: K = 5 in 29 of 30, K = 4 in 1 of 30
- **Decision: K = 5 goes into Day 85, with K = 4 and K = 6 as side checks**
  - It is the clearest elbow on Income + Spending and the most common pick across resamples with three columns
  - No cluster is tiny at K = 5 (sizes 54, 47, 40, 39, 20; the smallest is 10% of customers)
  - With three columns the evidence is weak, so on Day 85 the clusters need to make sense, not just be assumed right

## Step-by-Step Explanation
- **Step 1:** Load the data with `load_mall()` (the `data/` folder if the file is there, otherwise a public download) and rename the columns
- **Step 2:** Run data quality checks: missing values, duplicates, ranges, counts
- **Step 3:** Draw a histogram and a boxplot for each numeric column and apply the IQR rule
- **Step 4:** Check correlations and scatter plots, and ask whether Gender is useful
- **Step 5:** Scale the numeric columns with `StandardScaler` and check that scaling changes the groups
- **Step 6:** Run K-Means for K = 2 to 10 with `init="k-means++"`, `n_init=10`, `random_state=42` and plot the inertia
- **Step 7:** Cross-check with the silhouette score, random starts and resampling
- **Step 8:** Pick a K, say how sure I am, and write down what to check next

## Examples
- **Reading the elbow:** with two columns, inertia falls 40% going from K = 4 to K = 5 and only 16% from K = 5 to K = 6, so the bend is at 5. With three columns the drops are 30%, 18%, 20%, 13%, so there is no single obvious bend
- **Reading the silhouette:** with three columns the scores for K = 4 to 10 are all within 0.03 of each other, so silhouette cannot choose a K here
- **Reading the stability check:** "the elbow rule picked K = 5 in 16 of 30 resamples" means K = 5 is the most common answer, but far from certain

## Common Mistakes
- Clustering without scaling
- Fitting K-Means once with one random start and trusting the result (`n_init` matters)
- Treating the elbow as exact. It is a visual judgment, so check it another way
- Putting a categorical label such as Gender into K-Means as if it were a number
- Naming clusters before looking at what is in them
- Removing outliers just because they exist (two out of 200 is not a problem here)
- Reading a gentle elbow as if it were a sharp one
- Assuming scaling changes nothing because the spreads look similar (it still changed the groups, ARI 0.60)

## Interview Questions
- What is the difference between supervised and unsupervised learning?
- How does K-Means work? What is inertia?
- Why must you scale features before K-Means?
- How do you choose K? What are the limits of the elbow method?
- What does the silhouette score measure?
- Why does K-Means use `n_init`? What happens with a single random start?
- Why is there no train/test split in this clustering task?
- Should a categorical column like Gender be used in K-Means?

## Key Takeaways
- Check the data and look at it before any model
- Scale before K-Means, and fit the scaler on all customers because there is no test set here
- The elbow was clear with Income + Spending (K = 5) and gentle with all three columns (K = 4 to 6)
- Use more than one way to choose K: elbow, silhouette and resampling
- Use `n_init=10` and a fixed `random_state`
- K = 5 is a judgment call. Day 85 must check that the clusters make sense

## Limits (honest notes)
- This is a small teaching dataset (200 customers), so every result has a wide margin
- The Spending Score is assigned by the mall, so it measures that score and not real spending
- K was chosen by judgment from an elbow that is gentle with three columns. K = 4 and K = 6 are also defensible
- Silhouette scores were flat with three columns, so they could not break the tie
- There is no right answer to check clusters against, so "good" clusters can only mean separated and useful
- Resampling counts (30 resamples) are rough, and the bootstrap leaves out about 37% of customers each time

## Summary
- The Mall Customers data is clean and ready to use
- Age leans young, income has two outliers (137k), spending is centered near 50, and Age and Spending are moderately negatively related (r = -0.33). Gender does not separate anything
- Scaling changed the groups (agreement 0.60), so it stays
- The elbow is clear at K = 5 with Income + Spending and gentle (K = 4 to 6) with all three columns. Silhouette and resampling agree that K = 5 is the most common choice, with much less certainty on three columns
- Decision: K = 5 into Day 85, with K = 4 and K = 6 as side checks
- Next: Day 85, K-Means, PCA picture and cluster profiles
