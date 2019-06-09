# IGDb---Internet-Games-Database
- user: giang
- password: abcdef090
- db name: igdb_db
- schema: igdb

- NAMING convention: snake (e.g: "no_upper_case_pls")

### RESTORE DB
- CREATE DATABASE igdb_db;
- psql -h localhost -U giang igdb_db -f igdb_db.sql

### NOTES
- ALWAYS put `<?php ?>` before <html> (otherwise some functions like "header(), exit()" won't work)
- ALL TABLE or COLUMN names:
				- AVOID uppercase!!
				- if accidentally named with uppercase, must query with `" "` (e.g: igdb."banList")
				- follow ONLY 1 type of naming (e.g: avoid "img-url", "ban list", "UserID" at the same time)

