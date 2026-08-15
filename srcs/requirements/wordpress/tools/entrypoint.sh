#!/bin/bash

if [ ! -f /srv/www/wordpress/wp-config.php ]; then
	wp config create \
		--path=/srv/www/wordpress \
		--dbname=wp-database \
		--dbuser=wp-user \
		--dbpass=wp-pass \
		--dbhost=mariadb \
		--allow-root
    chown www-data: /srv/www/wordpress/wp-config.php
fi

exec php-fpm8.2 -F
