-- ============================================================
-- Day 45 — SQL: CTEs (Common Table Expressions)
-- Dataset: FC Lahore Lions (players, teams, match_stats)
-- Tool: DB Browser for SQLite
-- ============================================================

-- Reference schema used below (already built in earlier SQL days):
-- teams(team_id, team_name, city)
-- players(player_id, player_name, team_id, position, goals, assists, appearances)
-- match_stats(stat_id, match_id, player_id, match_date, goals_in_match, assists_in_match)


-- ------------------------------------------------------------
-- CONCEPT 1: Basic CTE pattern
-- WITH names a query up front, then the main SELECT reads from
-- that name like it's a regular table. No nesting parentheses
-- inside the FROM clause like a subquery needs.
-- ------------------------------------------------------------
WITH team_averages AS (
    SELECT team_id, AVG(goals) AS avg_team_goals
    FROM players
    GROUP BY team_id
)
SELECT team_id, avg_team_goals
FROM team_averages
WHERE avg_team_goals > 5;
-- Same result as Day 43's FROM-subquery version — just far easier to read top to bottom.


-- ------------------------------------------------------------
-- CONCEPT 2: Chaining CTEs
-- Each CTE can build on the one before it, so a complex problem
-- becomes a readable sequence of small, named steps.
-- ------------------------------------------------------------
WITH team_totals AS (
    SELECT team_id, SUM(goals) AS total_goals
    FROM players
    GROUP BY team_id
),
ranked_teams AS (
    SELECT team_id, total_goals,
           RANK() OVER (ORDER BY total_goals DESC) AS goal_rank
    FROM team_totals
)
SELECT team_id, total_goals, goal_rank
FROM ranked_teams
WHERE goal_rank <= 3;
-- Step 1: total goals per team. Step 2: rank those totals. Each step is a clean, named stage.


-- ------------------------------------------------------------
-- CONCEPT 3: Reusing a CTE multiple times in one query
-- A subquery has to be re-written every time you need it again.
-- A CTE is defined once and can be referenced as many times as needed.
-- ------------------------------------------------------------
WITH team_averages AS (
    SELECT team_id, AVG(goals) AS avg_team_goals
    FROM players
    GROUP BY team_id
)
SELECT p.player_name, p.goals, ta.avg_team_goals,
       ROUND(p.goals - ta.avg_team_goals, 1) AS goals_above_avg
FROM players AS p
JOIN team_averages AS ta ON p.team_id = ta.team_id
WHERE p.goals > (SELECT AVG(avg_team_goals) FROM team_averages);
-- team_averages is referenced twice here (the JOIN and the final subquery) without redefining it.


-- ------------------------------------------------------------
-- BONUS CONCEPT: Recursive CTE
-- A recursive CTE refers to ITSELF, building up results step by
-- step until a stop condition is met. Classic use: sequences,
-- hierarchies, or generating a series of dates/numbers.
-- ------------------------------------------------------------
WITH RECURSIVE matchday_sequence(matchday) AS (
    SELECT 1                              -- anchor: start at matchday 1
    UNION ALL
    SELECT matchday + 1
    FROM matchday_sequence
    WHERE matchday < 10                   -- stop condition: season has 10 matchdays
)
SELECT matchday FROM matchday_sequence;
-- Generates 1 through 10 without a physical "matchdays" table — useful for building
-- a full season calendar to LEFT JOIN actual results against (so missing matchdays still show).


-- ------------------------------------------------------------
-- PRACTICE 1: Rewrite Day 43's correlated subquery as a CTE
-- Original (Day 43): players above their OWN team's average, using
-- a correlated subquery that re-runs per row.
-- ------------------------------------------------------------
WITH team_avg AS (
    SELECT team_id, AVG(goals) AS avg_team_goals
    FROM players
    GROUP BY team_id
)
SELECT p.player_name, t.team_name, p.goals, ta.avg_team_goals
FROM players AS p
JOIN teams AS t ON p.team_id = t.team_id
JOIN team_avg AS ta ON p.team_id = ta.team_id
WHERE p.goals > ta.avg_team_goals
ORDER BY t.team_name, p.goals DESC;
-- Same answer as the Day 43 correlated subquery, but the average is computed ONCE
-- (in the CTE) instead of once per outer row — more readable AND usually faster.


-- ------------------------------------------------------------
-- PRACTICE 2: Rewrite Day 43's FROM-subquery (players scoring in 3+
-- matches) as a CTE, for a direct readability comparison.
-- ------------------------------------------------------------
WITH scoring_matches AS (
    SELECT p.player_name, COUNT(DISTINCT ms.match_id) AS matches_scored_in
    FROM players AS p
    JOIN match_stats AS ms ON p.player_id = ms.player_id
    WHERE ms.goals_in_match > 0
    GROUP BY p.player_id
)
SELECT player_name, matches_scored_in
FROM scoring_matches
WHERE matches_scored_in > 3
ORDER BY matches_scored_in DESC;
-- Identical logic to Day 43's derived-table version — the only difference is the
-- WITH keyword replacing nested parentheses in FROM. Readability: no contest.
