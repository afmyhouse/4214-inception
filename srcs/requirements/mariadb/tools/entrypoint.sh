#!/bin/bash

sleep 2

export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
export MYSQL_DATABASE=$(cat /run/secrets/db_name)

# Initialize database if necessary
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initializing database..."

    # Start the server in the background
    mysqld_safe --datadir=/var/lib/mysql --user=mysql &
    sleep 5

    # Setup user and database
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};" -h localhost
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" -h localhost
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" -h localhost
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;" -h localhost
    
    # Shutdown the server
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
else
    echo "Database already initialized"
fi

# Start the server
exec mysqld --bind-address=0.0.0.0 --user=mysql
