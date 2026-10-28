# Machine Learning: Phase 4 of my 90-Day Data Science Journey

Notebooks, notes, and code screenshots from **Days 48 to 75**, built while learning in public.
Every day has a Jupyter notebook, a `notes.md` written in plain language, and the data it uses.

## What is inside

| Day | Topic | Folder |
|-----|-------|--------|
| 48 | What Is Machine Learning? — The Mental Model | — |
| 49 | Train/Test Split & Data Leakage | — |
| 50 | Overfitting & Underfitting — Visual Intuition | — |
| 51 | Linear Regression — Math Intuition First | — |
| 52 | Linear Regression — sklearn Implementation | — |
| 53 | Regularization — Ridge & Lasso | — |
| 54 | Logistic Regression — Sigmoid & Classification Intuition | — |
| 55 | Logistic Regression — sklearn + Evaluation Metrics | — |
| 56 | KNN — Distance-Based Intuition | — |
| 57 | KNN — sklearn + Cross-Validation for K Selection | — |
| 58 | Decision Tree — Entropy & Information Gain Theory | — |
| 59 | Decision Tree — sklearn + Visualization | — |
| 60 | Random Forest — Ensemble & Bagging Theory | — |
| 61 | Random Forest — sklearn + Feature Importance | — |
| 62 | Cross-Validation — K-Fold Deep Dive | — |
| 63 | Hyperparameter Tuning — GridSearchCV | — |
| 64 | Hyperparameter Tuning — RandomizedSearchCV + Practical Tips | — |
| 65 | Feature Scaling — When & Which Scaler | — |
| 66 | Feature Engineering — Encoding Categorical Variables | [Day_66_Encoding_Categorical_Variables](./Day_66_Encoding_Categorical_Variables) |
| 67 | ROC Curve & AUC Score | [Day_67_ROC_Curve_and_AUC_Score](./Day_67_ROC_Curve_and_AUC_Score) |
| 68 | XGBoost — Boosting Theory & Why It Wins Kaggle | [Day_68_XGBoost_Boosting_Theory](./Day_68_XGBoost_Boosting_Theory) |
| 69 | K-Means Clustering — Unsupervised Learning | [Day_69_KMeans_Clustering](./Day_69_KMeans_Clustering) |
| 70 | K-Means — sklearn + Silhouette Score | [Day_70_KMeans_Silhouette_Score](./Day_70_KMeans_Silhouette_Score) |
| 71 | PCA — Dimensionality Reduction Intuition | [Day_71_PCA_Intuition](./Day_71_PCA_Intuition) |
| 72 | PCA — sklearn + Explained Variance | [Day_72_PCA_Explained_Variance](./Day_72_PCA_Explained_Variance) |
| 73 | sklearn Pipeline — Production-Ready ML | [Day_73_sklearn_Pipeline](./Day_73_sklearn_Pipeline) |
| 74 | ML Review — Compare All Algorithms on One Dataset | [Day_74_ML_Model_Comparison](./Day_74_ML_Model_Comparison) |
| 75 | Phase 4 Buffer — Drill Your Weak Spots | [Day_75_Phase4_Buffer](./Day_75_Phase4_Buffer) |

## Datasets: real or made up?

| Days | Dataset | Real or made up |
|------|---------|-----------------|
| 66, 67, 68, 69, 71 | Football players and matches | **Made up** (generated with a fixed random seed) |
| 70 | Mall-style customers | **Made up** (a lookalike of the Mall Customers data, same column names) |
| 72 | Handwritten digits (scikit-learn) | Real |
| 73, 74 | Titanic | Real |
| 75 | Breast cancer and diabetes (scikit-learn), Titanic | Real (breast cancer is downsampled so cancer is rare) |

Made-up data has the structure I built into it, so results on it (for example, "K=5 wins") are expected, not discoveries.

## Lessons from Phase 4

- **Compare against a baseline and read the spread.** XGBoost beat Random Forest by 0.003 AUC, but that was inside the fold-to-fold noise.
- **Features can matter more than the model.** Dropping one column (`Sex`) cost a Random Forest 0.109 AUC.
- **Pipelines prevent leakage.** Every preprocessing step is fitted on training data only.
- **Accuracy can hide failure.** A model with 97.9% accuracy still missed 7 of 30 cancers at the default threshold.
- **More complex is not better.** On the diabetes data, a straight line beat degree-2 and degree-3 curves in cross-validation.
- **PCA is not magic.** On real digit images, keeping 95% of the variance still needed 40 of 64 columns.

## How to run

Tested with Python 3.12, scikit-learn 1.8, pandas 3.0, and XGBoost 3.4.

```bash
git clone <this-repo-url>
cd <repo-folder>
python -m venv .venv
source .venv/bin/activate        # on Windows: .venv\Scripts\activate
pip install -r requirements.txt
jupyter notebook
```

Open any `Day_XX_.../notebook.ipynb` and choose **Run All**. Each notebook reads the data files inside its own folder.

## About

I am a BS Artificial Intelligence student building toward a data science career.
I post one day at a time on LinkedIn, and I try to report results honestly, including the ones that did not go my way.
