FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	php-fpm \
	php-cli \
	php-mysql \
	curl \
	&& curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	-o /usr/local/bin/wp && chmod +x /usr/local/bin/wp \
	&& mkdir -p /srv/www

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN curl https://wordpress.org/latest.tar.gz | tar zx -C /srv/www \
	&& chmod +x /usr/local/bin/entrypoint.sh


ENTRYPOINT [ "entrypoint.sh" ]
