# syntax=docker/dockerfile:1
FROM debian:oldstable

RUN apt-get update; apt install -y curl mariadb-server

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY ./tools/init.sh .
COPY ./tools/database.txt .

RUN chmod +x init.sh

ENTRYPOINT ["./init.sh"]
