# Day 82 Publishing Package

## 01. LinkedIn Post

🏆 Day 82 of my 90-day Data Science journey: I compared 3 models for customer churn. The result: a three-way near-tie, and a lesson about how to pick a winner honestly.

Before running anything, I set 3 rules: choose the model by cross-validation only, tune on the training data only, and look at the test set once.

What I found:

📊 Cross-validated ROC-AUC (5 folds x 3 repeats): Logistic Regression 0.846, XGBoost 0.847, Random Forest 0.828.

🔍 XGBoost beat Logistic Regression by just 0.0015, and by a margin smaller than the noise between folds. That is a tie. My rule picked XGBoost, but the simpler model would be a fine choice.

🌲 Random Forest overfit the most: 1.000 on training data vs 0.828 in cross-validation.

🎛️ GridSearchCV (27 settings): the top 10 settings spanned only 0.0023, while one score wobbles by about 0.013. Tuning gave almost nothing.

🧪 Test set, looked at once: ROC-AUC 0.846, with a 95% bootstrap interval of 0.823 to 0.867.

Where this shows up in real life: any model comparison before shipping a model.

💡 Biggest insight: on the ROC chart, my one-line rule from Day 80 ("month-to-month contract = will churn") sits almost on top of the model curves. A simple baseline is not a toy, it is the real benchmark.

➡️ Next up: Day 83, confusion matrix, business threshold, and insights.

I'm still learning, and I'm sharing the notes, notebook, and code screenshots as I go.

🔗 GitHub:
[Add GitHub Repository Link Here]

#DataScience #MachineLearning #Python #XGBoost #RandomForest #LogisticRegression #ModelSelection #ROCAUC #ChurnPrediction #LearningInPublic #90DayChallenge #DataScienceJourney #BeginnerFriendly #JupyterNotebook

*Attach the 6 screenshots from `images/` to the post (`roc_curves_three_models.png` also works well).*

## 04. Folder Structure

```
Day_82_Churn_Model_Comparison/
│
├── notebook.ipynb
├── notes.md          (includes Quick Overview)
├── churn_pipeline.py (cleaning functions, from Day 81)
├── churn_models.py   (one preprocessing pipeline for any model)
├── data/
│   └── README.md     (the CSV is NOT included, see this file)
└── images/
    ├── day_82_three_models_balanced_weights.png
    ├── day_82_cross_validated_roc_auc.png
    ├── day_82_is_the_ranking_real.png
    ├── day_82_roc_pooled_auc_and_rule.png
    ├── day_82_gridsearch_best_settings.png
    ├── day_82_final_test_evaluation.png
    ├── model_comparison_auc.png
    ├── roc_curves_three_models.png
    ├── grid_search_top10.png
    └── final_model_test_roc.png
```

## 05. Commit Message

```
Day 82: Project 2 model comparison, GridSearchCV tuning, and a one-time test-set evaluation
```

## 06. Repository Description

```
Day 82 of my 90-day data science journey: churn model comparison, ROC curves, GridSearchCV, and a clean test set.
```

## 07. File Names

- `notebook.ipynb`
- `notes.md`
- `churn_pipeline.py`
- `churn_models.py`
- `data/README.md`
- `images/day_82_three_models_balanced_weights.png`
- `images/day_82_cross_validated_roc_auc.png`
- `images/day_82_is_the_ranking_real.png`
- `images/day_82_roc_pooled_auc_and_rule.png`
- `images/day_82_gridsearch_best_settings.png`
- `images/day_82_final_test_evaluation.png`
- `images/model_comparison_auc.png`
- `images/roc_curves_three_models.png`
- `images/grid_search_top10.png`
- `images/final_model_test_roc.png`

## 08. SEO Keywords (GitHub topics)

`data-science` `python` `churn-prediction` `model-comparison` `roc-auc` `gridsearchcv` `xgboost` `random-forest` `logistic-regression` `cross-validation` `scikit-learn` `portfolio-project` `learning-journey` `90-day-challenge` `jupyter-notebook`

## 09. Optional Visuals

- `roc_curves_three_models.png`: three models and the one-line rule on one chart
- `model_comparison_auc.png`: cross-validated ROC-AUC with error bars (axis starts at 0.75)
- `grid_search_top10.png`: tuning barely changes the score
- `final_model_test_roc.png`: the test ROC curve with its bootstrap interval
