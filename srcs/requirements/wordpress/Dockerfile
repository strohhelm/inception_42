# syntax=docker/dockerfile:1
FROM debian:bullseye

RUN	apt-get update && apt install -y \
	php7.4-fpm \
	curl

RUN mkdir -p /run/php /var/www/html

# COPY ./conf/index.html /index.html
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/.
COPY ./tools/init.sh .

RUN chmod +x init.sh


ENTRYPOINT ["./init.sh"]
