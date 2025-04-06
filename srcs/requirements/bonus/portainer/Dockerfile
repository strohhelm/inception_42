FROM debian:bullseye

RUN apt-get update && apt install -y \
	wget \
	tar

RUN if [ ! -f ./portainer/portainer ]; then \
		wget https://github.com/portainer/portainer/releases/download/2.16.2/portainer-2.16.2-linux-amd64.tar.gz && \
		tar -xzf portainer-2.27.3-linux-amd64.tar.gz && \
		rm portainer-2.27.3-linux-amd64.tar.gz; \
	fi
ENTRYPOINT ["./portainer/portainer --admin-password-file=/run/secrets/port_admin_pw"]
