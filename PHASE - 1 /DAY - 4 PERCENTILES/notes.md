# Day 4 — Percentiles, IQR & Outlier Detection

**Phase:** 1 — Statistics Foundations
**Roadmap topic:** Percentiles, IQR & Outlier Detection

## Why this matters
IQR is the industry-standard method for detecting outliers during data cleaning. It shows up in almost every EDA you'll ever do — before ML, before visualization, before reporting numbers to anyone.

## Core concepts

### 1. Percentile
A percentile marks a **position** in sorted data, not a magnitude.
"75th percentile = 52" means 75% of values are below 52 — it does **not** mean 52 is a big/important number on its own.

```python
Q1 = np.percentile(data, 25)
Q2 = np.percentile(data, 50)   # median
Q3 = np.percentile(data, 75)
```

### 2. IQR (Interquartile Range)
The width of the middle 50% of the data.

```
IQR = Q3 - Q1
```

A small IQR = middle data tightly packed. A large IQR = middle data spread wide.

### 3. Outlier rule (Tukey's rule)
```
lower_bound = Q1 - 1.5 * IQR
upper_bound = Q3 + 1.5 * IQR
```
Anything outside this range is flagged as a statistical outlier. The `1.5` is a convention (Tukey, 1970s) — not a derived constant.

### 4. Why IQR beats standard deviation for outlier detection
- Q1/Q3 are found by **position/rank** in sorted data — an extreme value just becomes "the last item in line," it can't drag Q1/Q3 anywhere.
- Standard deviation is computed from **actual values, squared** — one extreme value inflates the std dev itself (the "masking effect"), which can hide the very outlier you're trying to catch.
- Conclusion: IQR is the safer default on real-world, possibly messy/skewed data. Std-dev-based detection (z-scores) is only reliable when data is already roughly normal and clean.

### 5. Finding an outlier ≠ deleting it
Always ask first: **is this a data error, or a real but unusual value?**
- Error (e.g. logging bug, typo) → fix or remove
- Real but extreme (e.g. wholesale order, server timeout) → keep, flag with a feature, or transform (log/cap) — don't destroy real signal

## Code walkthrough

```python
import numpy as np

house_prices = np.array([45, 50, 48, 52, 47, 49, 55, 51, 46, 53,
                          48, 50, 49, 52, 250, 47, 51, 48, 300, 50])

Q1 = np.percentile(house_prices, 25)
Q3 = np.percentile(house_prices, 75)
IQR = Q3 - Q1

lower_bound = Q1 - 1.5 * IQR
upper_bound = Q3 + 1.5 * IQR

is_outlier = (house_prices < lower_bound) | (house_prices > upper_bound)

outliers = house_prices[is_outlier]
normal_values = house_prices[~is_outlier]

print("Outliers:", outliers)          # [250 300]
print("Normal values:", normal_values)
```

## Common mistakes

| Mistake | Fix |
|---|---|
| Confusing percentile with percentage | Percentile = position in sorted data, never the raw value itself |
| Blindly applying 1.5×IQR on heavily skewed data (e.g. income) | Check the distribution shape (Day 5) first — skewed data may need a log transform before outlier detection |
| Deleting every flagged outlier automatically | Investigate first — error vs. real extreme value decide the fix |

## Interview questions

**Q: How would you detect outliers in a numeric column, and why choose IQR over standard deviation?**
A: Compute Q1/Q3, get IQR = Q3-Q1, flag values beyond Q1-1.5×IQR / Q3+1.5×IQR. IQR is robust because it's rank-based and ignores the top/bottom 25%, so outliers can't distort their own detection boundary — unlike std dev, which gets inflated by the very outliers it's trying to catch (masking effect).

**Q: Should you always remove outliers?**
A: No. An outlier may be a real data entry error, or a genuinely valid extreme case (e.g. fraud transaction, luxury sale) that carries important information. Investigate the source before deciding to fix, keep, flag, or transform.

## Quiz result
Score: 5/10 on first pass (reasoning + real-world rounds). Revisit flag set on:
- Percentile = position, not magnitude
- Why IQR resists outliers (rank-based) vs std dev (squared values get dragged)
- Statistical outlier ≠ automatically wrong data

Second pass (simplified "runners in a line" analogy + quick round): concept fully clicked, 4/4 correct.

## Today I learned
- Percentiles mark position in sorted data — extreme values can't move Q1/Q3 because rank doesn't care about magnitude.
- IQR is the safer default outlier detector for real-world data because std dev gets masked/inflated by the outliers themselves.
- A flagged outlier isn't automatically bad data — always investigate why before deciding to remove, keep, or transform.

---
*Part of the [90-Day Data Science Roadmap](https://github.com/shafimughalp-creator/90-Day-Data-Science-Roadmap)*
