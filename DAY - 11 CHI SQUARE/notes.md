# Day 11 — Chi-Square Test (Categorical Variables)

## What is Chi-Square?
- Tests whether two **categorical** variables are **independent or associated**
- Used when BOTH columns are categories (e.g. Position, Injured — not numbers)
- Cannot use t-test here because there is no mean of "GK" or "Yes"

---

## Core Idea
> If two variables had NOTHING to do with each other — what would the counts look like?
> Chi-square measures how far our actual (observed) counts are from that expectation.

- Big gap between Observed and Expected → big chi2 stat → small p-value → association likely
- Small gap → small chi2 stat → large p-value → probably just random noise

---

## Key Formula

```
χ² = Σ [ (Observed - Expected)² / Expected ]
```

- Square the difference so negatives don't cancel out
- Divide by Expected so small-count gaps are weighted properly
- Sum across every cell in the table

---

## Expected Count Formula (per cell)

```
Expected = (Row Total × Column Total) / Grand Total
```

Example — GK + Injured:
```
Expected = (15 × 50) / 120 = 6.25
```

---

## Degrees of Freedom

```
dof = (rows - 1) × (columns - 1)
```

- Means: how many cells are FREE to change once row/column totals are locked
- Example: 4 positions × 2 outcomes → (4-1)×(2-1) = 3

---

## chi2_contingency() — Always Returns 4 Things

```python
chi2, p, dof, expected = stats.chi2_contingency(ct)
#  1     2    3      4
```

Never unpack only 2 — Python will crash with: `ValueError: too many values to unpack`

---

## Reading the Result

```
p < 0.05  →  Reject H0  →  Strong evidence of association
p > 0.05  →  Fail to reject H0  →  No evidence of association
```

### ⚠️ Wording Rules (memorise these)
| Wrong ❌ | Right ✅ |
|---|---|
| "proves they are related" | "strong evidence of association" |
| "position causes injuries" | "position is associated with injury rate" |
| "p = 0.02 means 2% chance they're related" | "p = 0.02 means: if H0 were true, only 2% chance of seeing data this extreme by luck" |

---

## What Chi-Square Does NOT Tell You

| Question | Tool |
|---|---|
| Are they associated? | ✅ Chi-Square |
| How STRONGLY associated? | ❌ Use Cramér's V |
| WHY are they associated? | ❌ Need experiments / domain knowledge |

---

## Full Code

```python
import numpy as np
import pandas as pd
from scipy import stats

# --- Build synthetic FC Lahore Lions dataset ---
np.random.seed(42)
n = 120

positions = np.random.choice(
    ['GK', 'DEF', 'MID', 'FWD'],
    size=n,
    p=[0.1, 0.3, 0.35, 0.25]
)

injury_prob = {'GK': 0.15, 'DEF': 0.45, 'MID': 0.30, 'FWD': 0.50}

injured = []
for p in positions:
    prob_yes = injury_prob[p]
    prob_no  = 1 - prob_yes
    result   = np.random.choice(['Yes', 'No'], p=[prob_yes, prob_no])
    injured.append(result)
injured = np.array(injured)

df = pd.DataFrame({'Position': positions, 'Injured': injured})

# --- Build contingency table ---
ct = pd.crosstab(df['Position'], df['Injured'])
print("Observed Table:")
print(ct)

# --- Run Chi-Square Test ---
chi2, p, dof, expected = stats.chi2_contingency(ct)

print(f"\nChi2 stat : {chi2:.4f}")
print(f"p-value   : {p:.4f}")
print(f"dof       : {dof}")

# --- Print Expected Table ---
expected_df = pd.DataFrame(
    expected,
    index=ct.index,
    columns=ct.columns
).round(2)

print("\nExpected Table:")
print(expected_df)

# --- Conclusion ---
if p < 0.05:
    print("\n✅ Reject H0 — Strong evidence of association between Position and Injury")
else:
    print("\n❌ Fail to reject H0 — No significant association found")
```

---

## Common Mistakes

| Mistake | Fix |
|---|---|
| `chi2, p = stats.chi2_contingency(ct)` | Always unpack all 4 values |
| Passing raw columns instead of crosstab | Always do `pd.crosstab()` first |
| Using chi-square on continuous data | Bin continuous data into categories first |
| Expected count < 5 in any cell | Use Fisher's Exact Test instead |

---

## Revisit Flag ⚑
- p-value definition — it is NOT "probability the relationship exists"
- Chi-square = association only, never causation

---

## Interview Questions

**Q: When do you use chi-square vs t-test?**
> t-test = continuous outcome compared across groups. Chi-square = both variables are categorical.

**Q: p = 0.03. What do you conclude?**
> At α = 0.05, p = 0.03 means we reject H0. There is strong evidence the two variables are associated. Chi-square does not tell us the strength (Cramér's V) or the cause (needs experiments).
