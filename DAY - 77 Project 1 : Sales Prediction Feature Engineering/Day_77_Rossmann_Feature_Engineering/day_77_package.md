# Day 77 Publishing Package

## 01. LinkedIn Post

🧩 Day 77 of my 90-day Data Science journey: feature engineering for my Rossmann sales project, where the hard part was deciding which features I am even allowed to use.

What I did:

📅 Date features: year, month, day, day of week, week of year, is_weekend, is_month_end.

⏪ Lag features: my roadmap suggested sales 1 day ago and 7 days ago. But I forecast 6 weeks ahead, so those lags are known for only 2.8% and 16.7% of my validation rows. Only lags of 42+ days are safe.

🔁 A guess I tested: promo status matches today's only 25% of the time one week ago, but 85% of the time two weeks ago. Promotions seem to alternate by week, so even-week lags carry more signal.

🧮 Encoding: one-hot encoding inside a pipeline, fitted on the past only.

🔥 Heatmap: dropped two duplicate features (DayOfWeek vs day_of_week at r = 1.0, month vs week_of_year at r = 0.96).

Where this shows up in real life: any forecast where the features must be known in advance.

💡 Biggest insight: features cut my error from 0.364 to 0.148, but a plain store + weekday + promo average already scored 0.147. And when I cheated with 1-day and 7-day lags, the score "improved" to 0.131, a number I could never reproduce in real forecasting. A better-looking score is not a better model.

➡️ Next up: Day 78, model training and evaluation.

I'm still learning, and I'm sharing the notes, notebook, and code screenshots as I go.

🔗 GitHub:
[Add GitHub Repository Link Here]

#DataScience #MachineLearning #Python #FeatureEngineering #TimeSeries #SalesForecasting #Rossmann #LagFeatures #LearningInPublic #90DayChallenge #DataScienceJourney #BeginnerFriendly #JupyterNotebook #Project

*Attach the 6 screenshots from `images/` to the post (the heatmap and RMSPE bar chart also work well).*

## 04. Folder Structure

```
Day_77_Rossmann_Feature_Engineering/
│
├── notebook.ipynb
├── notes.md          (includes Quick Overview)
├── features.py       (reusable feature functions)
├── data/
│   └── README.md     (train.csv and store.csv are NOT included, see this file)
└── images/
    ├── day_77_date_features.png
    ├── day_77_lag_known_at_forecast_time.png
    ├── day_77_even_week_lags_promo.png
    ├── day_77_onehot_in_pipeline.png
    ├── day_77_drop_correlated_pairs.png
    ├── day_77_feature_sets_rmspe.png
    ├── correlation_heatmap.png
    └── feature_sets_rmspe.png
```

## 05. Commit Message

```
Day 77: Project 1 feature engineering, date features, lags, one-hot encoding
```

## 06. Repository Description

```
Day 77 of my 90-day data science journey: Rossmann feature engineering, lag features, and forecast-horizon checks.
```

## 07. File Names

- `notebook.ipynb`
- `notes.md`
- `features.py`
- `data/README.md`
- `images/day_77_date_features.png`
- `images/day_77_lag_known_at_forecast_time.png`
- `images/day_77_even_week_lags_promo.png`
- `images/day_77_onehot_in_pipeline.png`
- `images/day_77_drop_correlated_pairs.png`
- `images/day_77_feature_sets_rmspe.png`
- `images/correlation_heatmap.png`
- `images/feature_sets_rmspe.png`

## 08. SEO Keywords (GitHub topics)

`data-science` `python` `feature-engineering` `lag-features` `time-series` `sales-forecasting` `rossmann` `one-hot-encoding` `correlation` `scikit-learn` `portfolio-project` `learning-journey` `90-day-challenge` `jupyter-notebook` `beginner-friendly`

## 09. Optional Visuals

- `correlation_heatmap.png`: all features and Sales, with the two duplicate pairs visible
- `feature_sets_rmspe.png`: RMSPE for the five feature sets vs the Day 76 baseline
