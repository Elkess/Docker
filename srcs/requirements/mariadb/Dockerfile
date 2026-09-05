FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends mariadb-server \
	&& sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' \
		/etc/mysql/mariadb.conf.d/50-server.cnf \
	&& mkdir -p /run/mysqld && chown mysql: /run/mysqld \
	&& mkdir -p /var/lib/mysql && chown -R mysql: /var/lib/mysql

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
