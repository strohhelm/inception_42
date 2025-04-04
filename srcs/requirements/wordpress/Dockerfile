# syntax=docker/dockerfile:1
FROM debian:bullseye

RUN	apt-get update && apt install -y \
	php7.4-fpm \
	php7.4-mysqli \
	php7.4-curl \
	php7.4-gd \
	php7.4-intl \
	php7.4-mbstring \
	php7.4-imagick \
	php7.4-dom \
	php7.4-zip \
	curl \
	netcat 

RUN mkdir -p  /var/www/html /run/php

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/.
COPY ./tools/wp_init.sh .

RUN chmod +x wp_init.sh


ENTRYPOINT ["./wp_init.sh"]
