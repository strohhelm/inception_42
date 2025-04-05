# syntax=docker/dockerfile:1
FROM debian:oldstable

RUN apt-get update; apt install -y \
	curl \
	mariadb-server \
	gettext \
	ftp

RUN mkdir -p /run/mysql

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
# COPY ./conf/my.cnf /etc/mysql/mariadb.conf.d/.
COPY ./tools/db_init.sh .
COPY ./tools/database_init.sql .

RUN chmod +x db_init.sh

ENTRYPOINT ["./db_init.sh"]