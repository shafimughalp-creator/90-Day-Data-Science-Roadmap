[notes.md](https://github.com/user-attachments/files/34391049/notes.md)
# Day 79: Project 1 — Visuals + README + GitHub

## Quick Overview
- **Topic:** Finishing Project 1 (Rossmann sales prediction): five publication-quality figures, a README, a clean repo structure, and getting it ready for GitHub
- **What I learned:** A project is only as good as how easily someone else can read it, trust it, and run it
- **Tools:** Python, matplotlib (`seaborn-v0_8-darkgrid` style), pandas, Jupyter Notebook, Git
- **Deliverable:** `Rossmann_Sales_Prediction.zip`, a ready-to-push repo with 4 notebooks, `src/`, `outputs/`, `README.md`, `requirements.txt`, and `.gitignore`

## Introduction
- Days 76 to 78 produced the analysis. Today I turned it into something other people can open
- Think of a shop window: the products can be great, but nobody walks in if the window is a mess
- A hiring manager might spend 2 minutes on a repo, so the README and the pictures have to do the talking

## Definitions
- **Publication-quality figure:** a chart that makes sense on its own (title, labeled axes, annotations, readable fonts, source)
- **Annotation:** text or an arrow on the chart that points at what matters
- **Colorblind-safe palette:** colors that stay distinguishable for color-blind viewers (I used the Okabe-Ito colors)
- **README:** the front page of a repo (what it is, what was found, how to run it)
- **Reproducibility:** someone else can run the code and get the same numbers
- **`requirements.txt`:** the list of packages needed to run the project
- **`.gitignore`:** a list of files Git should not track (here, the raw data)
- **Commit / remote / push:** save a snapshot / the online copy / send your snapshots there

## Important Concepts
- **Rules I followed for every figure**
  - A title that says what the chart shows, and only what the data supports
  - Labeled axes, one consistent color per method, and a source line
  - Annotations whose numbers are **computed from the data** (no typed-in numbers that could go stale)
  - One style for all five: `plt.style.use("seaborn-v0_8-darkgrid")`
- **The five figures and what each one says**
  - Figure 1: sales per open store were steady, and the 2014 dip in total sales came from 180 stores missing for the same 184 days (stores open per day 937 to 787, sales per open store 7,202 to 7,520)
  - Figure 2: promo uplift by weekday, +57% (Mon), +45%, +37%, +32%, +22% (Fri), no promos on weekends
  - Figure 3: model comparison across 5 backtest windows, mean RMSPE plain average 0.170, Linear Regression 0.193, XGBoost 0.161, XGBoost log target 0.158, and XGBoost beats the plain average in 4 of 5 windows
  - Figure 4: actual vs predicted, of 884 rows with sales above 15,000, 68% were predicted too low (median predicted / actual 0.95)
  - Figure 5: daily error, the three worst days (2015-07-02 0.492, 2015-07-04 0.401, 2015-07-01 0.267) vs a typical day of 0.123
- **Fixes after looking at my own figures**
  - Figure 2: the Sunday note and the "no promo" text overlapped the legend and a bar, so I moved them
  - Figure 4: pale points disappeared against the shaded background, so I changed the color map and removed the shading
  - Figure 5: the "typical day" label sat on top of bars, so I moved it into the legend
  - Figure 4's first title said the model "under-predicts" the biggest days, but the data (68% too low, a median miss of about 5%) supports "tends to under-predict", so I softened it
- **README structure (what each part answers)**
  - Problem Statement: what are we predicting and how is it scored?
  - Dataset: where does the data come from and how big is it?
  - Approach: what steps did I take?
  - Key Findings: what did I learn?
  - Results table: how well did each method do (mean +/- std)?
  - How to Run: how can someone reproduce it?
  - Limitations and Next Steps: what is missing, honestly?
  - The README opens with the most important figure (model comparison) so the result is visible in seconds
- **Repo structure**
  - `notebooks/` numbered `01` to `04`, in the order to run them
  - `src/` for reusable code (`features.py`, `modeling.py`) so notebooks stay short
  - `outputs/figures/` for the final five figures, `outputs/results/` for saved metrics
  - `data/` holds only a README, because Rossmann/Kaggle data should not be re-shared, so `data/*.csv` is in `.gitignore`
- **Reproducibility check (done)**
  - I re-ran all four notebooks, in order, from inside the final folder structure: no errors
  - The numbers matched my earlier results (for example, plain-average RMSPE 0.147 on the last window, Linear baseline RMSE 1,199)
  - Run time on one CPU core: about 10 s, 2.5 min, 4 min, and 20 s

## Step-by-Step Explanation
- **Step 1:** Decide the 5 figures that tell the story of the project
- **Step 2:** Set one style and one color palette for all of them
- **Step 3:** Compute every number used in an annotation from the data
- **Step 4:** Look at each figure and fix overlaps and low contrast
- **Step 5:** Organize the repo: notebooks, src, data, outputs
- **Step 6:** Write the README (hero figure first, results table, how to run, limitations)
- **Step 7:** Add `requirements.txt` and `.gitignore`
- **Step 8:** Re-run every notebook from the final structure to check it works
- **Step 9:** Push to GitHub and check how the README looks on the site

## GitHub: Push Checklist (you do this part)
```
cd Rossmann_Sales_Prediction
git init
git add .
git status            # check: no .csv files should be listed
git commit -m "Project 1: Rossmann sales prediction"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```
- Create an empty repo on GitHub first (no README, so there is no conflict)
- After pushing, open the repo page and check that the figures show in the README
- Fill in the `[Add your name and LinkedIn link here]` line in the README
- Add the repo description and topics (see the package file)
- Optional: add a `LICENSE` file if you want others to reuse the code

## Examples
- **Practice (a figure that tells the story):** Figure 1 does it with one title, one shaded window, and one text box with three numbers
- **Mini challenge (README in 2 minutes):** can a stranger understand the problem, the result, and how to run it by reading only the top half of the README?

## Common Mistakes
- Charts with a default title and no annotation, so the reader has to guess the point
- Typing numbers into annotations by hand (they go stale when the data changes)
- Overlapping labels and legends
- Titles that claim more than the data shows
- Committing the raw data, or committing nothing that explains where to get it
- A README with no results table, no "how to run", and no limitations
- Pushing without re-running the notebooks from scratch

## Interview Questions
- Walk me through this project in two minutes
- Why did you use a time-ordered backtest instead of a random split?
- What would you do with more time?
- How would someone reproduce your results?
- Why did you leave the data out of the repo?
- Which of your figures is most important, and why?

## Key Takeaways
- Figures and README are part of the analysis, not decoration
- Compute annotations from data, and check every figure by eye
- Lead the README with the result, and be honest about limits
- Structure the repo so a stranger can run it in order
- Re-run everything from scratch before you publish

## Summary
- Built 5 clear figures with one style and a colorblind-safe palette
- Wrote a README with problem, data, approach, findings, results, and how to run
- Organized the project into numbered notebooks, `src/`, `data/`, and `outputs/`
- Re-ran all notebooks from the final structure and the numbers matched
- Next: Day 80 starts Project 2 (Churn Prediction: EDA + class imbalance)
