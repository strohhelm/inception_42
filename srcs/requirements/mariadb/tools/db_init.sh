#!/bin/bash


if [ ! -f /run/secrets/db_root_pw ]; then
	echo "NO DB root PW provided!"
	exit 1
fi

if [ ! -f /run/secrets/wp_admin_pw ]; then
	echo "NO DB root PW provided!"
	exit 1
fi

export DB_ROOT_PW=$(cat /run/secrets/db_root_pw)
export WP_ADMIN_PW=$(cat /run/secrets/wp_admin_pw)

# echo "[DEBUG] wordpress admin password: $WP_ADMIN_PW" 
# echo "[DEBUG] db root password: $DB_ROOT_PW "

## starting mariadb in the background
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

service mariadb start &

echo "[MARIA_DB] waiting for daemon to start"
while ! mysqladmin ping --silent; do
	sleep 1
done

mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${DB_ROOT_PW}');"

echo "[MARIA_DB] setting up wordpress database.."
if ! envsubst < database_init.sql | mysql -u root -p${DB_ROOT_PW}; then
	echo "Database initialization failed!"
	exit 1
fi

service mariadb stop

exec mariadbd
