-- ============================================================
-- Day 47 — SQL Full Challenge Day + Kaggle Certification
-- Phase 3 wrap-up: best queries from Days 36-46, plus one new
-- capstone query, written from memory as the SQL stress test
-- before moving into Machine Learning (Phase 4).
-- Dataset: FC Lahore Lions (Days 36-46 review) +
--          customers/orders schema (capstone query, matches
--          Day 39's deviation dataset)
-- Tool: DB Browser for SQLite
-- ============================================================

-- Reference schemas used below:
-- teams(team_id, team_name, city)
-- players(player_id, player_name, team_id, position, goals, assists, appearances)
-- match_stats(stat_id, match_id, player_id, match_date, goals_in_match, assists_in_match)
-- customers(customer_id, customer_name)
-- orders(order_id, customer_id, order_date, amount)


-- ------------------------------------------------------------
-- REVIEW 1: Multi-table JOIN (Days 39-40)
-- Pull player, team, and match performance together in one query.
-- ------------------------------------------------------------
SELECT p.player_name, t.team_name, ms.match_date, ms.goals_in_match
FROM players AS p
JOIN teams AS t ON p.team_id = t.team_id
JOIN match_stats AS ms ON p.player_id = ms.player_id
ORDER BY ms.match_date;


-- ------------------------------------------------------------
-- REVIEW 2: GROUP BY + HAVING (Day 38)
-- Aggregate first, then filter the AGGREGATED result (not the raw rows).
-- ------------------------------------------------------------
SELECT team_id, COUNT(*) AS squad_size, AVG(goals) AS avg_goals
FROM players
GROUP BY team_id
HAVING AVG(goals) > 5;


-- ------------------------------------------------------------
-- REVIEW 3: Correlated subquery (Day 43)
-- Players who outscored their own team's average.
-- ------------------------------------------------------------
SELECT p1.player_name, p1.team_id, p1.goals
FROM players AS p1
WHERE p1.goals > (
    SELECT AVG(p2.goals) FROM players AS p2 WHERE p2.team_id = p1.team_id
);


-- ------------------------------------------------------------
-- REVIEW 4: Window function — RANK + running total (Day 44)
-- ------------------------------------------------------------
SELECT
    player_name, team_id, goals,
    RANK() OVER (PARTITION BY team_id ORDER BY goals DESC) AS team_rank
FROM players;


-- ------------------------------------------------------------
-- REVIEW 5: CTE (Day 45)
-- Same result as Review 3, rewritten as a readable named step.
-- ------------------------------------------------------------
WITH team_avg AS (
    SELECT team_id, AVG(goals) AS avg_team_goals
    FROM players
    GROUP BY team_id
)
SELECT p.player_name, p.goals, ta.avg_team_goals
FROM players AS p
JOIN team_avg AS ta ON p.team_id = ta.team_id
WHERE p.goals > ta.avg_team_goals;


-- ------------------------------------------------------------
-- CAPSTONE QUERY (new, Day 47 task):
-- "For each customer, find their most recent order date,
--  total spend, and rank them by total spend."
--
-- Combines everything above in one query: a CTE that aggregates
-- (MAX + SUM, like Review 2), then a window function to rank
-- the aggregated result (like Review 4) — the exact kind of
-- query a mid-level SQL interview asks for.
-- ------------------------------------------------------------
WITH customer_summary AS (
    SELECT
        c.customer_id,
        c.customer_name,
        MAX(o.order_date) AS most_recent_order,
        SUM(o.amount) AS total_spend
    FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_name,
    most_recent_order,
    total_spend,
    RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM customer_summary
ORDER BY spend_rank;


-- ------------------------------------------------------------
-- SELF-CHECK: could I write Reviews 1-5 from memory, no notes?
-- Yes — Days 36-46 covered JOINs, aggregation, subqueries, window
-- functions, and CTEs solidly enough to rebuild each pattern above
-- without looking anything up. That was the actual goal of today.
-- ------------------------------------------------------------
