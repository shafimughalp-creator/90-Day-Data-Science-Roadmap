[notes.md](https://github.com/user-attachments/files/32099315/notes.md)
# SQL Advanced Practice + Python Integration

## Quick Overview
- Today's topic: connecting SQL directly to Python — pulling query results into a pandas DataFrame and running the same cleaning/plotting workflow from Phase 2 on top of them.
- What I learned: `sqlite3` opens the connection, `pd.read_sql_query()` runs the SQL and returns a DataFrame — after that, it's normal pandas/seaborn, nothing SQL-specific left to handle.
- Tools used: Python, sqlite3, pandas, seaborn, matplotlib, FC Lahore Lions players/teams/match_stats schema.

## Introduction
- Up to now, SQL and pandas were treated as two separate skills — write a query in DB Browser, or clean a DataFrame in a notebook.
- In a real data science job, those two things are one pipeline: pull data with SQL, then do everything else (cleaning, analysis, visualization) in pandas.
- Today's session builds that pipeline end-to-end: SQL query → DataFrame → pandas cleaning → seaborn visualization.

## Definitions
- **sqlite3.connect(path):** opens a connection object to a SQLite database file — the bridge Python uses to talk to the database.
- **pd.read_sql_query(sql, conn):** runs a SQL string against an open connection and returns the result as a pandas DataFrame, with column names taken directly from the SELECT.
- **Pipeline:** the full chain from raw data to final output — here: SQL query → DataFrame → cleaning → visualization.
- **conn.close():** closes the database connection once done, the same idea as closing a file after reading it.

## Important Concepts
- **SQL → DataFrame bridge** — `pd.read_sql_query()` is the one function that turns a SQL result set into something pandas can work with immediately, no manual parsing.
- **Cleaning still happens in pandas, not SQL** — SQL got the raw rows; string formatting, filling missing values, and derived columns are still a pandas job.
- **Visualization is unchanged from Phase 2** — once it's a DataFrame, seaborn/matplotlib don't know or care that the data came from SQL instead of a CSV.
- **Aggregation can happen on either side** — `GROUP BY`/`SUM` in SQL is often faster on large tables than pulling everything and aggregating in pandas; window functions (Day 44) can be pulled straight into a DataFrame and plotted directly.

## Step-by-Step Explanation
1. Open a connection: `conn = sqlite3.connect("db_name.db")`.
2. Write the SQL as a normal Python string (often a triple-quoted string for multi-line queries).
3. Run it and capture the result: `df = pd.read_sql_query(query, conn)`.
4. Clean the DataFrame using standard pandas methods (`.str`, `.fillna()`, `.astype()`, new derived columns).
5. Plot with seaborn/matplotlib exactly as in Phase 2.
6. Close the connection with `conn.close()` once every query for the session is done.

## Examples
- **Basic pull:** `pd.read_sql_query("SELECT * FROM players", conn)` — the whole players table as a DataFrame.
- **Aggregated pull:** a `GROUP BY team_id` query pulled directly, then bar-plotted with seaborn — no pandas `.groupby()` needed since SQL already did it.
- **Window function pull:** Day 44's running-total query pulled into a DataFrame and line-plotted by team, date on the x-axis.
- **Full business-question pipeline:** "which team scored the most goals?" answered by one SQL query, one `sns.barplot()` call.

## Common Mistakes
- Forgetting to close the connection (`conn.close()`) when done, which can leave the database file locked.
- Re-running `pd.read_sql_query()` with a broken query and not checking whether the DataFrame that came back is actually empty.
- Doing the same aggregation twice — once in SQL's `GROUP BY`, then again with pandas' `.groupby()` on top, which just wastes a step.
- Treating a column pulled from SQL as already the right dtype — SQLite is loosely typed, so numeric columns sometimes need `.astype()` after pulling.
- Writing a huge, unreadable SQL string inline instead of formatting it clearly as a triple-quoted string.

## Interview Questions
1. What does `pd.read_sql_query()` do, and what does it need to run?
2. Where should aggregation happen — SQL or pandas — and does it matter?
3. Why would you pull a window-function query into pandas instead of just aggregating in pandas directly?
4. What's the risk of not closing a database connection?
5. Walk through the full pipeline for answering a business question using SQL + pandas + a chart.

## Key Takeaways
- `sqlite3.connect()` + `pd.read_sql_query()` is the standard bridge between SQL and a pandas pipeline.
- SQL is often the better place to filter/aggregate large tables; pandas is still where cleaning and reshaping happens.
- Everything learned in Phase 2 (cleaning, seaborn, matplotlib) works unchanged once data is in a DataFrame — the source doesn't matter anymore.
- This pipeline (SQL → DataFrame → clean → plot) is exactly how SQL skills get used day-to-day in an actual data science role.

## Summary
Today's session connected SQL to Python for the first time — using `sqlite3` and `pd.read_sql_query()` to pull FC Lahore Lions data straight into a DataFrame, then running the same pandas cleaning and seaborn visualization workflow from Phase 2 on top of it. Practiced the full pipeline against three business questions (top-scoring team, average goals by position, running goal totals by team), including pulling a Day 44 window function directly into a line chart.
