# syntax=docker/dockerfile:1
FROM debian:bullseye

RUN	apt-get update && apt install -y nginx

RUN mkdir -p /var/www/html




COPY ./conf/default /etc/nginx/sites-available/.
COPY ./tools/init.sh .

RUN chmod +x ./init.sh


ENTRYPOINT ["./init.sh"]
