import numpy as np
import pandas as pd


def add_date_features(df):
    """Calendar features from the Date column."""
    out = df.copy()
    d = out["Date"]
    out["year"] = d.dt.year
    out["month"] = d.dt.month
    out["day"] = d.dt.day
    out["day_of_week"] = d.dt.dayofweek            # 0 = Monday ... 6 = Sunday
    out["week_of_year"] = d.dt.isocalendar().week.astype(int)
    out["is_weekend"] = (d.dt.dayofweek >= 5).astype(int)
    out["is_month_end"] = d.dt.is_month_end.astype(int)
    return out


def add_lag_features(df, lags=(1, 7, 42, 49), target="Sales"):
    """Sales k days ago for the same store, matched by DATE (not by row position).

    Some stores have missing dates, so shifting rows would pick the wrong day.
    """
    out = df.copy()
    s = out.set_index(["Store", "Date"])[target]
    for k in lags:
        keys = pd.MultiIndex.from_arrays([out["Store"], out["Date"] - pd.Timedelta(days=k)])
        out["lag_" + str(k)] = s.reindex(keys).to_numpy()
    return out


def merge_store_info(df, store):
    """Add store details and give the categorical columns clean names."""
    cols = ["Store", "StoreType", "Assortment", "CompetitionDistance", "Promo2"]
    info = store[cols].copy()
    info["CompetitionDistance"] = info["CompetitionDistance"].fillna(info["CompetitionDistance"].median())
    out = df.merge(info, on="Store", how="left")
    return out.rename(columns={"StoreType": "store_type", "Assortment": "assortment",
                               "StateHoliday": "state_holiday"})


def add_store_history(df, history, target="Sales"):
    """Average sales per store (and per store + weekday), learned from `history` only.

    `history` must be rows from BEFORE the forecast starts, so these numbers are known at forecast time.
    """
    out = df.copy()
    overall = history[target].mean()
    store_mean = history.groupby("Store")[target].mean().rename("store_mean")
    dow_mean = history.groupby(["Store", "day_of_week"])[target].mean().rename("store_dow_mean")
    out = out.join(store_mean, on="Store").join(dow_mean, on=["Store", "day_of_week"])
    out["store_mean"] = out["store_mean"].fillna(overall)
    out["store_dow_mean"] = out["store_dow_mean"].fillna(out["store_mean"])
    return out
