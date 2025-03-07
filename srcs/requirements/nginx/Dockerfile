# syntax=docker/dockerfile:1
FROM debian:oldstable-slim

RUN	apt-get update;\
	apt install -y \
	curl \
	gnupg2 \
	ca-certificates \
	lsb-release \
	debian-archive-keyring \
	nginx \
	openssl \
	procps \
	&& rm -rf /var/lib/apt/lists/*;

RUN	mkdir -p /etc/nginx/certs; \
	openssl req -x509 -newkey rsa:2048 -nodes \
	-keyout /etc/nginx/certs/server.key \
	-out /etc/nginx/certs/server.crt \
	-days 365 \
	-subj "/CN=localhost"


COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]


