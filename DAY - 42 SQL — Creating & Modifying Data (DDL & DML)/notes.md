# SQL — Creating & Modifying Data (DDL & DML)

## Quick Overview
- **Topic:** Moving from *reading* data to *building and changing* it — CREATE TABLE, INSERT, UPDATE, DELETE, ALTER TABLE.
- **What I learned:** Every SQL day so far only queried data that already existed. Today I learned to build the database myself and modify it safely.
- **Tools used:** SQLite, DB Browser for SQLite.

## Introduction
Up to Day 41, every SQL session started with a table someone else already built — I just ran `SELECT`. That's half the job. The other half is **DDL (Data Definition Language)**, which builds the structure, and **DML (Data Manipulation Language)**, which fills and changes it.

Think of it like running FC Lahore Lions' front office. Before a single player can be signed, someone has to create the roster sheet — columns for name, position, goals. That's DDL. Signing a player, updating their goal count after a match, releasing them at the end of the season — that's DML.

## Definitions
- **DDL (Data Definition Language):** Commands that define or change the *structure* of a database — `CREATE TABLE`, `ALTER TABLE`, `DROP TABLE`.
- **DML (Data Manipulation Language):** Commands that define or change the *data* inside a structure — `INSERT`, `UPDATE`, `DELETE`.
- **Schema:** The blueprint of a table — its columns, data types, and constraints.
- **Primary Key:** A column (or set of columns) that uniquely identifies each row in a table.

## Important Concepts

### 1. CREATE TABLE — building the roster sheet
```sql
CREATE TABLE teams (
    team_id INTEGER PRIMARY KEY,
    team_name TEXT,
    city TEXT
);
```
- `INTEGER PRIMARY KEY` auto-generates a unique ID for every new row.
- Each column gets a name and a data type (`INTEGER`, `TEXT`, `REAL`).
- This only builds the empty structure — no players in it yet.

### 2. INSERT INTO — signing a player
```sql
INSERT INTO teams (team_name, city) VALUES ('FC Lahore Lions', 'Lahore');
```
- Column names are optional if you provide values for *every* column in order, but naming them is safer and more readable.
- Every `INSERT` adds exactly one new row (unless you stack multiple `VALUES` groups).

### 3. UPDATE — changing a player's record
```sql
UPDATE players
SET goals = 14
WHERE player_id = 3;
```
- ⚠️ **Golden rule:** never run `UPDATE` without a `WHERE` clause. Without it, SQL updates *every single row* in the table.
- `WHERE` is what turns "change everyone" into "change this one player."

### 4. DELETE FROM — releasing a player
```sql
DELETE FROM players
WHERE player_id = 7;
```
- Same golden rule as `UPDATE`: no `WHERE` = every row gone.
- `DELETE` removes rows, not the table itself (that's `DROP TABLE`).

### 5. ALTER TABLE — adding a new column mid-season
```sql
ALTER TABLE players
ADD COLUMN jersey_number INTEGER;
```
- Adds a new column to an existing table without losing any current data.
- New column starts as `NULL` for every existing row until you `UPDATE` it.

## Step-by-Step Explanation
1. **Design** the table on paper first — what columns, what types, what's the primary key.
2. **CREATE TABLE** to lay down that structure in SQLite.
3. **INSERT** starter rows so the table isn't empty.
4. **UPDATE** rows as real-world facts change (a player scores, a price changes).
5. **DELETE** rows that no longer belong.
6. **ALTER TABLE** when the *structure itself* needs to grow — a column nobody planned for at the start.

## Examples
Built a 2-table mini-database for FC Lahore Lions:

**teams**
| team_id | team_name | city |
|---|---|---|
| 1 | FC Lahore Lions | Lahore |
| 2 | Karachi Kings FC | Karachi |

**players**
| player_id | name | team_id | position | goals |
|---|---|---|---|---|
| 1 | Bilal Ahmed | 1 | Forward | 11 |
| 2 | Hamza Khan | 1 | Midfielder | 6 |
| 3 | Ali Raza | 2 | Forward | 8 |

Practice run: created both tables, inserted 3 players, updated Bilal's goal count after a match, deleted a bench player who was released, and altered `players` to add a `jersey_number` column.

## Common Mistakes
- 🔴 Running `UPDATE`/`DELETE` without a `WHERE` clause — wipes or overwrites the entire table.
- 🔴 Forgetting a `PRIMARY KEY` on `CREATE TABLE` — makes rows impossible to uniquely target later.
- 🔴 Mismatching data types (e.g. storing a number as `TEXT`) — breaks math and sorting later on.
- 🔴 Confusing `DELETE FROM table` (removes rows) with `DROP TABLE table` (removes the whole table).
- 🔴 Not testing `UPDATE`/`DELETE` with a `SELECT ... WHERE` first to preview which rows will be hit.

## Interview Questions
1. **What's the difference between DDL and DML?**
   DDL defines/changes structure (`CREATE`, `ALTER`, `DROP`); DML defines/changes the data inside that structure (`INSERT`, `UPDATE`, `DELETE`).
2. **Why is `WHERE` critical in `UPDATE` and `DELETE`?**
   Without it, the command applies to every row in the table — there's no way to target a specific record.
3. **What happens to existing rows when you `ALTER TABLE ... ADD COLUMN`?**
   They get the new column with a `NULL` value until explicitly updated.
4. **What's the difference between `DELETE FROM table` and `DROP TABLE table`?**
   `DELETE FROM` removes rows but keeps the table structure; `DROP TABLE` removes the entire table, structure included.
5. **Why give a table a `PRIMARY KEY`?**
   It guarantees every row can be uniquely and reliably targeted by later `UPDATE`/`DELETE` statements.

## Key Takeaways
- DDL builds structure, DML fills and changes data — today combined both for the first time.
- `CREATE TABLE` needs a clear schema and a `PRIMARY KEY` before anything else happens.
- `UPDATE` and `DELETE` are only as safe as their `WHERE` clause.
- `ALTER TABLE` lets a database grow without starting over.

## Summary
Day 42 moved from reading data to owning it end-to-end: designing a schema, creating tables, inserting starter rows, updating and deleting records safely, and extending a table's structure mid-way. Practiced all of it on a 2-table FC Lahore Lions mini-database (`teams` + `players`) — the first hands-on build of the SQL phase.
