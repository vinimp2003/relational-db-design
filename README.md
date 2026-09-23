# Relational Database Design — Messaging App Schema

A relational schema and query set for a messaging-app-style database (users, contacts,
group chats, messages), from the Databases course at the University of Murcia. Oracle SQL,
individually authored.

## Schema (`schema/logical-design.sql`)

Logical design derived from an entity-relationship model, covering:

- `USUARIO` — application users
- `CONTACTO` — the contact relationship between users
- `EMAIL_CONTACTO` — a user's contact emails (1-to-many)
- `CHAT_GRUPO` — group chats
- `MENSAJE` — messages, linked to their sender and chat

with primary keys, foreign keys, and constraints defined directly in the `CREATE TABLE`
statements (rather than bolted on afterward), and the corresponding `DROP` statements in
reverse dependency order for a clean re-run.

## Queries (`queries/`)

SQL queries against the schema above, covering filtering, ordering, joins across the
contact/message/chat relationships, aggregation, and date arithmetic (e.g. computing days
since a user's last access).

## Running

Designed for Oracle SQL (tested via Oracle's SQL environment used in the course). Run
`schema/logical-design.sql` first to create the tables, then any file under `queries/`.
