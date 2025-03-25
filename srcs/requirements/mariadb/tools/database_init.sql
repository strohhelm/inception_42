CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${WP_ADMIN}'@'%' IDENTIFIED BY '${WP_ADMIN_PW}';
GRANT ALL PRIVILEGES ON  ${DB_NAME}.* TO '${WP_ADMIN}'@'%';
FLUSH PRIVILEGES;