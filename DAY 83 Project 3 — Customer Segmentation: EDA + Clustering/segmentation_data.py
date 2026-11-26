"""Shared loading and scaling code for Project 3 (customer segmentation).

Day 84 builds it. Day 85 imports it again for K-Means and PCA.
"""
from pathlib import Path

import pandas as pd
from sklearn.preprocessing import StandardScaler

# Public copy of the Mall Customers dataset, used only if the file is not in data/
BASE = ("https://raw.githubusercontent.com/SteffiPeTaffy/machineLearningAZ/master/"
        "Machine%20Learning%20A-Z%20Template%20Folder/Part%204%20-%20Clustering/"
        "Section%2024%20-%20K-Means%20Clustering/Mall_Customers.csv")

FILE_NAMES = ["Mall_Customers.csv", "Mall_Customers (1).csv"]
RENAME = {"Genre": "Gender", "Annual Income (k$)": "Income", "Spending Score (1-100)": "Spending"}
NUMERIC = ["Age", "Income", "Spending"]       # the columns we cluster on (Gender is a label, not a number)


def load_mall(data_dir="data"):
    """Load the file from data/ if it is there, otherwise download the public copy. Returns clean column names."""
    for name in FILE_NAMES:
        local = Path(data_dir) / name
        if local.exists():
            return pd.read_csv(local).rename(columns=RENAME)
    return pd.read_csv(BASE).rename(columns=RENAME)


def scale_numeric(df, columns=NUMERIC):
    """StandardScaler on the chosen columns. Returns the scaled array and the fitted scaler.

    Clustering has no train/test split, so the scaler is fitted on all customers.
    """
    scaler = StandardScaler()
    return scaler.fit_transform(df[columns]), scaler
