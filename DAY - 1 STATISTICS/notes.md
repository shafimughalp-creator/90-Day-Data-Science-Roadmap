# Day 1 — Why Statistics? The DS Foundation

## Why this matters
Every ML model, A/B test, and "insight" in a report is built on statistics.
Without it, you're just running code blindly — you don't know *why* it works.

---

## 1. Population vs Sample
- **Population** = the entire group you care about (e.g. all university students in Pakistan).
- **Sample** = a smaller, manageable subset you actually collect data from.
- We almost always work with samples because studying a full population is too
  expensive/slow/impossible.
- A sample average is used to **estimate** the population value — this is the
  core idea behind inferential statistics.

## 2. Sampling Bias
- A sample must be **representative**, not just "accurate" or "large."
- A big sample collected the wrong way (e.g. surveying only one university in
  one city to represent "all Pakistani students") is still biased.
- Bigger sample size does NOT fix a bad sampling method — only better
  selection does.

## 3. Descriptive vs Inferential Statistics
| | Descriptive | Inferential |
|---|---|---|
| Job | Summarize the data you have | Generalize beyond the data you have |
| Tools | Mean, median, mode, std dev | Confidence intervals, hypothesis tests |
| Question | "What happened in my data?" | "What's likely true beyond my data?" |

## 4. Variable Types
```
VARIABLES
├── NUMERICAL (math makes sense)
│     ├── Continuous → any value in a range (height, weight)
│     └── Discrete   → whole/countable values (siblings, cars owned)
└── CATEGORICAL (labels, no real math)
      ├── Nominal → no natural order (city: Lahore, Karachi)
      └── Ordinal → has a natural order (rating: Low, Medium, High)
```
- Using the wrong type breaks analysis — e.g. averaging city names is meaningless,
  even if you encode them as numbers.

## 5. NumPy Arrays
- Plain Python lists don't support real math (`list * 2` duplicates the list,
  it doesn't multiply each value).
- NumPy arrays support **vectorized operations** — apply a math operation to
  every element at once, fast, with no manual loop.
- NumPy is the foundational data structure under pandas, scikit-learn, and
  most of data science.

---

## Common Mistakes to Avoid
1. Calling `np.mean()` on nominal categorical data (e.g. city names) — meaningless.
2. Treating ordinal data (Low/Medium/High) as if order doesn't matter — loses real signal.
3. Using plain Python lists for math instead of NumPy arrays.

## Interview Questions Practiced
1. **Population vs Sample, and why it matters in DS** — sampling is necessary
   because measuring a full population is rarely feasible; the risk is
   sampling bias if the sample isn't representative.
2. **How to decide if a variable is categorical or numerical** — check whether
   meaningful arithmetic applies; this decision determines which statistics/
   charts/model treatments are valid.

## Quiz Score
9/10 — no revisit flag needed. One correction: a sample of 300 students from a
single Lahore university is NOT representative of "Pakistani university
students" nationally — this was a sampling bias example, not an exception to it.

## TL;DR
- A sample must be representative, not just large, to avoid bias.
- Variable type decides which statistics/charts are valid.
- NumPy enables real vectorized math; plain lists don't.
