[Uploading Day09_Hypothesis_Testing_Notes.md…]()
# Day 9 — Hypothesis Testing: Intuition & Null Hypothesis
**90-Day Data Science Roadmap | Statistics & Math Phase (Days 1–15)**

---

## 🧠 The One-Line Summary
> Hypothesis testing answers one question: **"Is this real, or is it just luck?"**

---

## 📋 Concepts Covered

| Concept | Status |
|---|---|
| Null Hypothesis (H0) | ✅ |
| Alternative Hypothesis (H1) | ✅ |
| p-value | ✅ |
| Significance Level (alpha) | ✅ |
| Type I Error (False Positive) | ✅ |
| Type II Error (False Negative) | ✅ |
| Reject vs Fail to Reject H0 | ✅ |
| One-tailed vs Two-tailed tests | ✅ |
| Sample size effect on p-value | ✅ (Round 4 bonus) |
| p-hacking / Multiple Comparisons | ✅ (Round 4 bonus) |

---

## 🔑 Core Concepts

### H0 and H1 — Two Competing Stories
- **H0 (Null Hypothesis)** = "Nothing changed. It's all just luck/randomness." — the *default assumption*
- **H1 (Alternative Hypothesis)** = "Something real happened. It's not just luck." — what we're trying to find evidence for

> ⚽ **VAR Analogy:** The referee's default call is always "no foul" (H0). VAR only overturns it when the evidence is convincing enough — that threshold is your alpha.

**Key rule:** H0 and H1 are **statements/claims**, NOT numbers. The 70% and 78% are observed values. H0 is the explanation *"that gap is just luck."*

---

### p-value
> **"If H0 were true, how likely is it I'd see this result purely by random chance?"**

- **Small p-value (e.g. 0.01)** → this result would rarely happen if H0 were true → hard to call it luck → **lean toward H1**
- **Large p-value (e.g. 0.77)** → this kind of result happens all the time under H0 → luck still explains it → **stick with H0**

#### ⚠️ Critical: What p-value does NOT mean
```
❌ WRONG: p-value = probability that H0 is true
✅ RIGHT:  p-value = probability of seeing THIS result, IF H0 were true
```

---

### Significance Level (alpha α)
The **cutoff line** you decide *before* looking at the data.

- Standard: **α = 0.05** (5%)
- **Decision Rule:**
  - `p-value ≤ α` → **Reject H0** (statistically significant)
  - `p-value > α`  → **Fail to reject H0** (not enough evidence)

> Stricter alpha (0.01) = harder to reject H0 = you need much stronger evidence before changing your mind.

---

### Type I vs Type II Error

|  | Reality: H0 True (no real effect) | Reality: H1 True (real effect exists) |
|---|---|---|
| **You say: Reject H0** | ❌ **Type I Error** — False Alarm | ✅ Correct |
| **You say: Fail to Reject H0** | ✅ Correct | ❌ **Type II Error** — Missed It |

- **Type I (α):** You said "real change!" but it was just luck. Controlled directly by your alpha level.
- **Type II (β):** You said "just luck" but a real change was happening. You missed it.
- **Which is worse?** Depends on stakes. In medicine, Type II (missing a real disease) is usually far more dangerous than Type I.

---

### Reject vs Fail to Reject — NEVER "Accept H0"

```
✅ "We fail to reject H0" = "Not enough evidence against H0"
❌ "We accept H0"         = WRONG — we never prove H0 true
❌ "H0 is definitely true" = WRONG — absence of proof ≠ proof of absence
```

> ⚽ **Blurry VAR analogy:** The replay was inconclusive — camera glitch, bad angle. The ref's original "no foul" call stands by default. That doesn't mean it was definitely not a foul — we just don't have enough evidence to overturn it.

---

### One-Tailed vs Two-Tailed Tests

- **Two-tailed:** "Did the coach *change* the penalty rate at all?" (testing both better OR worse)
- **One-tailed:** "Did the coach specifically *improve* the penalty rate?" (one direction only)

> ⚠️ You must decide this **before** looking at the data. Picking a tail after seeing which direction the data leans = quietly cheating your p-value (p-hacking).

---

## 💻 Code

### Setup & Data Generation
```python
import numpy as np
from scipy import stats

np.random.seed(42)

# FC Lahore Lions — penalty data
# Before new coach: 30 penalties, historical 70% success rate
penalties_before = np.random.binomial(1, 0.70, 30)

# After new coach: 30 penalties, true rate secretly improved to 78%
penalties_after  = np.random.binomial(1, 0.78, 30)

print("Before - success rate:", penalties_before.mean())
print("After  - success rate:", penalties_after.mean())
```

**Expected output:**
```
Before - success rate: 0.7666666666666667
After  - success rate: 0.7333333333333333
```
> 👀 "After" looks *lower* than "before" in raw numbers — exactly why we need a test instead of eyeballing. Small samples lie to your eyes.

---

### Running the Hypothesis Test
```python
# H0: no real difference in penalty success rate before vs after
# H1: there IS a real difference

t_stat, p_value = stats.ttest_ind(penalties_before, penalties_after)

print("t-statistic:", t_stat)
print("p-value    :", p_value)

alpha = 0.05
if p_value <= alpha:
    print("➡ Reject H0 — statistically significant difference")
else:
    print("➡ Fail to reject H0 — not enough evidence of a real difference")
```

**Expected output:**
```
t-statistic: 0.2933486193301556
p-value    : 0.7703027780947926
➡ Fail to reject H0 — not enough evidence of a real difference
```

**Reading this result:** p=0.77 means if the coach truly changed nothing, we'd see results like this 77% of the time by pure luck. That's not surprising at all — so we can't conclude the coach made a real difference.

> 🔑 Real lesson: we secretly baked in a true 8% improvement (70% → 78%), but with only 30 penalties, the noise is too loud to hear the signal. **A true effect can fail to reach significance if your sample is too small.**

---

## ⚠️ Common Mistakes

```python
# Mistake 1 — Misreading p-value
# ❌ WRONG: "p=0.77 means there's a 77% chance H0 is true"
# ✅ RIGHT:  "p=0.77 means: IF H0 were true, a result like this 
#            happens 77% of the time" — says nothing about whether H0 itself is true

# Mistake 2 — "Significant" ≠ "Important"
# ❌ WRONG: With 1,000,000 data points, even a 0.001% difference 
#           can become "statistically significant"
# ✅ RIGHT:  Always check effect size too, not just p-value
#           "Significant" = "probably real," NOT "big" or "meaningful"

# Mistake 3 — Picking the tail after seeing the data
# ❌ WRONG: See data leans "better," then decide to run one-tailed 
#           to get a smaller p-value → inflates false-positive rate
# ✅ RIGHT:  Decide one-tailed vs two-tailed BEFORE looking at results

# Mistake 4 — p-hacking / Multiple Comparisons
# ❌ WRONG: Run 20 tests, report the one that came back p=0.04
# ✅ RIGHT:  With 20 tests at α=0.05, you'd expect ~1 false positive 
#           by pure chance. Pre-register your hypothesis first.
```

---

## 🎤 Interview Corner

**Q: "Explain p-value to a non-technical person."**

> "A p-value tells you how surprising your result would be if nothing interesting were actually happening. A small p-value (like under 5%) means your result would be quite unusual if there were truly no effect — so we lean toward believing there IS an effect. A large p-value just means 'this could easily be random chance,' not that there's definitely no effect."

**Q: "What's the difference between Type I and Type II error?"**

> "Type I is a false alarm — you conclude there's an effect when there isn't one. Type II is a missed detection — you conclude there's no effect when there actually is one. Example: testing a new website button color. Type I = you roll it out thinking it boosted sales, but it didn't — wasted engineering effort. Type II = the color genuinely would have boosted sales, but your test missed it, so you leave money on the table."

**Q: "What happens to p-value as sample size increases?"**

> "Assuming a real effect exists, a larger sample size tends to produce a smaller p-value — because noise averages out and the signal becomes clearer to detect. This means massive datasets can make even tiny, practically meaningless effects look 'statistically significant.' Always check effect size alongside p-value."

---

## 🚩 Personal Revisit Flags

| Flag | Details |
|---|---|
| **Evidence vs Proof language** | Kept slipping into "proven"/"the data proves" across Rounds 1–4. Hypothesis testing gives **strong evidence**, never **100% proof**. Even p=0.002 has a 0.2% chance of being a fluke. |
| **H0/H1 labeling** | H0 and H1 are *claims/stories*, not numbers. The 70% and 78% are observations. H0 is the explanation ("just luck"), not the number itself. |

---

## 📌 Key Takeaway
> Hypothesis testing is how we stop overreacting to noise. Before firing a manager over 3 bad results, or crediting a coach for a lucky hot streak — run the numbers. Strong evidence is still not proof, but it's far better than gut feeling.

---

*Day 9 complete | Next: Day 10 — t-tests & z-tests (applying the framework)*
