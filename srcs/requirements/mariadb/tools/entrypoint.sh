#!/bin/bash

# Start MariaDB temporarily in the background
mariadbd --skip-networking &
MARIADB_PID=$!

if ! kill -0 "$MARIADB_PID" 2>/dev/null; then
    echo "MariaDB failed to start"
    exit 1
fi

# Wait until MariaDB is ready
until mariadb -e "SELECT 1" > /dev/null 2>&1; do
    sleep 1
done

# Create the WordPress database
mariadb <<EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wp-user'@'%' IDENTIFIED BY 'wp-password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp-user'@'%';
EOF

# Stop the temporary MariaDB server
mariadb-admin shutdown

# Start the real MariaDB server
exec mariadbd
