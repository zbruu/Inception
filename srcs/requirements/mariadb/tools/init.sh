i#!/bin/bash

# If a command fails, the script stops
set -e

# Lauches mariadb temporarily to configurate the database
service mariadb start

# Leaves some time for the mariadb server to launch
sleep 2

#${MYSQL_*} datas are retrieved from .env

# Creates my WordPress base
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

# Creates a user profile for WordPress
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Gives rights to this user on the database
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"

# Define the root password
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# Recharges the authorizations
mysql -e "FLUSH PRIVILEGES;"

# Stops the temprary server
service mariadb stop

# Important to lauch mariadb in pid 1 and to replace the bash process (good practice)
exec mysqld_safe

