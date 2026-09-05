FROM debian:bookworm

RUN apt-get update && apt-get install -y php-fpm php-cli php-mysql mariadb-client curl \
    && curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp \
    && mkdir -p /srv/www/wordpress /run/php \
    && wp core download --path=/srv/www/wordpress --allow-root \
    && sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf \
    && rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "entrypoint.sh" ]
