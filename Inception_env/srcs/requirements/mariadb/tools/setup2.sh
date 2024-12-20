#!/bin/bash

#funciona direitinho
#mkdir -p /run/mysqld
#chown -R mysql:mysql /run/mysqld

#sleep 2

# Initialize database if necessary
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initializing database..."

    # Start the server in the background
    mysqld_safe --datadir=/var/lib/mysql --user=mysql &
    sleep 2

    # Setup user and database
    mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};" -h localhost
    mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" -h localhost
    mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" -h localhost
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;" -h localhost

    # Shutdown the server estava o primeiro
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown 
    #kill $(cat /var/run/mysqld/mysqld.pid)
else
    echo "Database already initialized"
fi

# Start the server
# echo "Check Port"
# netstat -lntp | grep 3306
# echo "End Check Port"

# exec mysqld --user=mysql --skip-networking=false #--port=3306
exec mysqld --bind-address=0.0.0.0 --user=mysql
