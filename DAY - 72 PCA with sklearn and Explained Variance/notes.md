[Uploading notes.md…]()
# Day 72: PCA — sklearn + Explained Variance

## Quick Overview
- **Topic:** Using sklearn's `PCA` and `explained_variance_ratio_` to decide how many components to keep
- **What I learned:** The cumulative variance curve tells you how many components you need, and 2D plots are great for looking but may throw away most of the information
- **Tools:** Python, pandas, NumPy, scikit-learn (`PCA`, `StandardScaler`, `make_pipeline`, `LogisticRegression`), matplotlib, Jupyter Notebook
- **Data note:** `dataset.csv` is scikit-learn's built-in handwritten digits data (real): 1,797 images, 8x8 pixels = 64 features, digits 0 to 9

## Introduction
- Day 71 was the idea of PCA, built by hand
- Today I used sklearn's PCA on real, high-dimensional data (64 pixel columns)
- The big question: **how many components should I keep?**
- It is like packing a suitcase: you want to leave things out, but not the things you need

## Definitions
- **`n_components`:** how many principal components to keep
- **`fit_transform`:** learn the components and project the data in one step
- **`explained_variance_ratio_`:** the share of total variance each component holds
- **Cumulative explained variance:** the running total of those shares
- **95% rule:** a common choice is the smallest number of components reaching about 95%
- **Data leakage:** accidentally letting test data influence training (for example, fitting PCA on all data before splitting)
- **Pipeline:** chains steps (scale, PCA, model) so each is fitted on training data only

## Important Concepts
- **Two ways to set `n_components`**
  - An integer: `PCA(n_components=2)` keeps exactly 2
  - A fraction: `PCA(n_components=0.95)` keeps just enough for 95% variance
  - Both ways gave 40 components for 95% (by hand and with the shortcut)
- **My variance results (64 pixel features)**
  - First 5 components: 12.0, 9.6, 8.4, 6.5, 4.9 (% each)
  - Cumulative after 5: 41.4%
  - 80% needs 21 components, 90% needs 31, 95% needs 40, 99% needs 54
- **2D projection**
  - 2 components keep only 21.6% of the variance
  - The scatter plot separates digits 0, 4, and 6 fairly well, but the middle digits overlap a lot
- **Does PCA hurt a model? (Logistic Regression, scaler and PCA fitted on training data only)**
  - All 64 features: 0.978
  - 2 components: 0.511
  - 95% of variance (40 components): 0.960
- **Accuracy as components grow**
  - 2 -> 0.511, 5 -> 0.784, 10 -> 0.858, 20 -> 0.942, 30 -> 0.949, 40 -> 0.960
  - Only 40 components came within 0.02 of using all 64
- **Honest takeaway**
  - Digit pixels are not very redundant, so PCA only cut 64 columns to 40 (37.5% fewer) at 95%
  - On Day 71's made-up data, 2 components held 88.2%, but that data was built from just 2 hidden skills
  - Real data usually needs more components than a clean example suggests

## Step-by-Step Explanation
- **Step 1:** Scale the features with `StandardScaler`
- **Step 2:** Fit `PCA()` with all components and read `explained_variance_ratio_`
- **Step 3:** Take `np.cumsum` of the ratios
- **Step 4:** Find where the cumulative total first reaches 0.95
- **Step 5:** Refit with `PCA(n_components=0.95)` (or that number)
- **Step 6:** For visuals, use `PCA(n_components=2)` and scatter PC1 vs PC2, colored by class
- **Step 7:** For models, put scaler, PCA, and model in one pipeline and fit on training data only

## Examples
- **Shapes:** (1797, 64) became (1797, 2) with 2 components, and (1797, 40) with 95%
- **Component shape:** `components_` had shape (40, 64), so each component is 64 weights, one per pixel
- **Practice:** 99% of the variance needs 54 components, which is 15.6% fewer columns
- **Mini challenge:** the first count within 0.02 of the baseline was 40 components (0.960 vs 0.978)

## Common Mistakes
- Fitting PCA on the whole dataset before splitting (leakage), use a pipeline instead
- Skipping the scaler
- Choosing 2 components just because they make a nice plot, then modeling with them
- Treating 95% as a law (it is a starting point, check model accuracy too)
- Forgetting that components lose the original feature names
- Expecting big reductions on data that is not very correlated

## Interview Questions
- What does `explained_variance_ratio_` tell you?
- How do you decide how many components to keep?
- What does `PCA(n_components=0.95)` do?
- Why should PCA be fitted on training data only?
- Why can a 2D PCA plot look useful but still lose most of the information?
- What is a pipeline, and why does it help here?

## Key Takeaways
- Use the cumulative variance curve to choose `n_components`
- `PCA(n_components=0.95)` picks the number for you
- 2D plots are for looking, not always for modeling
- Fit scaler and PCA on training data only (use a pipeline)
- Check model accuracy, not just variance

## Summary
- 64 pixel features needed 40 components to keep 95% of the variance
- 2 components kept only 21.6% and a model on them scored 0.511 (vs 0.978 on all features)
- 40 components scored 0.960, close to the full model
- Next up (Day 73): sklearn Pipelines, which make leak-free steps like these automatic
