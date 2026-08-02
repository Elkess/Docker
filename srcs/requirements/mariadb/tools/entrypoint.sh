#!/bin/sh
set -eu

DATADIR=/var/lib/mysql
SOCKET=/run/mysqld/mysqld.sock
PIDFILE=/run/mysqld/mysqld.pid
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

install -d -o mysql -g mysql /run/mysqld
chown -R mysql:mysql "${DATADIR}"

if [ ! -d "${DATADIR}/mysql" ]; then
    mariadb-install-db --user=mysql --datadir="${DATADIR}" >/dev/null
fi

mariadbd --user=mysql --datadir="${DATADIR}" --skip-networking --socket="${SOCKET}" --pid-file="${PIDFILE}" &
temp_pid=$!

ready=0
for _ in $(seq 1 30); do
    if mariadb-admin --protocol=SOCKET --socket="${SOCKET}" ping >/dev/null 2>&1; then
        ready=1
        break
    fi
    sleep 1
done

if [ "${ready}" -ne 1 ]; then
    echo "MariaDB bootstrap failed"
    kill "${temp_pid}" >/dev/null 2>&1 || true
    exit 1
fi

env -u MYSQL_HOST mariadb --protocol=SOCKET --socket="${SOCKET}" -uroot <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

kill "${temp_pid}"
wait "${temp_pid}" || true

exec mariadbd --user=mysql --bind-address=0.0.0.0 --socket="${SOCKET}" --datadir="${DATADIR}"