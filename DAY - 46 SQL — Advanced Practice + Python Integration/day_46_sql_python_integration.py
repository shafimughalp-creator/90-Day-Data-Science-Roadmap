# ============================================================
# Day 46 — SQL Advanced Practice + Python Integration
# Dataset: FC Lahore Lions (players, teams, match_stats)
# Tools: sqlite3, pandas, seaborn, matplotlib
# ============================================================

import sqlite3
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# ------------------------------------------------------------
# CONCEPT 1: Connect to SQLite and pull a query straight into a DataFrame
# sqlite3 opens the connection; pd.read_sql_query runs the SQL and
# hands the result back as a normal pandas DataFrame — no manual
# row-by-row parsing needed.
# ------------------------------------------------------------
conn = sqlite3.connect("fc_lahore_lions.db")

query = """
    SELECT player_name, team_id, position, goals, assists
    FROM players
"""
players_df = pd.read_sql_query(query, conn)
print(players_df.head())


# ------------------------------------------------------------
# CONCEPT 2: Pandas cleaning on the DataFrame that came back from SQL
# SQL gave me the raw rows — cleaning still happens in pandas,
# same as any other DataFrame (SQL isn't a substitute for this step).
# ------------------------------------------------------------
players_df["position"] = players_df["position"].str.strip().str.title()
players_df["goals"] = players_df["goals"].fillna(0).astype(int)
players_df["goal_contributions"] = players_df["goals"] + players_df["assists"]

print(players_df.dtypes)


# ------------------------------------------------------------
# CONCEPT 3: Visualize the cleaned DataFrame with Seaborn
# Once it's a normal DataFrame, every pandas/seaborn tool from
# Phase 2 works on it exactly the same way.
# ------------------------------------------------------------
plt.figure(figsize=(8, 5))
sns.barplot(data=players_df, x="team_id", y="goals", estimator="sum", errorbar=None)
plt.title("Total Goals by Team")
plt.xlabel("Team ID")
plt.ylabel("Total Goals")
plt.tight_layout()
plt.savefig("team_goals_barplot.png")
plt.show()


# ------------------------------------------------------------
# BUSINESS QUESTION 1: "Which team scored the most goals overall?"
# Full mini pipeline: SQL aggregation -> DataFrame -> sort -> plot.
# ------------------------------------------------------------
query_top_team = """
    SELECT t.team_name, SUM(p.goals) AS total_goals
    FROM players p
    JOIN teams t ON p.team_id = t.team_id
    GROUP BY t.team_name
    ORDER BY total_goals DESC
"""
top_team_df = pd.read_sql_query(query_top_team, conn)

sns.barplot(data=top_team_df, x="team_name", y="total_goals")
plt.title("Which Team Scored the Most Goals?")
plt.xticks(rotation=20)
plt.tight_layout()
plt.savefig("top_team_goals.png")
plt.show()


# ------------------------------------------------------------
# BUSINESS QUESTION 2: "What's the average goal output per position?"
# ------------------------------------------------------------
query_position_avg = """
    SELECT position, AVG(goals) AS avg_goals
    FROM players
    GROUP BY position
"""
position_avg_df = pd.read_sql_query(query_position_avg, conn)

sns.barplot(data=position_avg_df, x="position", y="avg_goals")
plt.title("Average Goals by Position")
plt.tight_layout()
plt.savefig("avg_goals_by_position.png")
plt.show()


# ------------------------------------------------------------
# BUSINESS QUESTION 3: "Show each team's running goal total over the season"
# Pulls Day 44's window function straight into pandas, then line-plots it —
# the SQL does the heavy lifting, pandas/seaborn just render the result.
# ------------------------------------------------------------
query_running_total = """
    SELECT team_id, match_date,
           SUM(goals_in_match) OVER (
               PARTITION BY team_id ORDER BY match_date
           ) AS running_team_goals
    FROM match_stats
    ORDER BY team_id, match_date
"""
running_df = pd.read_sql_query(query_running_total, conn)
running_df["match_date"] = pd.to_datetime(running_df["match_date"])

sns.lineplot(data=running_df, x="match_date", y="running_team_goals", hue="team_id")
plt.title("Running Goal Total per Team Over the Season")
plt.xticks(rotation=30)
plt.tight_layout()
plt.savefig("running_goals_lineplot.png")
plt.show()

conn.close()
