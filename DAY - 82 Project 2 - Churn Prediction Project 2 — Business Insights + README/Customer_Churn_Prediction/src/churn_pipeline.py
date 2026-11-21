import numpy as np
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import FunctionTransformer, OneHotEncoder, StandardScaler
from xgboost import XGBClassifier

ADDONS = ["OnlineSecurity", "OnlineBackup", "DeviceProtection", "TechSupport", "StreamingTV", "StreamingMovies"]
YES_NO = ["Partner", "Dependents", "PhoneService", "PaperlessBilling"] + ADDONS
NUMERIC = ["tenure", "MonthlyCharges", "TotalCharges"]
BINARY = ["SeniorCitizen", "gender"] + YES_NO
CATEGORICAL = ["MultipleLines", "InternetService", "Contract", "PaymentMethod"]
ENGINEERED_NUMERIC = ["n_addons", "avg_monthly_spend"]
ENGINEERED_BINARY = ["autopay"]


def clean_telco(df):
    """Raw Telco table in, clean table out (no learned statistics, so it cannot leak)."""
    out = df.drop(columns=["customerID", "Churn"], errors="ignore").copy()
    out["TotalCharges"] = pd.to_numeric(out["TotalCharges"], errors="coerce")    # blanks -> NaN
    for col in ADDONS:
        out[col] = out[col].replace("No internet service", "No")
    for col in YES_NO:
        out[col] = out[col].map({"Yes": 1, "No": 0})
    out["gender"] = out["gender"].map({"Male": 1, "Female": 0})
    return out


def clean_and_engineer(df):
    """Same cleaning, plus three simple new features."""
    out = clean_telco(df)
    out["n_addons"] = out[ADDONS].sum(axis=1)                                      # how many add-on services
    out["autopay"] = out["PaymentMethod"].str.contains("automatic").astype(int)    # pays automatically
    out["avg_monthly_spend"] = out["TotalCharges"] / out["tenure"].where(out["tenure"] > 0)
    return out


def build_pipeline(scale_pos_weight=3, engineered=False):
    numeric = NUMERIC + (ENGINEERED_NUMERIC if engineered else [])
    binary = BINARY + (ENGINEERED_BINARY if engineered else [])
    prep = ColumnTransformer([
        ("num", Pipeline([("imputer", SimpleImputer(strategy="median")), ("scaler", StandardScaler())]), numeric),
        ("bin", "passthrough", binary),
        ("cat", OneHotEncoder(drop="first", handle_unknown="ignore", sparse_output=False), CATEGORICAL),
    ])
    model = XGBClassifier(n_estimators=200, learning_rate=0.05, max_depth=3,
                          scale_pos_weight=scale_pos_weight, random_state=42, eval_metric="logloss")
    return Pipeline([
        ("clean", FunctionTransformer(clean_and_engineer if engineered else clean_telco)),
        ("prep", prep),
        ("model", model),
    ])
