# Day 10 — p-value, Significance Level & t-test

**Phase:** Statistics Foundations
**Roadmap tags:** `t-test` `p-value` `scipy` `significance`

---

## Why this matters

The t-test is the most common statistical test in data science. It answers
one core question: **is a difference between two things real, or could it
just be random luck?** A/B tests, feature comparisons, and "did this change
actually help" questions all come back to this.

---

## Core Concepts

### Hypotheses
- **H0 (Null Hypothesis):** there is no real difference — anything we see
  is just random chance.
- **H1 (Alternative Hypothesis):** there is a real difference.

### p-value
The probability of seeing a difference this large (or larger) **if H0 were
true**. It is NOT the probability that H0 is true.

- Small p-value → unlikely to be chance → evidence against H0
- Large p-value → could easily be chance → not enough evidence against H0

### Significance level (α)
The threshold set *before* testing — almost always **α = 0.05**.

```
if p-value < α (0.05):  reject H0        → statistically significant
if p-value ≥ α (0.05):  fail to reject H0 → not enough evidence
```

⚠️ Correct wording: we never say a result is "proven." We say there is
"strong evidence against H0" or "not enough evidence."

### Type I vs Type II error

| | H0 is actually True | H0 is actually False |
|---|---|---|
| **Reject H0** | Type I Error (false positive) | Correct |
| **Fail to reject H0** | Correct | Type II Error (false negative) |

---

## One-sample vs Two-sample t-test

| Test | When to use | Function |
|---|---|---|
| **One-sample** | Comparing ONE sample's mean against a SINGLE known fixed value (e.g. league average) | `stats.ttest_1samp(sample, known_value)` |
| **Two-sample (independent)** | Comparing the means of TWO real, separate datasets you collected | `stats.ttest_ind(sample_a, sample_b)` |

**Rule of thumb:** a single known number = one-sample. Two real datasets =
two-sample.

---

## Code Examples

See `Day10_pvalue_ttest.ipynb` for the full runnable notebook. Summary of
results from the FC Lahore Lions synthetic dataset (`seed=42`):

| Test | Comparison | t-stat | p-value | Decision |
|---|---|---|---|---|
| Two-sample | Men's vs Women's salary | 2.5225 | 0.016 | Reject H0 — significant |
| One-sample | Men's salary vs league avg (235k) | 1.5312 | 0.1422 | Fail to reject H0 |
| Two-sample | Home vs Away scores | 2.8443 | 0.0065 | Reject H0 — significant |

---

## Common Mistakes

| ❌ Wrong | ✅ Right |
|---|---|
| "p-value is the probability H0 is true" | p-value = probability of seeing data this extreme **if H0 were true** |
| "p = 0.04, so we proved it works" | "p = 0.04, so we reject H0 — strong evidence of a difference" |
| Two-sample test against a single known value | Use one-sample test instead |
| Treating p = 0.049 vs p = 0.06 as wildly different | Nearly identical evidence — α = 0.05 is a convention, not a hard wall |

---

## Personal Gaps (for review)

- **One-sample vs two-sample selection** — mixed up 5 times in this
  session's quiz, in both directions. Needs a dedicated warmup on Day 11.
- **"Proven" / "no proven evidence" wording** — flagged again this
  session (4th occurrence). A p-value is evidence, never proof.
- **α default value** — said 0.5 once instead of 0.05. Quick gut-check
  needed next session.

---

## Today I Learned

- A t-test tells you whether a difference between groups is real or likely
  just random chance, using a p-value compared against α.
- One-sample t-test compares one dataset against a known fixed value;
  two-sample t-test compares two real datasets against each other.
- A p-value never "proves" anything — it only tells you how much evidence
  you have against H0.
