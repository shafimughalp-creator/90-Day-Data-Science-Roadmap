# Day 80 Publishing Package

## 01. LinkedIn Post

📞 Day 80 of my 90-day Data Science journey: Project 2 begins, and this time I'm predicting which telecom customers will leave.

Before touching a model, I defined the problem and explored the data (7,043 customers).

What I did:

⚖️ Class imbalance: 26.5% of customers churned, about 2.8 to 1 against those who stayed. A model that always says "No" is 73.5% accurate and catches 0 of 1,869 churners. So accuracy is the wrong yardstick here. I will use recall, precision, F1, and PR-AUC.

📄 Contract type: month-to-month customers churn at 42.7%, one-year at 11.3%, two-year at 2.8%. The gap holds inside every tenure group, so it is not just a tenure effect.

⏳ Tenure: churn falls from 47.4% (0 to 12 months) to 9.5% (49 to 72 months).

🧹 Data trap: TotalCharges was stored as text. The 11 blanks were all brand-new customers with tenure 0.

📏 Baseline: a one-line rule, "month-to-month = will churn", catches 88.6% of churners but only 42.7% of its flags are right. Its accuracy (0.654) is lower than doing nothing (0.735).

Where this shows up in real life: subscription businesses, banks, telecoms, and any retention team.

💡 Biggest insight: churners pay more on average (median $80 vs $64), but inside DSL and inside fiber, higher charges go with lower churn. Fiber customers pay more and churn more, and customers without internet pay little and rarely leave. Mixing them makes price look like the cause. Always split by a second variable before believing a pattern.

(Everything here is an association, not proof of cause.)

➡️ Next up: Day 81, feature engineering and preprocessing.

I'm still learning, and I'm sharing the notes, notebook, and code screenshots as I go.

🔗 GitHub:
[Add GitHub Repository Link Here]

#DataScience #MachineLearning #Python #Churn #ClassImbalance #EDA #CustomerAnalytics #Classification #LearningInPublic #90DayChallenge #DataScienceJourney #BeginnerFriendly #JupyterNotebook #Project

*Attach the 6 screenshots from `images/` to the post (the violin plot and contract bar chart also work well).*

## 04. Folder Structure

```
Day_80_Churn_Problem_EDA/
│
├── notebook.ipynb
├── notes.md          (includes Quick Overview)
├── data/
│   └── README.md     (the CSV is NOT included, see this file)
└── images/
    ├── day_80_totalcharges_text_trap.png
    ├── day_80_class_imbalance.png
    ├── day_80_churn_by_contract.png
    ├── day_80_contract_vs_tenure.png
    ├── day_80_charges_vs_internet_service.png
    ├── day_80_rule_baselines.png
    ├── class_balance.png
    ├── churn_by_contract.png
    ├── churn_by_tenure.png
    ├── monthly_charges_violin.png
    ├── churn_vs_charges_by_internet.png
    ├── contract_by_tenure.png
    └── feature_association.png
```

## 05. Commit Message

```
Day 80: Project 2 churn prediction, problem definition, EDA, and class imbalance check
```

## 06. Repository Description

```
Day 80 of my 90-day data science journey: Telco churn prediction, problem definition, EDA, and class imbalance.
```

## 07. File Names

- `notebook.ipynb`
- `notes.md`
- `data/README.md`
- `images/day_80_totalcharges_text_trap.png`
- `images/day_80_class_imbalance.png`
- `images/day_80_churn_by_contract.png`
- `images/day_80_contract_vs_tenure.png`
- `images/day_80_charges_vs_internet_service.png`
- `images/day_80_rule_baselines.png`
- `images/class_balance.png`
- `images/churn_by_contract.png`
- `images/churn_by_tenure.png`
- `images/monthly_charges_violin.png`
- `images/churn_vs_charges_by_internet.png`
- `images/contract_by_tenure.png`
- `images/feature_association.png`

## 08. SEO Keywords (GitHub topics)

`data-science` `python` `churn-prediction` `customer-churn` `class-imbalance` `eda` `classification` `telco` `pandas` `matplotlib` `portfolio-project` `learning-journey` `90-day-challenge` `jupyter-notebook` `beginner-friendly`

## 09. Optional Visuals

- `monthly_charges_violin.png`: the violin plot the roadmap asks for
- `churn_by_contract.png`: churn rate per contract type
- `churn_vs_charges_by_internet.png`: the confounding picture (overall vs within service)
- `contract_by_tenure.png`, `churn_by_tenure.png`, `feature_association.png`, `class_balance.png`
