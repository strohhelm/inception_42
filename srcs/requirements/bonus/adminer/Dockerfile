FROM debian:bullseye

RUN apt-get update && apt install -y wget php php-mysql

RUN rm /var/www/html/index.html
RUN wget -O /var/www/html/index.php https://www.adminer.org/latest.php

# RUN chown -R www-data:www-data /var/www/html/index.php
# RUN chmod 755 /var/www/html/index.php
# USER www-data
EXPOSE 80

ENTRYPOINT ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html/"]