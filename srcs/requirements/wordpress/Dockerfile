# syntax=docker/dockerfile:1
FROM debian:bullseye

RUN	apt-get update && apt install -y \
	php7.4-fpm \
	mariadb-client \
	php7.4-mysqli \
	php7.4-pdo \
	php7.4-mbstring \
	php7.4-xml \
	php7.4-curl \
	php7.4-json \
	php7.4-zip \
	php7.4-gd \
	php7.4-intl \
	php7.4-bcmath \
	php7.4-exif \
	php7.4-soap \
	php7.4-xmlrpc \
	php7.4-imagick \
	curl

RUN mkdir -p  /var/www/html /run/php

# COPY ./conf/index.html /index.html
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/.
COPY ./tools/wp_init.sh .

RUN chmod +x wp_init.sh


ENTRYPOINT ["./wp_init.sh"]
