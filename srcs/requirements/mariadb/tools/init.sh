#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Initialize the MariaDB database directory if it does not exist.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background to run initialization commands.
mysqld_safe --datadir='/var/lib/mysql' &

# Wait for the MariaDB server to be ready
until mysqladmin ping >/dev/null 2>&1; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done

# Create database and users with environment variables
# mysql -u root <<-EOSQL
#     CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
#     CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
#     CREATE USER IF NOT EXISTS '$MYSQL_ADMIN_USER'@'%' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD';
#     GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
#     GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_ADMIN_USER'@'%';
#     FLUSH PRIVILEGES;
# EOSQL

# Run the SQL file to create the necessary tables and data
mysql -u root $MYSQL_DATABASE < ../conf/init.sql

echo "Database and users have been set up successfully."

# Stop the MariaDB server gracefully
mysqladmin shutdown
