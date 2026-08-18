FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl \
	&& mkdir -p /etc/nginx/ssl \
	&& openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout /etc/nginx/ssl/wordpress.key \
		-out /etc/nginx/ssl/wordpress.crt \
		-subj "/C=MA/ST=BeniMellal/L=Khouribga/O=42/CN=wordpress"

COPY conf/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT [ "nginx" ]

CMD ["-g", "daemon off;"]
