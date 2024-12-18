#!/bin/sh

#SETUP='/init.sql'

# Check if database `mysql` has already been created
if [ ! -d "/var/lib/mysql/mysql" ]; then

    # Initialize the MySQL database tables and create the necessary files in the
    # specified data directory with the specified MySQL user and based directory.
    echo "Install mariadb for the first time"
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

fi

cat /tmp/init.sql | envsubst > /tmp/mysql_init.sql

# Execute the daemon as the "mysql" user, using the specified data directory,
# port, and initial file, and passes all arguments ($@) to it
# sudo chown -R mysql:mysql /var/lib/mysql/wordpress

echo "Start mysql daemon to receive arguments"
exec mysqld --user=mysql --datadir="/var/lib/mysql" --port=3306 --init-file=/tmp/mysql_init.sql $@



# Check if mysql is root protected
# docker exec -it mariadb sh