FROM debian:bookworm

ARG DOMAIN_NAME=melkess.42.fr

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl /var/www/html \
  && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/CN=${DOMAIN_NAME}" \
  && chmod 600 /etc/nginx/ssl/inception.key

COPY conf/default.conf /etc/nginx/conf.d/default.conf

RUN sed -i "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]