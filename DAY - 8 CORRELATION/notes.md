[Day08_notes.md](https://github.com/user-attachments/files/29433571/Day08_notes.md)
# Day 8 — Correlation: Pearson & Spearman

**Phase 1 — Statistics | 90-Day Data Science Roadmap**

---

## 📋 Required Concepts Checklist

- [x] What correlation measures (strength + direction)
- [x] Pearson correlation coefficient (r) — formula intuition, range -1 to +1
- [x] Reading r values — strength bands + sign meaning
- [x] Correlation ≠ Causation
- [x] Spearman rank correlation
- [x] When to use Pearson vs Spearman
- [x] Correlation matrix — np.corrcoef()
- [x] Multicollinearity ⚑ *(flagged for Day 9 warmup — see below)*
- [x] Common beginner mistakes

---

## 🧠 Core Concept

Correlation measures **how strongly two variables move together**, and in **which direction**.

```
-1 ──────────── 0 ──────────── +1
perfect          no            perfect
negative      relationship    positive
```

- **Sign (+/-)** → direction only
- **Magnitude (|r|)** → strength only (these are two separate things!)

| |r| value | Strength |
|---|---|
| 0.7 – 1.0 | Strong |
| 0.4 – 0.7 | Moderate |
| < 0.4 | Weak |

> ⚠️ A correlation of **-0.85** is just as *strong* as **+0.85** — only the direction differs.

---

## Pearson vs Spearman

| | Pearson | Spearman |
|---|---|---|
| Detects | Linear relationships | Monotonic relationships (rank-based) |
| Sensitive to outliers? | Yes | No (more robust) |
| How it works | Uses raw values | Converts values to ranks first, then runs Pearson's math on the ranks |
| Best for | Straight-line patterns, continuous data | Curved-but-consistent patterns, ordinal data, outlier-heavy data |

---

## ⚠️ Correlation ≠ Causation

Classic example: ice cream sales and drowning deaths are positively correlated. Ice cream doesn't cause drowning — both are driven by a **confounding variable** (hot weather).

Correlation tells you variables move together. It tells you **nothing** about *why*.

---

## ⚑ Multicollinearity (Revisit Flag — Day 9 warmup)

Multicollinearity = **two input features highly correlated with EACH OTHER** (not with the target).

- Test: look at the correlation value between the two *features* (close to ±1 = problem)
- NOT a test of whether two features seem conceptually similar
- Example found in this session: `shots` & `possession` → r = 0.99 → redundant signal for a model
- Fix: drop one, combine them, or use a model less sensitive to it (e.g., tree-based)

---

## 💻 Code Summary

```python
import numpy as np
import pandas as pd
from scipy.stats import spearmanr

shots = np.array([8, 12, 15, 9, 18, 6, 14, 20, 10, 16])
goals = np.array([1, 2, 3, 1, 3, 0, 2, 4, 1, 3])
possession = np.array([45, 58, 62, 48, 65, 40, 55, 70, 50, 60])
fouls = np.array([14, 10, 8, 13, 6, 16, 9, 5, 12, 7])

# Pearson (pairwise)
pearson_r = np.corrcoef(shots, goals)[0, 1]   # 0.978

# Spearman (pairwise)
spearman_r, p_val = spearmanr(shots, goals)   # 0.952

# Full correlation matrix
df = pd.DataFrame({"shots": shots, "goals": goals,
                    "possession": possession, "fouls": fouls})
corr_matrix = df.corr()
```

**Finding:** `shots` & `possession` correlate at **0.99** → multicollinearity red flag.

---

## 🐞 Common Mistakes

1. Treating correlation as proof of causation
2. Using Pearson on clearly non-linear (but monotonic) data → underestimates the true relationship
3. Ignoring the correlation matrix before feeding all features into a model

---

## 🎯 Quiz Result: 5.5 / 10

**Revisit flag:** Multicollinearity — confusing "correlated with each other" (the actual test) with "conceptually related" (not the test). Warmup scheduled for Day 9 before Hypothesis Testing.

---

## ✅ Today I Learned
- Pearson measures linear correlation; Spearman measures monotonic (rank-based) correlation — strength is about `|r|`, not the sign.
- Correlation ≠ causation — always check for confounding variables.
- Multicollinearity means two *input features* are highly correlated with *each other*, not with the target — that's the redundancy problem.

---

**Next:** Day 9 — Hypothesis Testing (Null Hypothesis & Intuition), with a 5-min multicollinearity warmup first.
