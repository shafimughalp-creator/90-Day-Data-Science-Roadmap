# Day 6 — Probability Basics for Data Science

## 🎯 Goal
Understand core probability concepts using a football-match analogy: sample space, complement rule, independent/dependent events, joint probability, mutually exclusive events, and conditional probability.

---

## 1. What is Probability?

```
P(A) = (favorable outcomes) / (total outcomes)
```

Football example: Team played 10 matches → 6 Wins, 2 Draws, 2 Losses.
```
P(Win) = 6 / 10 = 0.6
```

## 2. Sample Space & Events
- **Sample Space (S)**: all possible outcomes → {Win, Draw, Loss}
- **Event**: a specific outcome we care about → "Team wins"

## 3. Complement Rule
```
P(A') = 1 - P(A)
```
If P(Win) = 0.6 → P(NOT Win) = 0.4

⚠️ **Key catch**: `P(NOT Win)` = P(Draw OR Loss) combined — it does NOT tell you the breakdown between Draw and Loss individually. Need separate `.count()` calls for that.

## 4. Independent vs Dependent Events
- **Independent**: one event has zero effect on the other (e.g., Win vs Rain)
- **Dependent**: one event changes the probability of the other (e.g., Star striker injured → affects Win chance)

## 5. Joint Probability (AND) — Independent Events
```
P(A and B) = P(A) × P(B)        [only valid if independent]
```
Example: P(Win) = 0.6, P(Rain) = 0.3 → P(Win AND Rain) = 0.18

## 6. Mutually Exclusive Events & OR Rule
- **Mutually exclusive**: events that can't happen together (Win and Loss in the same match)
```
P(A or B) = P(A) + P(B)                          [mutually exclusive only]
P(A or B) = P(A) + P(B) - P(A and B)              [general rule, any events]
```

## 7. Conditional Probability
```
P(A | B) = P(A and B) / P(B)
```
Football example: P(Win) overall = 0.6, but P(Win | Home Game) = 0.83 — home advantage *changes* the probability once we know the venue.

## 8. Joint vs Conditional vs Marginal

| Term | Question | Football example |
|---|---|---|
| Marginal | P(A) alone | P(Win) = 0.6 |
| Joint | P(A and B) together | P(Win and Rain) = 0.18 |
| Conditional | P(A given B happened) | P(Win \| Home) = 0.83 |

---

## ⚠️ Common Mistakes (logged from today's practice)

1. **Treating dependent events as independent** — can't multiply P(A)×P(B) unless truly independent.
2. **Confusing "independent" with "mutually exclusive"** — different concepts entirely.
3. **Mislabeling the complement** — `1 - P(Win)` is P(Draw OR Loss) combined, not P(Loss) alone. (Made this mistake twice in practice today — flagged as a recurring weak point.)
4. **Mixing up P(A\|B) and P(B\|A)** — e.g., P(Win\|Home) ≠ P(Home\|Win). These ask about two different "universes" (fix venue vs fix result). This is the setup for Bayes' Theorem (later in roadmap). Showed up 3 times in today's practice — biggest flag for review.

---

## 🧠 Quiz Recap (Day 6)

1. P(Win) = 0.6, P(NOT Win) = 0.4 (9 Win / 4 Draw / 2 Loss out of 15)
2. P(Win AND Clean Sheet) = 0.6 × 0.5 = **0.3** (independence assumption)
3. True or False — P(Win) and P(Loss) mutually exclusive → **TRUE** (can't both happen in one match)
4. P(Win | Away) — practice exposed a real bug: mismatched list lengths in `zip()` silently truncate data, and looping over the wrong list (raw list instead of zipped pairs) crashes with an unpacking error. Fixed version filters the zipped `(result, venue)` pairs correctly.
5. P(Win\|Home) ≠ P(Home\|Win) — fixing venue vs fixing result are two different "starting groups" to count within.

---

## 🔁 Revisit List
- [ ] P(A\|B) vs P(B\|A) — direction confusion (came up 3x today)
- [ ] Labeling: a *ratio* variable should never be printed with a *count*-style label, and vice versa

## ⏭️ Next Up
Day 7 — continuing Phase 1 (Statistics) per roadmap.
