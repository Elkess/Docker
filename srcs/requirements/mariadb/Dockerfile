FROM debian:bookworm

# install maria server and create the dir that it's asking for
RUN apt-get update && apt-get install -y mariadb-server \
	&& sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf \
	&& mkdir -p /run/mysqld && chown mysql: /run/mysqld

	
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
	
RUN chmod +x /usr/local/bin/entrypoint.sh

USER mysql

ENTRYPOINT [ "entrypoint.sh" ]
