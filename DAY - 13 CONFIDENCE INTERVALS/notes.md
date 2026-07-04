# Day 13 — Confidence Intervals

**Phase:** 1 — Statistics Fundamentals
**Dataset:** FC Lahore Lions (synthetic, seed=42)

---

## 1. What is a Confidence Interval?

A single sample mean (a **point estimate**) is just one guess at the truth.
A **Confidence Interval (CI)** is a range built around that point estimate,
designed to reliably capture the true population value.

Example: *"Lions average 1.37 goals/match, 95% CI: (0.92, 1.82)"* is far more
honest than just saying *"1.37 goals/match."*

## 2. The #1 Misconception

> ❌ "There's a 95% chance the true mean is in this specific range."
> ✅ "If we repeated this sampling process 100 times and built 100 intervals,
> about 95 of them would contain the true mean."

Once an interval is calculated, it's fixed. The 95% describes the
**reliability of the method**, not the probability of one specific result.

## 3. The Formula

```
CI = sample_mean ± (critical_value) × Standard_Error
SE = sample_std / sqrt(n)
```

- **z (1.96)** → only valid if you know the true population std dev (rare)
- **t-distribution** → used when population std is unknown (almost always
  the real-world case). Slightly wider than z to account for the extra
  uncertainty. Converges to z as n grows large.

## 4. Key Relationship to Sample Size

- Bigger sample size (n) → smaller Standard Error → narrower CI
- More inconsistent/noisy data (bigger std dev) → wider CI
- To cut CI width in **half**, you need **4x** the data (because of the
  square root in the SE formula) — not just double.

## 5. Glossary

| Term | Meaning |
|---|---|
| Point estimate | Single best-guess number (e.g. sample mean) |
| Confidence Interval | Range likely to contain the true population value |
| Confidence Level | Reliability of the method (95% standard) |
| Margin of Error | How far the range stretches from the point estimate |
| Standard Error (SE) | How much sample means wobble sample-to-sample |
| t-distribution | Wider version of normal curve, used for small/unknown-σ samples |
| Degrees of Freedom (df) | n − 1, controls shape of the t-distribution |

## 6. Common Mistakes

1. Saying "95% chance the true value is in this range" (see #2 above)
2. Using z (1.96) when population std dev is unknown — should use t instead
3. Assuming a wider interval means "more confidence is better" — actually
   it's a sign of a small/noisy sample, not a strength

## 7. Interview Answers (structure, not scripts)

**Q: Explain a 95% CI to a non-technical stakeholder.**
1. Plain analogy first (repeated sampling → 95/100 intervals capture truth)
2. Concrete number example from their own data
3. Explicitly avoid the "95% chance it's in this range" trap

**Q: When do you use t vs z?**
1. State the rule: t when population std dev is unknown (the normal case)
2. Small samples → big difference; large samples → t and z converge
3. Bonus: mention degrees of freedom (n − 1)

## 8. Quiz Result

**Score: 9/10** — missed the "95% chance" wording trap in Round 1, but
correctly explained the concept in later rounds. No revisit flag needed.

## 9. Practice Task (from roadmap)

Compute a 95% CI for average purchase amount in an e-commerce sample —
same method, different dataset. (See notebook, optional extension cell.)

---
**Next up:** Day 14 — Covariance & Advanced Correlation Concepts
