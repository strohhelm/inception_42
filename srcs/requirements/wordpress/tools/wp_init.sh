#!/bin/bash



WP_PATH=/var/www/html/$DOMAIN_NAME/public_html
MDB_USER_PW=$(cat /run/secrets/db_password.txt)
# https://www.linode.com/docs/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/#download-and-configure-wordpress
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp


mkdir -p $WP_PATH


cd $WP_PATH

wp core download --allow-root
wp config create	--dbname=$MDB_NAME \
					--dbuser=$MDB_USER \
					--dbpass=$MDB_USER_PW \
					--dbhost=mariadb:3306 \
					--allow-root

until wp db check --allow-root; do
  echo "[WORDPRESS] Waiting for MariaDB to be ready..."
  sleep 5
done

wp core install  --title=$TITLE --admin_user=$MDB_USER --admin_password=$MDB_USER_PW  --admin_email="$MDB_USER@$DOMAIN_NAME.de" --skip-email --allow-root --url=$DOMAIN_NAME


exec php-fpm7.4 -F
