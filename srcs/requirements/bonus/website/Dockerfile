FROM debian:bullseye

RUN apt-get update && apt install -y php

COPY index.html /var/www/html/index.html

ENTRYPOINT ["php", "-S", "0.0.0.0:6969", "-t", "/var/www/html/"]
