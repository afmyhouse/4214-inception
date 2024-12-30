#!/bin/bash

SOCKET_DIR="/var/run/mysqld"
SOCKET_FILE="${SOCKET_DIR}/mysqld.sock"

# Ensure the socket directory exists
if [ ! -d "$SOCKET_DIR" ]; then
    mkdir -p "$SOCKET_DIR"
    chown -R mysql:mysql "$SOCKET_DIR"
fi

# Ensure the data directory exists
if [ ! -d "/var/lib/mysql" ]; then
    mkdir -p /var/lib/mysql
    chown -R mysql:mysql /var/lib/mysql
fi

# Check if MariaDB is initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mysqld --initialize-insecure --datadir=/var/lib/mysql --user=mysql
    echo "Database initialized."
else
    echo "MariaDB database already exists. Ensuring permissions are correct..."
    chown -R mysql:mysql /var/lib/mysql
fi

# Start MariaDB server in the background for setup
mysqld_safe --datadir=/var/lib/mysql --socket="$SOCKET_FILE" --user=mysql &
echo "Starting MariaDB for setup..."
while ! mysqladmin --socket="$SOCKET_FILE" ping --silent; do
    echo "Waiting for db..."
    sleep 2
done
echo "MariaDB is up and running."
# Open script scope for secrets safety
(
    # Decrypt secrets
    if [ -f /run/secrets/secrets.enc ]; then
        # echo "Decrypting Secrets to 'temporary file'... "
        openssl enc -aes-256-cbc -d -pbkdf2 -in /run/secrets/secrets.enc -out /run/secrets/secrets.txt -pass pass:$(cat /run/secrets/secret_key)
        if [ $? -ne 0 ]; then
            echo "Error: Failed to decrypt secrets."
            exit 1
        fi
        # echo "Secrets decrypted successfully."
    else
        echo "Error: Encrypted secrets file not found."
        exit 1
    fi
    # protect temporay secrets file
    chmod 600 /run/secrets/secrets.txt
    # Extract secrets into environment variables
    MYSQL_ROOT_PASSWORD=$(grep 'db_root_password=' /run/secrets/secrets.txt | cut -d '=' -f2)
    MYSQL_PASSWORD=$(grep 'db_password=' /run/secrets/secrets.txt | cut -d '=' -f2)

    rm /run/secrets/secrets.txt

    # Apply user and database configurations
    mysql --socket="$SOCKET_FILE" -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"  -h localhost
    mysql --socket="$SOCKET_FILE" -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"  -h localhost
    mysql --socket="$SOCKET_FILE" -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"  -h localhost
    mysql --socket="$SOCKET_FILE" -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"  -h localhost
    mysql --socket="$SOCKET_FILE" -u root -p"${MYSQL_ROOT_PASSWORD}" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"  -h localhost
    mysql --socket="$SOCKET_FILE" -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"  -h localhost

    # Shutdown background MariaDB server
    mysqladmin --socket="$SOCKET_FILE" -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    echo "Setup complete. Shutting down MariaDB."
)
# Start MariaDB normally
exec mysqld --datadir=/var/lib/mysql --socket="$SOCKET_FILE" --user=mysql --bind-address=0.0.0.0
