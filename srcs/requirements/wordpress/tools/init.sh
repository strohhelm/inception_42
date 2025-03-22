#!/bin/bash

# https://www.linode.com/docs/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/#download-and-configure-wordpress
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
# cp /index.html var/www/html/


#Download and configure Wordpress

mkdir -p /var/www/html/$DOMAIN_NAME/public_html
chown -R www-data:www-data /var/www/html/$DOMAIN_NAME/public_html
chown www-data:www-data /var/www/html/$DOMAIN_NAME/public_html

cd /var/www/html/$DOMAIN_NAME/public_html

wp core download --allow-root
wp core config  --dbname=$MDB_NAME --dbuser=$MDB_USER --dbpass=$MDB_USER_PW --dbhost=mariadb --allow-root

until wp db check --allow-root; do
  echo "[WORDPRESS] Waiting for MariaDB to be ready..."
  sleep 5
done

wp core install  --title=$TITLE --admin_user=$MDB_USER --admin_password=$MDB_USER_PW  --admin_email=$MDB_USER@$DOMAIN_NAME --allow-root #--url=$DOMAIN_NAME


exec php-fpm7.4 -F
