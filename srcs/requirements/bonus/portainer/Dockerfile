FROM debian:bullseye

RUN apt-get update && apt install -y \
	wget \
	tar

RUN wget https://github.com/portainer/portainer/releases/download/2.27.3/portainer-2.27.3-linux-amd64.tar.gz
RUN tar -xzf portainer-2.27.3-linux-amd64.tar.gz
RUN rm portainer-2.27.3-linux-amd64.tar.gz
ENTRYPOINT ["./portainer/portainer --disable-security-timeout"]
