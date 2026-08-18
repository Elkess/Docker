#!/bin/bash

set -e

# Allow nginx in a different container to reach php-fpm.
sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

# Wait until MariaDB is reachable on the docker network.
until bash -c 'echo > /dev/tcp/mariadb/3306' 2>/dev/null; do
	sleep 1
done

if [ ! -f /srv/www/wordpress/wp-config.php ]; then
	wp config create \
		--path="/srv/www/wordpress" \
		--dbname="wp-database" \
		--dbuser="wp-user" \
		--dbpass="wp-pass" \
		--dbhost="mariadb" \
		--skip-check \
		--allow-root
	chown www-data: /srv/www/wordpress/wp-config.php

	wp core install \
		--path="/srv/www/wordpress" \
		--url="https://melkess.42.fr" \
		--title="Inception" \
		--admin_user="admin" \
		--admin_password="adminpass" \
		--admin_email="admin@example.com" \
		--allow-root
fi

exec php-fpm8.2 -F
