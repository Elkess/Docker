#!/bin/bash

set -eu

DB_PASSWORD="$(tr -d '\r\n' < /run/secrets/db_password)"
MYSQL_DATABASE="${MYSQL_DATABASE:-wp-database}"
MYSQL_USER="${MYSQL_USER:-wp-user}"
ADMIN_USER="${WP_ADMIN_USER:-melkess}"


mariadbd --user=mysql --skip-networking=0 --bind-address=0.0.0.0 --socket=/run/mysqld/mysqld.sock --datadir=/var/lib/mysql &
MARIADB_PID=$!

until mariadb --socket=/run/mysqld/mysqld.sock -uroot -e "SELECT 1" >/dev/null 2>&1; do
    if ! kill -0 "$MARIADB_PID" 2>/dev/null; then
        echo "MariaDB failed to start"
        exit 1
    fi
    sleep 1
done

mariadb --socket=/run/mysqld/mysqld.sock -uroot <<SQL
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
CREATE USER IF NOT EXISTS '${ADMIN_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${ADMIN_USER}'@'%';
SQL

kill "$MARIADB_PID"
wait "$MARIADB_PID" 2>/dev/null || true

echo "MariaDB initialized successfully."
exec mariadbd --user=mysql --bind-address=0.0.0.0 --socket=/run/mysqld/mysqld.sock --datadir=/var/lib/mysql