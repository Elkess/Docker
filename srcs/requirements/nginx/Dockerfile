FROM debian:12

RUN apt-get update && apt-get install -y nginx openssl \
	&& mkdir -p /etc/nginx/ssl \
	&& openssl req -x509 -noenc -days 10 \
		-newkey rsa:2048 \
		-keyout /etc/nginx/ssl/wordpress.key \
		-out /etc/nginx/ssl/wordpress.crt \
		-subj "/CN=melkess.42.fr"

COPY conf/nginx.conf /etc/nginx/conf.d/my.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]