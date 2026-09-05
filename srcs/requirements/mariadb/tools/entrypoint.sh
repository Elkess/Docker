#!/bin/sh
set -eu

mariadbd --user=mysql &

until mariadb -e "SELECT 1" 2>/dev/null; do sleep 1; done

PASS=$(cat /run/secrets/db_password)

mariadb <<EOF
    CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
    CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$PASS';
    ALTER USER '$MYSQL_USER'@'%' IDENTIFIED BY '$PASS';
    GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
EOF

mariadb-admin -p shutdown

exec mariadbd --user=mysql