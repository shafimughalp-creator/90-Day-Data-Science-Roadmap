-- ============================================================
-- Day 41 — SQL: CASE WHEN, Date & String Functions
-- Dataset: FC Lahore Lions (teams / players / matches / match_stats)
-- ============================================================

-- ------------------------------------------------------------
-- 1. CASE WHEN — value bucketing
-- Bucket each player into a performance tier based on goals scored.
-- ------------------------------------------------------------
SELECT
    name,
    goals,
    CASE
        WHEN goals >= 15 THEN 'Top Scorer'
        WHEN goals >= 8  THEN 'Regular'
        ELSE 'Bench'
    END AS tier
FROM players
ORDER BY goals DESC;


-- ------------------------------------------------------------
-- 2. Conditional aggregation — SUM(CASE WHEN ...)
-- Pivot-style reporting: wins and losses per team, in one query,
-- without a subquery or a separate query per outcome.
-- ------------------------------------------------------------
SELECT
    team_name,
    SUM(CASE WHEN result = 'W' THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN result = 'L' THEN 1 ELSE 0 END) AS losses
FROM matches
JOIN teams ON teams.team_id = matches.team_id
GROUP BY team_name;


-- ------------------------------------------------------------
-- 3. Date functions — strftime()
-- Group matches by month/year without touching the raw date column.
-- ------------------------------------------------------------
SELECT
    strftime('%Y-%m', match_date) AS month,
    COUNT(*) AS matches_played
FROM matches
GROUP BY month
ORDER BY month;


-- ------------------------------------------------------------
-- 4. String functions — SUBSTR(), UPPER(), LOWER()
-- Build a short player code and normalize position casing.
-- ------------------------------------------------------------
SELECT
    name,
    UPPER(SUBSTR(name, 1, 3)) AS code,
    LOWER(position) AS position_clean
FROM players
LIMIT 5;


-- ------------------------------------------------------------
-- 5. String concatenation — ||
-- Combine two columns into one readable label.
-- ------------------------------------------------------------
SELECT
    name || ' (' || position || ')' AS player_tag
FROM players
ORDER BY name;


-- ------------------------------------------------------------
-- 6. Mini Project — Monthly Performance Report
-- Combine CASE WHEN (conditional aggregation) with a date function
-- (month grouping) in a single query: this is the exact shape of a
-- reporting query used in freelance / analyst dashboard work.
-- ------------------------------------------------------------
SELECT
    strftime('%Y-%m', match_date) AS month,
    SUM(CASE WHEN result = 'W' THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN result = 'L' THEN 1 ELSE 0 END) AS losses,
    SUM(CASE WHEN result = 'D' THEN 1 ELSE 0 END) AS draws
FROM matches
GROUP BY month
ORDER BY month;
