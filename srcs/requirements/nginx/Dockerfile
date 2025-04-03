# syntax=docker/dockerfile:1
FROM debian:bullseye

RUN	apt-get update && apt install -y \
	nginx \
	openssl

RUN mkdir -p /var/www/html


COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/index.html /index.html

COPY ./tools/ng_init.sh .

RUN chmod +x ./ng_init.sh


ENTRYPOINT ["./ng_init.sh"]
