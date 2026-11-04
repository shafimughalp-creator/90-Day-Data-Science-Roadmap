import numpy as np
import pandas as pd
from sklearn.base import BaseEstimator, RegressorMixin, TransformerMixin
from sklearn.compose import ColumnTransformer, TransformedTargetRegressor
from sklearn.impute import SimpleImputer
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

NUMERIC = ["DayOfWeek", "Promo", "SchoolHoliday", "year", "day", "week_of_year", "is_weekend",
           "is_month_end", "CompetitionDistance", "Promo2", "lag_42", "lag_49",
           "store_mean", "store_dow_mean"]
CATEGORICAL = ["store_type", "assortment", "state_holiday"]
INPUT_COLUMNS = [c for c in NUMERIC if c not in ("store_mean", "store_dow_mean")] + CATEGORICAL + ["Store", "day_of_week"]


class StoreHistory(BaseEstimator, TransformerMixin):
    """Adds each store's average target (and store + weekday average), learned from the data it is fitted on."""

    def fit(self, X, y):
        d = X[["Store", "day_of_week"]].copy()
        d["y"] = np.asarray(y)
        self.overall_ = d["y"].mean()
        self.store_ = d.groupby("Store")["y"].mean()
        self.store_dow_ = d.groupby(["Store", "day_of_week"])["y"].mean()
        return self

    def transform(self, X):
        out = X.copy()
        out["store_mean"] = out["Store"].map(self.store_).fillna(self.overall_)
        keys = pd.MultiIndex.from_frame(out[["Store", "day_of_week"]])
        out["store_dow_mean"] = self.store_dow_.reindex(keys).to_numpy()
        out["store_dow_mean"] = out["store_dow_mean"].fillna(out["store_mean"])
        return out


class GroupMeanBaseline(BaseEstimator, RegressorMixin):
    """The Day 76 baseline: average sales for the same store, weekday, and promo flag (no machine learning)."""

    def fit(self, X, y):
        d = X[["Store", "DayOfWeek", "Promo"]].copy()
        d["y"] = np.asarray(y)
        self.overall_ = d["y"].mean()
        self.store_ = d.groupby("Store")["y"].mean()
        self.store_dow_ = d.groupby(["Store", "DayOfWeek"])["y"].mean()
        self.store_dow_promo_ = d.groupby(["Store", "DayOfWeek", "Promo"])["y"].mean()
        return self

    def predict(self, X):
        level1 = X["Store"].map(self.store_).fillna(self.overall_)
        k2 = pd.MultiIndex.from_frame(X[["Store", "DayOfWeek"]])
        level2 = pd.Series(self.store_dow_.reindex(k2).to_numpy(), index=X.index).fillna(level1)
        k3 = pd.MultiIndex.from_frame(X[["Store", "DayOfWeek", "Promo"]])
        level3 = pd.Series(self.store_dow_promo_.reindex(k3).to_numpy(), index=X.index).fillna(level2)
        return level3.to_numpy()


def make_model(estimator, log_target=False):
    """StoreHistory -> (impute + scale numbers, one-hot categories) -> estimator."""
    numeric = Pipeline([("imputer", SimpleImputer(strategy="median")), ("scaler", StandardScaler())])
    prep = ColumnTransformer([
        ("num", numeric, NUMERIC),
        ("cat", OneHotEncoder(handle_unknown="ignore", sparse_output=False), CATEGORICAL),
    ])
    pipe = Pipeline([("history", StoreHistory()), ("prep", prep), ("model", estimator)])
    if log_target:
        return TransformedTargetRegressor(regressor=pipe, func=np.log1p, inverse_func=np.expm1)
    return pipe


def rmspe(y_true, y_pred):
    y_true, y_pred = np.asarray(y_true, float), np.asarray(y_pred, float)
    mask = y_true > 0
    return np.sqrt(np.mean(((y_true[mask] - y_pred[mask]) / y_true[mask]) ** 2))


def metrics(y_true, y_pred):
    return {
        "rmse": np.sqrt(mean_squared_error(y_true, y_pred)),
        "mae": mean_absolute_error(y_true, y_pred),
        "r2": r2_score(y_true, y_pred),
        "rmspe": rmspe(y_true, y_pred),
    }
