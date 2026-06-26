
# Day 7 — Bayes' Theorem (Intuition First)

**Phase 1: Statistics | 90-Day Data Science Roadmap**

---

## 🎯 The Hook

Think of VAR in football. The referee makes a call on the field — that's the **Prior** (belief before evidence). The replay comes in — that's the **Evidence/Likelihood**. The referee updates the call — that's the **Posterior** (belief after evidence).

Bayes' Theorem is just the math version of that update.

---

## 🧠 The Formula (derived, not memorized)

Starting from conditional probability:

```
P(A|B) = P(A ∩ B) / P(B)      ...(1)
P(B|A) = P(A ∩ B) / P(A)      ...(2)
```

Rearranging (2): `P(A ∩ B) = P(B|A) · P(A)`

Substituting into (1):

```
P(A|B) = P(B|A) · P(A) / P(B)
```

| Term | Symbol | Meaning |
|---|---|---|
| Prior | P(A) | Belief before evidence |
| Likelihood | P(B\|A) | How likely the evidence is, IF A is true |
| Evidence | P(B) | Overall likelihood of the evidence (normalizer) |
| Posterior | P(A\|B) | Belief after evidence |

Evidence (Law of Total Probability):
```
P(B) = P(B|A) · P(A) + P(B|¬A) · P(¬A)
```

---

## 🩺 The Famous Result — Rare Disease Paradox

Disease prevalence: 1 in 10,000. Test is 99% accurate both ways.
Patient tests positive.

```
P(Disease | Positive) ≈ 0.0098   →  less than 1%!
```

**Why:** the disease is so rare that false positives from the huge healthy population outnumber the rare true positives. The **prior controls the result far more than the test's "accuracy" does.**

If the disease were common (1 in 3) instead, the same test gives:
```
P(Disease | Positive) ≈ 0.98   →  98%!
```
Same test. Same accuracy. Wildly different trustworthiness — because the prior changed.

---

## ⚠️ Common Mistakes

1. **Confusing P(A|B) with P(B|A)** — the prosecutor's fallacy. They are NOT the same number.
2. **Forgetting to divide by the Evidence P(B)** — without it, you get a joint probability, not a valid conditional probability.
3. **Ignoring the prior (base rate)** — "99% accurate" tells you almost nothing about trustworthiness when the event is rare.

---

## 🔗 Why It Matters in ML — Naive Bayes

Naive Bayes classifiers combine **multiple independent pieces of evidence** by **multiplying their likelihoods together**:

```
P(Spam | link, "free", 3AM) ∝ P(link|Spam) × P("free"|Spam) × P(3AM|Spam) × P(Spam)
```

It's called "naive" because it assumes each signal is independent of the others — which isn't perfectly true in real life, but works surprisingly well in practice.

---

## 🎤 Interview Corner

**Q1: Explain Bayes' Theorem in simple terms.**
A way to update a belief when new evidence arrives. Name the 4 parts (prior, likelihood, evidence, posterior), give one real example, and connect it to Naive Bayes.

**Q2: A disease has 1% prevalence, test is 95% accurate both ways, patient tests positive — what's the real probability they have the disease?**
Walk through the formula live, compute P(Positive) including false positives from the healthy population, then explicitly explain why the result is lower than 95% — because the disease is rare.

---

## 🧪 Quiz Recap (Score: 6/10 — ⚑ Revisit Flag)

**Gaps to revisit:**
- How strongly the prior controls the final posterior (it's not a footnote — it's doing most of the work)
- How multiple pieces of evidence combine via **multiplication** in Naive Bayes

**Strengths:** Code logic (debugging the Law of Total Probability) — 2/2, fully solid.

---

## ✅ Today I Learned

- Bayes' Theorem updates a belief using new evidence: `Posterior = (Likelihood × Prior) / Evidence`
- A rare event + an imperfect test = a positive result far less trustworthy than the test's "accuracy" suggests
- Naive Bayes combines multiple independent evidences by multiplying their likelihoods together

---

**Tags:** `bayes theorem` `prior` `posterior` `naive bayes`
