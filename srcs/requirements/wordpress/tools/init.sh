#!/bin/bash

# Wait for MariaDB
sleep 5

cd /var/www/html

# Create a wp-config.php if absent
if [ ! -f wp-config.php ]; then
	cp wp-config-sample.php wp-config.php

	sed -i "s/database_name_here/${MYSQL_DATABASE}/g" wp-config.php
	sed -i "s/username_here/${MYSQL_USER}/g" wp-config.php
	sed -i "s/password_here/${MYSQL_PASSWORD}/g" wp-config.php
	sed -i "s/localhost/mariadb/g" wp-config.php
fi

# Launch php-fpm (replaces bash and becomes PID 1)
exec php-fpm7.4 -F
root@bde-la-p:~/incept
