# Day 3 — Measures of Spread: Variance & Standard Deviation

## 🎯 Why This Matters
Two datasets can have the **same mean** but be completely different in reality.
Example: Two departments both averaging ~50k salary —
- Dept A: salaries tightly clustered around 50k
- Dept B: salaries scattered from 20k to 80k

Mean alone can't tell them apart. **Spread** can.

---

## 1. Range
```
Range = max(data) - min(data)
```
- Simple, fast.
- **Fragile**: only uses 2 points (max, min), ignores everything else.
- A single outlier can make the range huge even if most data is tightly packed.

---

## 2. Variance
Average of the **squared** deviations from the mean.

$$\text{Variance} (\sigma^2) = \frac{\sum (x_i - \bar{x})^2}{n}$$

**Why squared?**
- Raw deviations from the mean always sum to 0 (that's the definition of mean).
- Squaring makes every deviation positive, so they don't cancel out.
- Squaring also penalizes larger deviations more heavily.

**Population vs Sample variance — THE ddof TRAP:**
| | Formula | Used when | Default in |
|---|---|---|---|
| Population variance | divide by `n` | you have the ENTIRE population | `numpy` (`ddof=0`) |
| Sample variance | divide by `n - 1` (Bessel's correction) | you have a SAMPLE representing a bigger population | `pandas` (`ddof=1`) |

⚠️ Same data, different library, different (but both "correct") answer. Always check `ddof` explicitly when comparing across numpy/pandas.

---

## 3. Standard Deviation
```
Std Dev = sqrt(Variance)
```
- Same units as your original data (variance is in *squared* units — not human-readable).
- The number you actually report to people: *"salaries typically deviate by ~21k from the average."*

---

## 4. Worked Example
```python
import numpy as np

dept_a = np.array([50, 51, 49, 50, 52, 48, 50])
dept_b = np.array([30, 70, 20, 80, 35, 65, 40])

# Means are nearly identical (~50 vs ~48.6) — looks similar at first glance
# Range:    A = 4      | B = 60     -> huge gap already
# Variance: A = 1.43   | B = 447.96
# Std Dev:  A = 1.20   | B = 21.17  -> Dept A is far more consistent
```

**Conclusion:** Lower std dev = more consistent data. Higher std dev = more scattered/unpredictable — regardless of what the means look like.

---

## 5. Common Mistakes
1. **Trusting range when there's an outlier** → check std dev too, it's less distorted by single extreme values.
2. **Mixing numpy/pandas variance without checking `ddof`** → always specify `ddof` explicitly when consistency across libraries matters.
3. **Reporting variance directly** → variance is in squared units (meaningless to a human). Convert to std dev first.

---

## 6. Interview Q&A
**Q: Why square deviations instead of using absolute value?**
A: Squaring is differentiable everywhere (important for optimization/gradient descent), and it penalizes larger deviations more than absolute value does. Variance/std dev also connects tightly to the normal distribution, which is why it's the standard choice over Mean Absolute Deviation.

**Q: Why does population vs sample variance matter in practice?**
A: Population variance (÷n) assumes you have the whole population. Sample variance (÷n-1) corrects for the bias that occurs when estimating a population's variance from just a sample. numpy defaults to population (`ddof=0`), pandas defaults to sample (`ddof=1`) — mixing them up silently gives wrong comparisons.

---

## 7. Edge Cases
- All values identical (e.g. `[50,50,50,50]`) → variance = 0, std = 0 (no deviation from mean exists).
- Variance/std can **never be negative** (squaring guarantees non-negative values).
- Sample variance (`ddof=1`) with only **1 data point** → `n-1 = 0` → division by zero → `NaN` (undefined, not 0). You need at least 2 points to talk about sample spread.

---

## ✅ Day 3 Roadmap Tasks — Complete
- [x] Range: max - min, fragility to outliers
- [x] Variance: `np.var()`, why squared
- [x] Standard Deviation: `np.std()`, why more interpretable
- [x] Practice: compared spread of two salary columns, identified the more consistent one
