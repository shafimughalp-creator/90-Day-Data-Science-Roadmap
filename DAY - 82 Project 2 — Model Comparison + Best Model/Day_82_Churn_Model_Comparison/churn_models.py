from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import FunctionTransformer, OneHotEncoder, StandardScaler

from churn_pipeline import BINARY, CATEGORICAL, NUMERIC, clean_telco


def build_model_pipeline(estimator):
    """clean_telco -> impute/scale numbers, pass 0/1 columns, one-hot categories -> estimator."""
    prep = ColumnTransformer([
        ("num", Pipeline([("imputer", SimpleImputer(strategy="median")), ("scaler", StandardScaler())]), NUMERIC),
        ("bin", "passthrough", BINARY),
        ("cat", OneHotEncoder(drop="first", handle_unknown="ignore", sparse_output=False), CATEGORICAL),
    ])
    return Pipeline([("clean", FunctionTransformer(clean_telco)), ("prep", prep), ("model", estimator)])
