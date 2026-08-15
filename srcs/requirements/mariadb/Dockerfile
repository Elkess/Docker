FROM debian:12

# install maria server and create the dir that it's asking for
RUN apt-get update && apt-get install -y mariadb-server \
	&& mkdir -p /run/mysqld && chown mysql: /run/mysqld

	
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
	
RUN chmod +x /usr/local/bin/entrypoint.sh

USER mysql

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
