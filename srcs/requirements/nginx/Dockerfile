FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl \
	&& mkdir -p /etc/nginx/ssl \
	&& openssl req -x509 -noenc -days 10 \
		-newkey rsa:2048 \
		-keyout /etc/nginx/ssl/wordpress.key \
		-out /etc/nginx/ssl/wordpress.crt \
		-subj "/C=MA/ST=Khouribga/L=Khouribga/O=1337/CN=wordpress"

COPY conf/nginx.conf /etc/nginx/conf.d/my.conf

CMD ["nginx", "-g", "daemon off;"]