
# Jupyter Best Practices & DS Project Structure

## Quick Overview
- Today's topic: how to structure a Jupyter/Colab notebook the way employers and teammates actually expect
- What I learned: notebook flow order, one-concept-per-cell discipline, "why not what" commenting, and setting up a proper DS project folder structure
- Tools used: Google Colab, pandas, numpy, matplotlib, os

## Introduction
- A notebook is a portfolio artifact, not just scratch work — messy notebooks quietly disqualify candidates before an interview even happens
- Day 32's EDA project and Day 33's Git workflow are only as strong as the notebooks sitting inside them
- Since I work mostly in Google Colab, everything below applies directly — Colab is Jupyter, just running in the cloud with a temporary filesystem

## Definitions
- **Cell**: one unit of a notebook — either Markdown (text) or Code (executable)
- **Kernel state**: the memory of variables/functions currently loaded — can get out of sync with what's actually written top-to-bottom in the notebook
- **Restart & Run All**: clears kernel state and re-runs every cell from scratch, top to bottom — the only real way to confirm a notebook works
- **DS project folder structure**: the standard `data/ notebooks/ src/ outputs/ README.md` layout

## Important Concepts
- Standard notebook flow: Title → Objective → Imports → Theory → Examples → Practice → Summary
- One concept per cell — if a cell needs more than one sentence to describe, it should be split
- Comments explain *why* a decision was made, not restate *what* the line of code does
- Folder structure should exist before the first cell is written, not bolted on afterward
- Colab has no persistent local filesystem — the GitHub repo is the real home of the project, the Colab session is temporary

## Step-by-Step Explanation
1. Set up the notebook skeleton first (empty Markdown headers), before writing any code
2. Write imports in a single dedicated cell at the top
3. For each new idea (load data, clean data, inspect data, visualize data), open a new cell and lead with a one-line Markdown "why"
4. Before pushing to GitHub, restart the session and run all cells top to bottom to catch hidden state bugs
5. Push into the standard folder structure — notebook goes in `notebooks/`, data in `data/` (gitignored if raw), output plots in `outputs/`

## Examples
- Applied the whole flow to a mini EDA pass on the FC Lahore Lions squad dataset: load → info → missing values → describe → one goals-per-player bar chart, each step in its own cell with a "why" above it
- Contrasted this against a single messy cell doing load + clean + transform + filter + plot all at once, to make the difference concrete

## Common Mistakes
- Cramming multiple operations (load, clean, filter, plot) into one cell
- Skipping "Restart & Run All" before pushing — code that "works" only because of execution order, not real top-to-bottom logic
- Comments that restate the code instead of explaining the reasoning
- Setting up the folder structure after the project is already messy, instead of before starting

## Interview Questions
- "Walk me through how you'd structure a new EDA notebook from scratch." — answer: Title → Objective → Imports → Theory → Examples → Practice → Summary, one concept per cell
- "Why does 'Restart & Run All' matter before submitting a notebook?" — answer: catches hidden state bugs caused by out-of-order cell execution
- "How do you keep a Colab notebook connected to version control given it has no persistent filesystem?" — answer: clone the GitHub repo into the Colab session and commit/push from inside it, or use Save a copy in GitHub

## Key Takeaways
- Notebook structure is not decoration — it's what makes a stranger able to follow your thinking
- One concept per cell = faster debugging, easier review
- Comment the why, not the what
- Set up the folder structure before starting, not after
- In Colab, the GitHub repo is the permanent home of the work, not the session

## Summary
Day 34 was about discipline, not new syntax — turning working code into a notebook someone else (or future me) can actually read and trust. Applied every rule to a real mini EDA on the FC Lahore Lions dataset, and set up the Colab → GitHub workflow to carry this forward from Day 33.
