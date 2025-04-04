FROM debian:bullseye

RUN	apt-get update && apt upgrade -y && apt install -y \
	redis-server

RUN mkdir -p /var/run
COPY ./conf/redis.conf .

EXPOSE 6379

ENTRYPOINT ["redis-server", "./redis.conf"]
