# Day 68 Publishing Package

## 01. LinkedIn Post

🚀 Day 68 of my 90-day Data Science journey: why does XGBoost win so many Kaggle competitions?

Today I learned boosting theory and trained my first XGBoost model.

What I learned:

🔁 Boosting: trees are trained one after another, and each new tree fixes the mistakes of the ones before it. Bagging (Random Forest) trains trees in parallel instead.

📉 Gradient boosting: each new tree is fit to the residuals, the leftover errors. I did it by hand and watched the error drop from 2.87 to 1.82 in just 3 trees.

⚡ XGBoost: adds built-in regularization, speed, and native handling of missing values.

🌲 XGBoost vs Random Forest: same accuracy (0.715), but AUC was 0.764 vs 0.747 on my football data.

Where this shows up in real life: credit risk, fraud detection, churn prediction, and ranking systems.

💡 Biggest insight: tuning mattered more than the model name. A shallower tree (max_depth=2) beat my default, and a high learning rate (0.5) dropped AUC from 0.764 to 0.699.

➡️ Next up: Day 69, K-Means Clustering.

I'm still learning, and I'm sharing the notes, notebook, and code screenshots as I go.

🔗 GitHub:
[Add GitHub Repository Link Here]

#DataScience #MachineLearning #Python #XGBoost #GradientBoosting #ScikitLearn #LearningInPublic #90DayChallenge #DataScienceJourney #BeginnerFriendly #JupyterNotebook #AI #Kaggle #TabularData

*Attach the 6 screenshots from `images/` to the post.*

## 04. Folder Structure

```
Day_68_XGBoost_Boosting_Theory/
│
├── notebook.ipynb
├── notes.md          (includes Quick Overview at top)
├── dataset.csv
└── images/
    ├── day_68_boosting_by_hand_residuals.png
    ├── day_68_xgbclassifier_fit.png
    ├── day_68_feature_importances.png
    ├── day_68_xgboost_vs_random_forest.png
    ├── day_68_missing_values_native.png
    ├── day_68_tuning_max_depth.png
    └── xgboost_feature_importances.png
```

## 05. Commit Message

```
Day 68: Learned XGBoost and Boosting Theory for Machine Learning
```

## 06. Repository Description

```
Day 68 of my 90-day data science journey: boosting theory and XGBoost vs Random Forest on football data.
```

## 07. File Names

- `notebook.ipynb`
- `notes.md`
- `dataset.csv`
- `images/day_68_boosting_by_hand_residuals.png`
- `images/day_68_xgbclassifier_fit.png`
- `images/day_68_feature_importances.png`
- `images/day_68_xgboost_vs_random_forest.png`
- `images/day_68_missing_values_native.png`
- `images/day_68_tuning_max_depth.png`
- `images/xgboost_feature_importances.png`

## 08. SEO Keywords (GitHub topics)

`data-science` `python` `xgboost` `gradient-boosting` `boosting` `random-forest` `machine-learning` `scikit-learn` `tabular-data` `learning-journey` `90-day-challenge` `jupyter-notebook` `beginner-friendly`

## 09. Optional Visuals

- `xgboost_feature_importances.png`: bar chart of which columns XGBoost used most
