#!/bin/bash

mysqld_safe &

while ! mariadb-admin --silent ping -h localhost;
do
	echo "waiting for mariadb to initialize..\n" 
	sleep 1
done


mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MDB_ROOT_PW}');"

mysql -u root -p${MDB_ROOT_PW} < database.txt

wait