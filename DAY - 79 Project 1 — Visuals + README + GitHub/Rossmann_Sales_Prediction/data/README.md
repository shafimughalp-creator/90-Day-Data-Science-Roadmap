# Data

The Rossmann files are **not included** in this repo.

## Files needed
- `train.csv` (about 1 million rows of daily sales)
- `store.csv` (1,115 rows of store details)

## How to get them
1. **From Kaggle (official):** the "Rossmann Store Sales" competition, Data tab: https://www.kaggle.com/c/rossmann-store-sales/data
   You need a free Kaggle account and must accept the competition rules. Put `train.csv` and `store.csv` in this `data/` folder.
2. **Or just run the notebooks.** If the files are missing from `data/`, each notebook downloads them from a public copy on GitHub
   (the `BASE` link in the loading cell). This needs an internet connection.

## Note on sharing
The data belongs to Rossmann and the Kaggle competition. Check the competition rules before sharing the files yourself.
This is why `data/*.csv` is listed in `.gitignore`.
