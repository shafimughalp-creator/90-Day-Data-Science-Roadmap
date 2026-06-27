# Review Day — Days 1-7 Statistics Applied to Football Dataset

**Dataset:** FC Lahore Lions — synthetic 30-match season (`lions_season.csv`)
**Goal:** Apply every statistics concept from Days 1-7 on one real dataset instead of isolated examples.

---

## Day 2 — Mean, Median, Mode
```python
df['goals_scored'].mean()    # 1.57
df['goals_scored'].median()  # 1.0
df['goals_scored'].mode()    # 0
```
**Takeaway:** Mean (1.57) was inflated by one 8-goal outlier match. Median (1) and mode (0) show the *typical* match was much lower-scoring. Mean can lie — median/mode are the honest backup.

---

## Day 3 — Variance & Standard Deviation
```python
df['possession_pct'].var()   # 49.14
df['possession_pct'].std()   # 7.01
```
**Takeaway:** Possession swings about ±7 percentage points around the average match to match — moderate, not wild, consistency.

---

## Day 4 — Percentiles, IQR, Outlier Detection
```python
q1, q3 = df['shots_on_target'].quantile([0.25, 0.75])
iqr = q3 - q1
lower, upper = q1 - 1.5*iqr, q3 + 1.5*iqr
```
**Outliers found:** Match 6 (19 shots, 8 goals — thrashing) and Match 19 (13 shots, 0 goals — wasteful finishing).
**Takeaway:** Outliers are real stories to investigate, not errors to delete.

---

## Day 5 — Distribution Shape & Skewness
```python
from scipy import stats
stats.skew(df['goals_scored'])   # 1.52 → strong right-skew
```
**Takeaway:** 40% of matches ended 0-0 in goals scored, with a thin tail stretching to 8. Removing the outlier moved skew toward zero (1.52 → 0.83), NOT to negative — removing a right-tail outlier reduces right-skew, it doesn't flip the sign.

---

## Day 6 — Probability Basics
```python
P(Win)        = 0.33
P(Home)       = 0.57
P(Win|Home)   = 0.41
P(Win|Away)   = 0.23
```
**Takeaway:** Conditioning on venue changes the win probability significantly — home advantage is real and measurable. P(Win|Home) and P(Win|Away) are independent calculations on separate subsets — never complements (`1 - P(Win|Home)` is NOT P(Win|Away)).

---

## Day 7 — Bayes' Theorem
```python
P(Home|Win) = P(Win|Home) * P(Home) / P(Win)   # = 0.70
```
**Takeaway:** P(Win|Home)=0.41 and P(Home|Win)=0.70 are two different questions answered by two different formulas. Direction of conditioning matters — Bayes' Theorem is how you correctly reverse it.

---

## Quiz Results: 8/10
- Weak spot 1: skewness direction after outlier removal (moves toward zero, doesn't flip sign)
- Weak spot 2: conditional probabilities on different subsets are not complements of each other

## Files in this folder
- `lions_season.csv` — dataset
- `Day_Review_Football_Practice.ipynb` — full code walkthrough
- `goals_histogram.png` — skewness visualization
- `notes.md` — this file
