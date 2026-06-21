# Day 2 — Measures of Central Tendency

## Why it matters
Mean, median, and mode are the first thing you compute on any new dataset.
Picking the wrong one can mislead you (or your boss, or your model) about
what's "typical" in your data.

---

## 1. Mean (the average)

**Beginner:** Add up all values, divide by count.

```python
import numpy as np
salaries = np.array([45000, 48000, 50000, 52000, 47000, 250000])
np.mean(salaries)
```

**Deeper:** The mean is sensitive to outliers — every value pulls on it
equally, but extreme values pull harder in absolute terms. One person
earning 250,000 drags the "average" salary above what almost everyone
actually earns.

---

## 2. Median (the middle value)

**Beginner:** Sort the data, pick the middle number.

```python
np.median(salaries)
```

**Deeper:** The median only cares about *position*, not *magnitude*.
Whether the top earner makes 250,000 or 2,500,000, the median barely
moves. This is why median is the standard for skewed data — salaries,
house prices, wealth.

**Rule of thumb:** If mean ≠ median by a lot → the data is skewed.

---

## 3. Mode (the most frequent value)

**Beginner:** Whatever value shows up most often.

```python
from scipy import stats
data = np.array([1, 2, 2, 3, 4, 2, 5])
stats.mode(data, keepdims=True)
```

**Deeper:** Mean and median need numeric data. Mode works on categories
too — e.g. "most common job title" or "most common product purchased."
It's the only one of the three that works for purely categorical data.

---

## Practice Task

```python
import numpy as np
from scipy import stats

salaries = np.array([42000, 45000, 47000, 48000, 50000, 51000, 53000, 300000])

print("Mean:  ", np.mean(salaries))
print("Median:", np.median(salaries))
print("Mode:  ", stats.mode(salaries, keepdims=True))
```

**Question:** Which value is most "honest" for a typical employee's salary?
**Answer:** Median — it isn't dragged up by the 300,000 outlier the way mean is.

---

## Quiz Recap

1. Exam scores `[55, 58, 60, 62, 65, 98]` → **Median**, because the 98 is an
   outlier that inflates the mean.
2. Categories `["red","red","blue","green","red","blue"]` → **Mode** is the
   only measure that applies; answer is `"red"`.
3. In a perfectly symmetric (normal) distribution → **mean = median = mode** (True).

---

## Key Takeaway
> If mean and median are far apart, trust the median — it's resistant to
> outliers. Mode is your only option for categorical data.
