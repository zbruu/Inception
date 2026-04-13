#!/bin/bash

set -e

cd /var/www/html

# Create a wp-config.php if absent
if [ ! -f wp-config.php ]; then
	cp wp-config-sample.php wp-config.php

	sed -i "s/database_name_here/${MYSQL_DATABASE}/g" wp-config.php
	sed -i "s/username_here/${MYSQL_USER}/g" wp-config.php
	sed -i "s/password_here/${MYSQL_PASSWORD}/g" wp-config.php
	sed -i "s/localhost/mariadb/g" wp-config.php
fi

# Waits for MariaDB to be ready
until mysqladmin ping -h mariadb -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent 2>/dev/null; do
	echo "Waiting for MariaDB..."
	sleep 1
done

# Installs WordPress if not already done
if ! wp core is-installed --allow-root; then
	wp core install \
		--allow-root \
		--url="https://${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_name="${WP_ADMIN_NAME}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--skip-email
	
	# And create a second user (non-admin)
	wp user create "${WP_USER_NAME}" "${WP_USER_EMAIL}" \
		--allow-root \
		--role=author \
		--user_pass="${WP_USER_PASSWORD}"

fi

# Launch php-fpm (replaces bash and becomes PID 1)
exec php-fpm7.4 -F
