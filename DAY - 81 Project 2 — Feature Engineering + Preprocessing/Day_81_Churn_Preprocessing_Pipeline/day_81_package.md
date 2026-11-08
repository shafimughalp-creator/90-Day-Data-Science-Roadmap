# Day 81 Publishing Package

## 01. LinkedIn Post

🧰 Day 81 of my 90-day Data Science journey: Project 2 preprocessing. I turned the raw churn table into one leak-free pipeline, and I caught a silent bug on the way.

What I did:

🪤 The trap: the standard map({"Yes": 1, "No": 0}) quietly turned 1,526 values into NaN in each of 6 columns (OnlineSecurity, TechSupport, and more). Those columns have a third value, "No internet service". I replaced it with "No", since the same information already lives in InternetService.

🔢 One-hot encoding with drop_first: 4 columns became 9, for 24 features in total.

🔗 One pipeline: clean, then ColumnTransformer, then XGBClassifier(scale_pos_weight=3). It even scored a brand-new customer with a payment method it had never seen and a blank TotalCharges.

⚖️ Class weights: recall went from 0.52 to 0.82 and precision from 0.67 to 0.51, but ROC-AUC stayed at 0.847. So weights shift the balance, they do not rank customers better. Threshold tuning is next.

🧪 Three new features (add-on count, autopay, average monthly spend): no help. PR-AUC 0.665 vs 0.663, better in only 5 of 15 folds.

🔒 The test set stays untouched until the final evaluation.

Where this shows up in real life: any model that must score messy new data.

💡 Biggest insight: the pipeline beat my simple "month-to-month = churn" rule on F1 (0.629 vs 0.577), but the most useful thing I did today was check for silent missing values after an encoding step.

➡️ Next up: Day 82, model comparison and the best model.

I'm still learning, and I'm sharing the notes, notebook, and code screenshots as I go.

🔗 GitHub:
[Add GitHub Repository Link Here]

#DataScience #MachineLearning #Python #ScikitLearn #XGBoost #Pipeline #Preprocessing #FeatureEngineering #ClassImbalance #LearningInPublic #90DayChallenge #DataScienceJourney #BeginnerFriendly #JupyterNotebook

*Attach the 6 screenshots from `images/` to the post (`pipeline_overview.png` also works well).*

## 04. Folder Structure

```
Day_81_Churn_Preprocessing_Pipeline/
│
├── notebook.ipynb
├── notes.md          (includes Quick Overview)
├── churn_pipeline.py (cleaning functions and the pipeline builder)
├── data/
│   └── README.md     (the CSV is NOT included, see this file)
└── images/
    ├── day_81_drop_id_numeric_totalcharges.png
    ├── day_81_no_internet_service_trap.png
    ├── day_81_one_hot_drop_first.png
    ├── day_81_full_pipeline_built.png
    ├── day_81_class_weight_comparison.png
    ├── day_81_new_features_effect.png
    ├── pipeline_overview.png
    ├── class_weight_comparison.png
    ├── engineered_features_effect.png
    └── feature_importance_churn.png
```

## 05. Commit Message

```
Day 81: Project 2 churn preprocessing, one-hot encoding, and a leak-free XGBoost pipeline
```

## 06. Repository Description

```
Day 81 of my 90-day data science journey: churn preprocessing, one leak-free sklearn pipeline, and class weights.
```

## 07. File Names

- `notebook.ipynb`
- `notes.md`
- `churn_pipeline.py`
- `data/README.md`
- `images/day_81_drop_id_numeric_totalcharges.png`
- `images/day_81_no_internet_service_trap.png`
- `images/day_81_one_hot_drop_first.png`
- `images/day_81_full_pipeline_built.png`
- `images/day_81_class_weight_comparison.png`
- `images/day_81_new_features_effect.png`
- `images/pipeline_overview.png`
- `images/class_weight_comparison.png`
- `images/engineered_features_effect.png`
- `images/feature_importance_churn.png`

## 08. SEO Keywords (GitHub topics)

`data-science` `python` `churn-prediction` `scikit-learn` `sklearn-pipeline` `column-transformer` `one-hot-encoding` `xgboost` `class-imbalance` `feature-engineering` `data-preprocessing` `portfolio-project` `learning-journey` `90-day-challenge` `jupyter-notebook`

## 09. Optional Visuals

- `pipeline_overview.png`: the whole pipeline in one picture
- `class_weight_comparison.png`: recall/precision change vs unchanged ranking quality
- `engineered_features_effect.png`: new features vs base features
- `feature_importance_churn.png`: top 10 features
