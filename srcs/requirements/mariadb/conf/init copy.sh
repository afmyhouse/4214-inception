
#!/bin/bash
# init.sh
# Exit immediately if a command exits with a non-zero status.
set -e

# Initialize the MariaDB database directory if it does not exist.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --basedir=/usr --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background to run initialization commands.
mysqld_safe --datadir='/var/lib/mysql' &

# Wait for the MariaDB server to be ready
until mysqladmin ping >/dev/null 2>&1; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done

# SQL 1 Create database and users with environment variables
# mysql -u root <<-EOSQL
#     CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
#     CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD';
#     CREATE USER IF NOT EXISTS '$MYSQL_ADMIN'@'%' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD';
#     GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
#     GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_ADMIN_USER'@'%';
#     FLUSH PRIVILEGES;
# EOSQL

# SQL 2 Create database using an external file
# Run the SQL file to create the necessary tables and data
mysql -u root ${MYSQL_DATABASE} < /tmp/init.sql

echo "Database and users have been set up successfully."

# Stop the MariaDB server gracefully
mysqladmin shutdown
exec mysqld_safe
