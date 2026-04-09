#!/bin/bash

# If a command fails, the script stops
#set -e

# Lauches mariadb temporarily to configurate the database
#mysqld_safe --datadir=/var/lib/mysql --user=mysql &

# Leaves some time for the mariadb server to launch
#sleep 5

#${MYSQL_*} datas are retrieved from .env
#mysql -u root << EOF
#ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
#CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
#CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
#GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
#FLUSH PRIVILEGES;
#EOF


# Creates my WordPress base
#mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

# Creates a user profile for WordPress
#mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Gives rights to this user on the database
#mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"

# Define the root password
#mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# Recharges the authorizations
#mysql -e "FLUSH PRIVILEGES;"

# Stops the temprary server
#mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Important to lauch mariadb in pid 1 and to replace the bash process (good practice)
#exec mysqld_safe
#

#!/bin/bash

set -e

mysqld_safe --datadir=/var/lib/mysql --user=mysql &
pid="$!"

# wait MariaDB ready (IMPORTANT)
until mysqladmin ping --silent; do
    sleep 2
done

mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

wait "$pid"

exec mysqld_safe

