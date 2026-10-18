[notes.md](https://github.com/user-attachments/files/33628910/notes.md)
# Day 71: PCA — Dimensionality Reduction Intuition

## Quick Overview
- **Topic:** Why too many features hurt, and how PCA squeezes many features into a few useful ones
- **What I learned:** PCA finds new axes that capture the most variance, and I built it by hand with NumPy before checking it against sklearn
- **Tools:** Python, pandas, NumPy, scikit-learn (`PCA`, `StandardScaler`, `KNeighborsClassifier`), matplotlib, Jupyter Notebook
- **Data note:** `dataset.csv` is made-up (400 football players, 6 rating columns driven by two hidden skills, plus a `starter` label)

## Introduction
- More features sounds like more information, but it is not always better
- Many columns are just repeating the same story (sprint speed and acceleration move together)
- PCA is a way to keep the story and drop the repetition
- Think of describing a house: "size" can replace "number of rooms", "floor area", and "number of windows" if they all move together

## Definitions
- **Dimension:** one feature (column) is one dimension
- **Curse of dimensionality:** with many dimensions, data gets spread thin and distances stop meaning much
- **Variance:** how spread out the values are (PCA treats spread as information)
- **Principal component (PC):** a new axis built from the old features
- **Linear combination:** a weighted mix, like `0.4 * speed + 0.4 * stamina + ...`
- **Loadings:** the weights each feature gets inside a PC
- **Covariance matrix:** a table showing how pairs of features vary together
- **Eigenvector / eigenvalue:** the direction of a new axis / how much variance sits on it
- **Multicollinearity:** features that are strongly correlated with each other

## Important Concepts
- **Curse of dimensionality (two real demos)**
  - Random points: (farthest - nearest) / nearest distance shrank from 66.13 (2 dims) to 0.11 (1000 dims), so everything starts looking equally far away
  - KNN with 2 useful features plus noise columns: accuracy 0.77 (0 noise), 0.69 (10), 0.51 (50), 0.65 (200)
  - The jump back up at 200 is random variation on a small test set (100 players), but the overall drop is clear
- **What PCA does**
  - Finds the direction with the most variance (PC1)
  - Then the next direction, at a right angle to the first (PC2), and so on
  - Keeps the first few, drops the rest
- **PCA by hand (4 steps)**
  - Scale the data
  - Build the covariance matrix
  - Get eigenvalues and eigenvectors with `np.linalg.eigh`
  - Sort by eigenvalue (biggest first) and project the data
- **My results**
  - Variance per PC: 61.0%, 27.2%, 4.2%, 3.0%, 2.5%, 2.1%
  - First 2 PCs hold 88.2% of the variance
  - sklearn's `PCA` gave the same numbers as my by-hand version
- **Components are linear combinations**
  - PC1 weights were all about -0.4 (same sign for all 6 ratings), so PC1 acts like "overall ability"
  - PC2 had athletic ratings on one side and technical ratings on the other, so it acts like "athletic vs technical"
  - The sign of a PC is arbitrary: flipping every sign means the same thing
- **Components are uncorrelated**
  - Biggest correlation between two PCs: 0.0
  - Biggest correlation between two original features: 0.87
- **When to use PCA**
  - Visualize high-dimensional data in 2D
  - Remove multicollinearity
  - Speed up models on data with many columns
  - Do not use it when you need to explain results using the original feature names

## Step-by-Step Explanation
- **Step 1:** Scale the features with `StandardScaler`
- **Step 2:** Compute the covariance matrix
- **Step 3:** Find eigenvalues and eigenvectors
- **Step 4:** Sort them from biggest variance to smallest
- **Step 5:** Divide each eigenvalue by the total to get the share of variance
- **Step 6:** Project the data with `X_scaled @ eigvecs`
- **Step 7:** Keep the first few components and plot or model with them

## Examples
- **Correlation blocks:** sprint speed, acceleration, stamina correlate 0.77 to 0.85 with each other; dribbling, passing, ball control correlate 0.83 to 0.87
- **6D to 2D:** the scatter of PC1 vs PC2 shows starters leaning toward one side of PC1
- **KNN check (fit PCA on training data only):** 0.78 with all 6 features, 0.80 with 2 PCA features
  - That is a difference of about 2 players out of 100, so the honest summary is "about the same with a third of the features"
- **Practice:** 2 components are needed to reach 80% of the variance (cumulative: 61.0, 88.2, 92.4, 95.4, 97.9, 100.0)
- **Mini challenge:** biggest weight on PC1 was `ball_control`, on PC2 was `stamina`, but all weights are very close, so this is nearly a tie

## Common Mistakes
- Forgetting to scale before PCA (big-number columns would dominate)
- Fitting PCA on the full data before splitting (leaks test information, fit on training data only)
- Thinking PC1 is "the most important feature" (it is a mix of features)
- Reading too much into the sign of a component
- Using PCA on features that are not correlated (nothing to squeeze)
- Assuming PCA always improves accuracy (it did not clearly here)

## Interview Questions
- What is the curse of dimensionality?
- What does PCA actually find?
- Why are principal components uncorrelated?
- Why must you scale features before PCA?
- What are loadings, and how do you read them?
- Name three situations where PCA is useful
- What do you lose when you use PCA?

## Key Takeaways
- More features can hurt, especially for distance-based models
- PCA finds new axes that hold the most variance
- Each PC is a weighted mix of the original features
- PCs are uncorrelated, so PCA fixes multicollinearity
- Scale first, and fit PCA on training data only

## Summary
- 6 correlated player ratings were squeezed into 2 components holding 88.2% of the variance
- My by-hand PCA matched sklearn exactly
- A KNN on 2 components did about as well as one on all 6 features
- Tomorrow (Day 72) I use sklearn's `explained_variance_ratio_` to choose how many components to keep
