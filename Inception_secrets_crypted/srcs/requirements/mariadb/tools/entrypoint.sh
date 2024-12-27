#!/bin/bash

# entrypoint.sh for 'mariadb' docker image

# Decrypt secrets
if [ -f /run/secrets/secrets.enc ]; then
    echo "Decrypting Secrets to 'temporary file'... "
    openssl enc -aes-256-cbc -d -pbkdf2 -in /run/secrets/secrets.enc -out /run/secrets/secrets.txt -pass pass:$(cat /run/secrets/secret_key)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to decrypt secrets."
        exit 1
    fi
    echo "Secrets decrypted successfully."
else
    echo "Error: Encrypted secrets file not found."
    exit 1
fi

# protect temporay secrets file
chmod 600 /run/secrets/secrets.txt

# Open script scope for secrets safety
(
    # Extract secrets into environment variables
    MYSQL_ROOT_PASSWORD=$(grep 'db_root_password=' /run/secrets/secrets.txt | cut -d '=' -f2)
    #MYSQL_DATABASE=$(grep 'db_name=' /run/secrets/secrets.txt | cut -d '=' -f2)
    #MYSQL_USER=$(grep 'db_user=' /run/secrets/secrets.txt | cut -d '=' -f2)
    MYSQL_PASSWORD=$(grep 'db_password=' /run/secrets/secrets.txt | cut -d '=' -f2)

    rm /run/secrets/secrets.txt
    echo "Secrets 'temporary file' deleted..."

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

        # Shutdown the server 
        mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown 
    else
        echo "Database already initialized"
    fi
)
# exec mysqld --user=mysql --skip-networking=false #--port=3306
exec mysqld --bind-address=0.0.0.0 --user=mysql
