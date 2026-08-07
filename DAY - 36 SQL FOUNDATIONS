# SQL Foundations — Databases, Tables & Keys

## Quick Overview
- **Topic:** Relational databases — tables, data types, Primary Keys, Foreign Keys, and inserting data with SQLite.
- **What I learned:** How to design and build a real, linked relational database by hand instead of using one flat spreadsheet-style table.
- **Tools used:** SQLite (via DB Browser for SQLite), plain SQL.

## Introduction
Day 36 kicks off Phase 3 (SQL) of my Data Science roadmap, right after finishing Phase 2 (Pandas, Matplotlib, Seaborn, Git/GitHub, Jupyter). Every query I'll write for the rest of this phase depends on understanding how a relational database is structured — so today is 100% foundations, no shortcuts.

## Definitions
- **Relational database:** a collection of tables, where rows = records and columns = fields, and tables can be *linked* to each other.
- **Primary Key (PK):** the column that uniquely identifies every row in a table. No two rows can share one.
- **Foreign Key (FK):** a column in one table that points to another table's Primary Key — this link is what makes the database "relational."
- **Data types (SQLite):** `INTEGER` (whole numbers), `TEXT` (strings), `REAL` (decimals), `NULL` (missing/unknown value).

## Important Concepts
- `CREATE TABLE` — defines a new table's structure (columns, types, constraints).
- `PRIMARY KEY` — enforces uniqueness on the identifying column.
- `NOT NULL` — blocks a column from ever being left empty.
- `FOREIGN KEY (col) REFERENCES other_table(other_col)` — links one table to another and blocks invalid references.
- `DROP TABLE IF EXISTS` — safely deletes a table (useful for re-running a schema script while designing it).
- `INSERT INTO table (cols) VALUES (...)` — adds one or more rows; multiple rows can be inserted in a single statement.
- `PRAGMA foreign_keys = ON;` — turns on Foreign Key enforcement in SQLite (off by default).
- **Logical execution order** of SQL (how the database actually runs a query, vs. how it's written):
  `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT`

## Step-by-Step Explanation
1. Design tables around real entities — `teams`, `players`, `stadiums`, `matches` — instead of one giant flat table.
2. Give every table a Primary Key so each row can be uniquely identified.
3. Link related tables using Foreign Keys (e.g. `players.team_id → teams.team_id`).
4. Turn on `PRAGMA foreign_keys = ON;` so SQLite actually enforces those links.
5. Insert **parent data first** (`teams`, `stadiums`) before **child data** (`players`, `matches`) — a Foreign Key can't point to a row that doesn't exist yet.
6. Verify everything with `SELECT * FROM table_name;` on each table.

## Examples
```sql
CREATE TABLE teams (
    team_id INTEGER PRIMARY KEY,
    team_name TEXT NOT NULL,
    city TEXT,
    founded_year INTEGER
);

CREATE TABLE players (
    player_id INTEGER PRIMARY KEY,
    player_name TEXT NOT NULL,
    age INTEGER,
    position TEXT,
    team_id INTEGER,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

INSERT INTO teams (team_id, team_name, city)
VALUES 
    (1, 'FC Lahore Lions', 'Lahore'),
    (2, 'Karachi Kings FC', 'Karachi');

INSERT INTO players (player_id, player_name, age, position, team_id)
VALUES 
    (101, 'Ali Raza', 24, 'Forward', 1),
    (102, 'Shafi', 19, 'Winger', 1);
```

## Common Mistakes
- **Trailing comma** before the closing `)` in `CREATE TABLE` — SQL doesn't allow a comma with nothing after it.
- **Column count ≠ value count** in `INSERT INTO` — every listed column needs exactly one matching value.
- **Semicolon in the middle of a multi-row insert** — a `;` ends the whole statement; extra rows need commas between `(...)` groups, not new `INSERT` statements, unless you deliberately want separate statements.
- **Foreign Key pointing to a non-Primary-Key column** — SQLite won't stop you, but it defeats the purpose of enforcing uniqueness on the link.
- **Inserting child rows before parent rows exist** — causes a `FOREIGN KEY constraint failed` error (with enforcement on) or silent broken links (with it off).
- **Stray spaces inside quoted strings** (e.g. `' Islamabad'` vs `'Islamabad'`) — inserts fine, but breaks exact-match filtering later.

## Interview Questions
1. What's the difference between a Primary Key and a Foreign Key, and why does a table sometimes need both?
2. What happens if you insert a row referencing a non-existent Foreign Key value when `PRAGMA foreign_keys = ON;` is **not** set? Why is that risky in production?
3. Why must "parent" table data (e.g. `teams`) be inserted before "child" table data (e.g. `players`, `matches`) that references it?

## Key Takeaways
- A relational database splits data into linked tables instead of one repetitive flat table.
- Primary Keys guarantee uniqueness; Foreign Keys guarantee valid relationships between tables.
- SQLite doesn't enforce Foreign Keys unless you explicitly turn it on.
- Insert order matters: parents before children.
- `DROP TABLE IF EXISTS` + rebuild is a safe, professional habit while a schema is still being designed.

## Summary
Today I moved from "flat spreadsheet thinking" to real relational database design — building 4 linked tables (`teams`, `players`, `stadiums`, `matches`) for an FC Lahore Lions dataset, enforcing real Primary Key and Foreign Key constraints, and debugging genuine SQL errors (trailing commas, mismatched INSERT values, constraint violations) along the way. This is the foundation every other SQL topic this phase will build on.
