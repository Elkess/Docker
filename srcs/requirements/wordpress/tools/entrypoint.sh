#!/bin/bash

WP_PATH="/srv/www/wordpress"
cd "$WP_PATH"

DB_PASS="$(cat /run/secrets/db_password)"
ADMIN_PASS="$(cat /run/secrets/wp_admin_password)"
USER_PASS="$(cat /run/secrets/wp_user_password)"

until mariadb-admin ping -h"mariadb" -u"$MYSQL_USER" -p"$DB_PASS" --silent 2>/dev/null; do
    sleep 1
done

if [ ! -f wp-config.php ]; then
    wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" \
    --dbpass="$DB_PASS" --dbhost="mariadb" --skip-check --allow-root
fi

if ! wp core is-installed --allow-root >/dev/null 2>&1; then

    wp core install --url="https://$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER" \
    --admin_password="$ADMIN_PASS" --admin_email="$WP_ADMIN_EMAIL" --allow-root

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$USER_PASS" \
        --allow-root
fi

chown -R www-data: "$WP_PATH"

exec php-fpm8.2 -F