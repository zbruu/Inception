#!/bin/bash

set -x

MYSQL_PASSWORD=$(cat /run/secrets/db_password | tr -d '\n\r')
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password | tr -d '\n\r')

mysql_install_db --user=mysql --datadir=/var/lib/mysql

mysqld_safe --datadir=/var/lib/mysql --user=mysql &

until mysqladmin ping --silent 2>/dev/null; do
    sleep 1
done

if [ ! -f /var/lib/mysql/.initialized ]; then 
	mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_ROOT_PASSWORD}');
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
	touch /var/lib/mysql/.initialized
fi

wait