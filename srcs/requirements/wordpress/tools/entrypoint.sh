#!/bin/bash
set -eu

WP_PATH="/srv/www/wordpress"

cd "$WP_PATH"
if ! wp core is-installed --allow-root >/dev/null 2>&1; then
    DB_PASS="$(cat /run/secrets/db_password)"
    ADMIN_PASS="$(cat /run/secrets/wp_admin_password)"
    USER_PASS="$(cat /run/secrets/wp_user_password)"

    if [ ! -f "$WP_PATH/wp-config.php" ]; then
        wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" \
            --dbpass="$DB_PASS" --dbhost="mariadb" --skip-check --allow-root
    fi

    while ! wp db check --allow-root; do
        sleep 2
    done

    wp core install --url="https://$DOMAIN_NAME" --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" --admin_password="$ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" --allow-root

    wp user create "$WP_USER" "$WP_USER_EMAIL" --role=author --user_pass="$USER_PASS" \
        --allow-root
fi

chown -R www-data:www-data "$WP_PATH"
exec php-fpm8.2 -F