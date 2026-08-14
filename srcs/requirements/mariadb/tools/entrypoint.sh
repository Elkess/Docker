#!/bin/bash

set -e

# Start MariaDB temporarily in the background
mariadbd --skip-networking &
MARIADB_PID=$!

# Wait until MariaDB is ready
until mariadb -e "SELECT 1" > /dev/null 2>&1; do
    sleep 1
done

# Create the WordPress database
mariadb <<EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wp-user'@'%' IDENTIFIED BY 'wp-password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp-user'@'%';
FLUSH PRIVILEGES;
EOF

# Stop the temporary MariaDB server
mariadb-admin shutdown

# Start the real MariaDB server
exec mariadbd