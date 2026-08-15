#!/bin/bash

set -e

mariadbd --skip-networking &
MARIADB_PID=$!

if ! kill -0 "$MARIADB_PID"; then
	echo "MariaDB Failed :("
	exit 1
fi

until mariadb -e "select 1337"; do
	if ! kill -0 "$MARIADB_PID"; then
	echo "MariaDB Failed :("
	exit 1
	fi
	sleep 1
done

mariadb <<'EOF'
CREATE DATABASE IF NOT EXISTS `wp-database`;
CREATE USER IF NOT EXISTS `wp-user`@`%` IDENTIFIED BY `wp-pass`;
GRANT ALL ON `wp-database`.* TO `wp-user`@`%`;
EOF

kill "$MARIADB_PID"

exec mariadbd