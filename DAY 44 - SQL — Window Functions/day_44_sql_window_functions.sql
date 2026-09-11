-- ============================================================
-- Day 44 — SQL: Window Functions
-- Dataset: FC Lahore Lions (players, teams, match_stats)
-- Tool: DB Browser for SQLite
-- ============================================================

-- Reference schema used below (already built in earlier SQL days):
-- teams(team_id, team_name, city)
-- players(player_id, player_name, team_id, position, goals, assists, appearances)
-- match_stats(stat_id, match_id, player_id, match_date, goals_in_match, assists_in_match)


-- ------------------------------------------------------------
-- CONCEPT 1: ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)
-- Gives every row a unique, sequential number WITHIN each group
-- (the "window"), restarting at 1 for every new team.
-- ------------------------------------------------------------
SELECT
    player_name,
    team_id,
    goals,
    ROW_NUMBER() OVER (PARTITION BY team_id ORDER BY goals DESC) AS goal_rank
FROM players;
-- Reads as: "number each player 1, 2, 3... within their own team, top scorer first"
-- Ties get different numbers anyway — ROW_NUMBER never repeats a value.


-- ------------------------------------------------------------
-- CONCEPT 2: RANK() vs DENSE_RANK() — the tie behavior
-- Both assign the SAME rank to tied rows. The difference is what
-- happens to the NEXT rank after a tie.
-- ------------------------------------------------------------
SELECT
    player_name,
    team_id,
    goals,
    RANK()       OVER (PARTITION BY team_id ORDER BY goals DESC) AS rank_with_gaps,
    DENSE_RANK() OVER (PARTITION BY team_id ORDER BY goals DESC) AS rank_no_gaps
FROM players;
-- RANK(): two players tied at rank 2 -> next player is rank 4 (rank 3 is skipped)
-- DENSE_RANK(): two players tied at rank 2 -> next player is rank 3 (no gap)


-- ------------------------------------------------------------
-- CONCEPT 3: Running total with SUM() OVER (PARTITION BY ... ORDER BY ...)
-- Adds up a value cumulatively, row by row, within each partition,
-- in the order given by ORDER BY.
-- ------------------------------------------------------------
SELECT
    team_id,
    match_date,
    goals_in_match,
    SUM(goals_in_match) OVER (
        PARTITION BY team_id
        ORDER BY match_date
    ) AS running_team_goals
FROM match_stats
ORDER BY team_id, match_date;
-- Reads as: "for each team, show a running tally of goals scored so far,
-- match by match, in date order"


-- ------------------------------------------------------------
-- PRACTICE 1: "Rank salespeople within each region"
-- Football translation: rank players within each team by assists
-- (a fresh metric, same ROW_NUMBER/RANK pattern as Concepts 1 & 2).
-- ------------------------------------------------------------
SELECT
    p.player_name,
    t.team_name,
    p.assists,
    RANK() OVER (PARTITION BY p.team_id ORDER BY p.assists DESC) AS assist_rank
FROM players AS p
JOIN teams AS t ON p.team_id = t.team_id
ORDER BY t.team_name, assist_rank;


-- ------------------------------------------------------------
-- PRACTICE 2: "Compute cumulative sales per store over time"
-- Football translation: cumulative goals per PLAYER over the
-- season (running total, but partitioned by player instead of team).
-- ------------------------------------------------------------
SELECT
    ms.player_id,
    p.player_name,
    ms.match_date,
    ms.goals_in_match,
    SUM(ms.goals_in_match) OVER (
        PARTITION BY ms.player_id
        ORDER BY ms.match_date
    ) AS cumulative_goals
FROM match_stats AS ms
JOIN players AS p ON ms.player_id = p.player_id
ORDER BY p.player_name, ms.match_date;


-- ------------------------------------------------------------
-- BONUS CONCEPT: LAG() — compare a row to the previous row
-- Not in today's core tasks, but the natural next window function
-- once running totals click — pulls a value from the PREVIOUS row
-- in the same partition, useful for match-to-match comparisons.
-- ------------------------------------------------------------
SELECT
    p.player_name,
    ms.match_date,
    ms.goals_in_match,
    LAG(ms.goals_in_match) OVER (
        PARTITION BY ms.player_id
        ORDER BY ms.match_date
    ) AS goals_previous_match
FROM match_stats AS ms
JOIN players AS p ON ms.player_id = p.player_id
ORDER BY p.player_name, ms.match_date;
-- Reads as: "for each match, show how many goals this player scored
-- in their PREVIOUS match" — first match per player is NULL (no "previous")
