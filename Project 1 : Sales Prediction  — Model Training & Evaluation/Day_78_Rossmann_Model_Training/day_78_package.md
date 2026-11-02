# Day 78 Publishing Package

## 01. LinkedIn Post

🚀 Day 78 of my 90-day Data Science journey: I trained my first real models for the Rossmann sales project, a Linear Regression baseline vs XGBoost.

What I did:

📏 Baseline: StandardScaler + LinearRegression. On the last 6 weeks: RMSE 1,199, MAE 866, R² 0.846.

⚡ XGBoost (200 trees): RMSE 1,054, which is 12% lower, with R² 0.881.

🔁 Cross-validation: because this is a forecast, I used 5 time-ordered windows (train on the past, test on the next 42 days) instead of shuffled folds. XGBoost RMSE: 1,043 ± 149. Linear Regression: 1,200 ± 161.

🔍 Error analysis: predictions track the diagonal but fall short on the biggest sales days. And one date (July 2) had an RMSPE of 0.49, while a typical day is 0.12.

Where this shows up in real life: any demand or sales forecast.

💡 Biggest insight: a plain store + weekday + promo average, with no machine learning, beat my Linear Regression in all 5 windows. XGBoost beat that average in 4 of 5 windows, but only by a small margin (RMSPE 0.158 to 0.161 vs 0.170), smaller than the window-to-window noise. The improvement is real but modest, and I would not have known without the simple baseline next to it.

(Note: models use mostly default settings, no tuning yet.)

➡️ Next up: Day 79, Project 1 visuals, README, and GitHub.

I'm still learning, and I'm sharing the notes, notebook, and code screenshots as I go.

🔗 GitHub:
[Add GitHub Repository Link Here]

#DataScience #MachineLearning #Python #XGBoost #Regression #TimeSeries #CrossValidation #SalesForecasting #LearningInPublic #90DayChallenge #DataScienceJourney #BeginnerFriendly #JupyterNotebook #Project

*Attach the 6 screenshots from `images/` to the post (the fold chart and actual-vs-predicted plot also work well).*

## 04. Folder Structure

```
Day_78_Rossmann_Model_Training/
│
├── notebook.ipynb
├── notes.md          (includes Quick Overview)
├── features.py       (Day 77 feature functions)
├── modeling.py       (pipeline, baseline, metrics)
├── data/
│   └── README.md     (train.csv and store.csv are NOT included, see this file)
└── images/
    ├── day_78_linear_baseline_metrics.png
    ├── day_78_xgboost_vs_baselines.png
    ├── day_78_cross_validation_mean_std.png
    ├── day_78_shuffled_vs_time_ordered_cv.png
    ├── day_78_worst_days_error_pattern.png
    ├── day_78_feature_importance_top5.png
    ├── fold_rmspe_comparison.png
    ├── actual_vs_predicted.png
    ├── residual_distribution.png
    ├── error_by_group.png
    └── feature_importance_xgboost.png
```

## 05. Commit Message

```
Day 78: Project 1 model training, Linear Regression vs XGBoost with time-based backtest
```

## 06. Repository Description

```
Day 78 of my 90-day data science journey: Rossmann sales models, XGBoost vs Linear Regression, time-based CV.
```

## 07. File Names

- `notebook.ipynb`
- `notes.md`
- `features.py`
- `modeling.py`
- `data/README.md`
- `images/day_78_linear_baseline_metrics.png`
- `images/day_78_xgboost_vs_baselines.png`
- `images/day_78_cross_validation_mean_std.png`
- `images/day_78_shuffled_vs_time_ordered_cv.png`
- `images/day_78_worst_days_error_pattern.png`
- `images/day_78_feature_importance_top5.png`
- `images/fold_rmspe_comparison.png`
- `images/actual_vs_predicted.png`
- `images/residual_distribution.png`
- `images/error_by_group.png`
- `images/feature_importance_xgboost.png`

## 08. SEO Keywords (GitHub topics)

`data-science` `python` `xgboost` `linear-regression` `cross-validation` `backtesting` `time-series` `sales-forecasting` `rossmann` `rmspe` `model-evaluation` `portfolio-project` `learning-journey` `90-day-challenge` `jupyter-notebook`

## 09. Optional Visuals

- `fold_rmspe_comparison.png`: the 4 methods in each of the 5 windows
- `actual_vs_predicted.png`: scatter with the perfect-prediction line
- `residual_distribution.png`: residuals and percentage errors
- `error_by_group.png`: RMSPE by weekday, promo, and store size
- `feature_importance_xgboost.png`: top 10 features
