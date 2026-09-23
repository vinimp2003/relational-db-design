# Relational Databases — Logical Design & SQL Queries

Two separate exercises from the Databases course at the University of Murcia (Oracle SQL,
individually authored). They don't share a schema — each is its own practice assignment.

## P1 — Logical Design (`p1-logical-design/`)

A relational schema designed from scratch (entity-relationship model → logical design) for
a messaging-app-style database:

- `USUARIO` — application users
- `CONTACTO` — the contact relationship between users
- `EMAIL_CONTACTO` — a user's contact emails (1-to-many)
- `CHAT_GRUPO` — group chats
- `MENSAJE` — messages, linked to their sender and chat

Primary keys, foreign keys, and constraints are defined directly in the `CREATE TABLE`
statements, with the corresponding `DROP` statements in reverse dependency order for a
clean re-run.

## P2 — Queries (`p2-queries/`)

SQL queries written against a schema provided by the course for this exercise (a
series/episode-tracking database: users, series, seasons, episodes, cast, and per-user
"currently watching" / tagging / interest tables). The schema itself isn't included here
since it wasn't authored by me — only the queries are.

Covers filtering, ordering, joins across the show/cast/viewing-history relationships,
aggregation, and date arithmetic (e.g. days since a user's last access).

## Running

Designed for Oracle SQL. `p1-logical-design/logical-design.sql` is self-contained and can
be run on its own. The files under `p2-queries/` assume the course-provided schema for
that exercise, which isn't included.
