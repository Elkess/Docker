FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-client \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh \
  && mkdir -p /var/lib/mysql \
  && chown -R mysql:mysql /var/lib/mysql

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]