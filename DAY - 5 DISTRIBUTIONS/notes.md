
# Day 5: Distributions — Normal Distribution & Skewness

## Concepts Covered
- **Normal distribution**: bell-curve shape, mean ≈ median ≈ mode
- **68-95-99.7 empirical rule**: for normal data, ~68% falls within 1 std dev of the mean, ~95% within 2, ~99.7% within 3 — verified hands-on on 10,000 simulated points (got 68.4% / 95.5% / 99.8%)
- **Skewness**: right-skewed (tail right, mean > median) vs left-skewed (tail left, mean < median)
- **Kurtosis**: measures extreme outliers/tail weight, independent of skew direction
- **Mode**: most frequent value; works best with repeated/discrete values, not continuous random data
- **Log transform**: fixes right-skew specifically — does **not** fix left-skew, and can make it worse

## Key Code
```python
from scipy.stats import skew, kurtosis
from scipy import stats

skew(data)                 # skewness
kurtosis(data)              # excess kurtosis (normal = 0)
stats.mode(data, keepdims=True)   # mode + count
np.log(data)                 # right-skew fix only
```

## Experiments
1. **Village money (10 people, 1 extreme outlier)** — right-skewed (skew=2.666, kurtosis=5.11). Log transform barely helped (2.666 → 2.632) — tiny sample + one insanely extreme outlier resists correction.
2. **Village money (100 people, realistic spread)** — right-skewed (skew=1.45). Log transform fixed it well (1.45 → -0.005, ~symmetric).
3. **Exam scores (100 people, left-skewed)** — skew=-1.38. Log transform made it WORSE (-1.38 → -1.73) — proved log is direction-specific, not a universal skew fix.
4. **Kurtosis comparison** — village 10 (5.11) > village 100 (2.32) > exam scores (1.22): one extreme outlier in a tiny dataset creates the heaviest tail of all.
5. **Mode** — grades list `[85,90,85,78,90,90,88,85,92,90]` → mode=90, count=4.
6. **Empirical rule verification** — 10,000 simulated normal points matched the 68-95-99.7 rule almost exactly.

## Key Insights
- Skew direction is read from mean vs median; skew size (near 0 vs beyond ±1) tells you how strongly lopsided the data is.
- Kurtosis is a separate question from skew — it measures *how extreme* the outliers are, regardless of which direction they point.
- Log transform is not a universal skew fix — it specifically compresses large values, so it only works on right-skew. Applied to left-skew, it does little or actively worsens it.
- Sample size and outlier extremity both matter: a few extreme outliers in a tiny dataset resist correction far more than a smooth, gradual tail in a larger dataset.
