#!/bin/bash
set -e


WP_PATH=/var/www/html/
WP_ADMIN_PW=$(cat /run/secrets/wp_admin_pw)
WP_USER_PW=$(cat /run/secrets/wp_user_pw)
# echo "[DEBUG] Wordpress admin password: $WP_ADMIN_PW"
# echo "[DEBUG] wp user : $WP_USER "
# echo "[DEBUG] wp user password: $WP_USER_PW "
# https://www.linode.com/docs/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/#download-and-configure-wordpress


# downloading the wordpress executables
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

mkdir -p	$WP_PATH
cd			$WP_PATH

# checking if it wordpress is already downloaded
if [ ! -f $WP_PATH/readme.html ]; then

	wp core download	--allow-root
fi

# checking if the config is already created
if [ ! -f $WP_PATH/wp-config.php ]; then
	echo "Creating wp-config.php"
	wp config create	--dbname=$DB_NAME \
						--dbuser=$WP_ADMIN \
						--dbpass=$WP_ADMIN_PW \
						--dbhost=mariadb:3306 \
						--allow-root
else
	echo "wp-config.php already exists."
fi

# checking if wp is already installed
if ! wp core is-installed --allow-root; then
	wp core install	--title=$DOMAIN_TITLE \
					--admin_user=$WP_ADMIN \
					--admin_password=$WP_ADMIN_PW \
					--admin_email="$WP_ADMIN@$DOMAIN_NAME.de" \
					--skip-email \
					--allow-root \
					--url=https://$DOMAIN_NAME
else
	echo "WordPress is already installed."
fi

# checking if wp user required by subject is already existing
if ! wp user exists $WP_USER	--allow-root; then
	wp user create $WP_USER	$WP_USER@$DOMAIN_NAME.de --user_pass=$WP_USER_PW --allow-root
fi

# setting up redis cache

if ! wp plugin is-installed redis-cache --allow-root; then
	wp plugin install redis-cache --allow-root
else
	echo "[WORDPRESS] redis cache plugin already installed..."
fi

if ! wp plugin is-active redis-cache --allow-root; then
	wp plugin activate redis-cache --allow-root
else
	echo "[WORDPRESS] redis cache plugin already activated..."
fi
wp plugin update --all --allow-root
wp config set WP_REDIS_HOST redis --allow-root
wp config set WP_REDIS_PORT 6379 --allow-root
wp config set WP_REDIS_DEBUG true --allow-root;
wp redis enable --allow-root

exec php-fpm7.4 -F