#!/bin/sh
set -eu

WORDPRESS_DIR=/var/www/html
DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
. /run/secrets/credentials

wait_for_database() {
    attempts=0
    until mysql -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" -u "${MYSQL_USER}" -p"${DB_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; do
        attempts=$((attempts + 1))
        if [ "$attempts" -ge 30 ]; then
            echo "database is not ready"
            exit 1
        fi
        sleep 1
    done
}

wait_for_database

if [ ! -f "${WORDPRESS_DIR}/wp-config.php" ]; then
    wp core download --allow-root --path="${WORDPRESS_DIR}"
    wp config create --allow-root \
        --path="${WORDPRESS_DIR}" \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${MYSQL_HOST}:${MYSQL_PORT}" \
        --skip-check
fi

if ! wp core is-installed --allow-root --path="${WORDPRESS_DIR}" >/dev/null 2>&1; then
    wp core install --allow-root \
        --path="${WORDPRESS_DIR}" \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email
fi

if ! wp user get "${WP_USER}" --allow-root --path="${WORDPRESS_DIR}" >/dev/null 2>&1; then
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" --allow-root \
        --path="${WORDPRESS_DIR}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=subscriber
fi

chown -R www-data:www-data "${WORDPRESS_DIR}"

exec php-fpm8.2 -F