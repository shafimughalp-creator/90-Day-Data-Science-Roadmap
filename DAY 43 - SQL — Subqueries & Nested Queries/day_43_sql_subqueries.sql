-- ============================================================
-- Day 43 — SQL: Subqueries & Nested Queries
-- Dataset: FC Lahore Lions (players, teams, match_stats)
-- Tool: DB Browser for SQLite
-- ============================================================

-- Reference schema used below (already built in earlier SQL days):
-- teams(team_id, team_name, city)
-- players(player_id, player_name, team_id, position, goals, appearances)
-- match_stats(stat_id, match_id, player_id, goals_in_match, assists_in_match)


-- ------------------------------------------------------------
-- CONCEPT 1: Subquery in WHERE clause
-- The inner query runs first and returns a single value (a scalar),
-- which the outer query then compares against.
-- ------------------------------------------------------------
SELECT player_name, team_id, goals
FROM players
WHERE goals > (SELECT AVG(goals) FROM players);
-- Reads as: "give me players whose goals are above the league-wide average"


-- ------------------------------------------------------------
-- CONCEPT 2: Subquery in FROM clause (derived table)
-- Wrap a query in parentheses and give it an alias — SQL treats
-- the result like a temporary table you can select from or join.
-- ------------------------------------------------------------
SELECT team_id, avg_team_goals
FROM (
    SELECT team_id, AVG(goals) AS avg_team_goals
    FROM players
    GROUP BY team_id
) AS team_averages
WHERE avg_team_goals > 5;
-- The inner query builds a mini "team averages" table first,
-- the outer query then filters that table.


-- ------------------------------------------------------------
-- CONCEPT 3: Correlated subquery
-- Unlike Concepts 1 & 2, this subquery re-runs once PER ROW of the
-- outer query, because it references a column from the outer query (p1.team_id).
-- ------------------------------------------------------------
SELECT p1.player_name, p1.team_id, p1.goals
FROM players AS p1
WHERE p1.goals > (
    SELECT AVG(p2.goals)
    FROM players AS p2
    WHERE p2.team_id = p1.team_id   -- <-- the correlation
);
-- Reads as: "give me players who outscored their OWN team's average"
-- (slower than Concepts 1/2 on large tables, but answers a row-specific question)


-- ------------------------------------------------------------
-- PRACTICE 1: "Find employees who earn above their department average"
-- Football translation: find players who scored above their own
-- team's average goals. Same correlated-subquery pattern as Concept 3,
-- applied as a standalone practice rep.
-- ------------------------------------------------------------
SELECT p.player_name, t.team_name, p.position, p.goals
FROM players AS p
JOIN teams AS t ON p.team_id = t.team_id
WHERE p.goals > (
    SELECT AVG(p2.goals)
    FROM players AS p2
    WHERE p2.team_id = p.team_id
)
ORDER BY t.team_name, p.goals DESC;


-- ------------------------------------------------------------
-- PRACTICE 2: "Find products ordered by more than 100 customers"
-- Football translation: find players who scored in more than 3
-- different matches (a count-based HAVING filter, applied through
-- a FROM-clause subquery/derived table — Concept 2's pattern).
-- ------------------------------------------------------------
SELECT player_name, matches_scored_in
FROM (
    SELECT p.player_name, COUNT(DISTINCT ms.match_id) AS matches_scored_in
    FROM players AS p
    JOIN match_stats AS ms ON p.player_id = ms.player_id
    WHERE ms.goals_in_match > 0
    GROUP BY p.player_id
) AS scoring_matches
WHERE matches_scored_in > 3
ORDER BY matches_scored_in DESC;


-- ------------------------------------------------------------
-- BONUS CONCEPT: EXISTS with a correlated subquery
-- EXISTS only checks whether the subquery returns ANY row — it
-- doesn't care about the value, just true/false. Often faster than
-- IN for large tables, and a very common interview pattern.
-- ------------------------------------------------------------
SELECT t.team_name
FROM teams AS t
WHERE EXISTS (
    SELECT 1
    FROM players AS p
    WHERE p.team_id = t.team_id
      AND p.goals > 10
);
-- Reads as: "give me every team that has AT LEAST ONE player with 10+ goals"
