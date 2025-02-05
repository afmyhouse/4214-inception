#!/bin/sh

# Ensure backup directory exists
mkdir -p /home/backup/wordpress /home/backup/database

# Remove old WordPress backup
rm -rf /home/backup/wordpress/*

# Backup WordPress files
rsync -a /var/www/html/ /home/backup/wordpress/

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

# Protect decrypted secrets file
chmod 600 /run/secrets/secrets.txt

# Open script scope for secrets safety
(
    # Set DB credentials from secrets file
    MYSQL_PASS=$(grep 'db_password=' /run/secrets/secrets.txt | cut -d '=' -f2)

    # Remove secrets file after reading credentials
    rm /run/secrets/secrets.txt
    echo "Secrets 'temporary file' deleted..."

    # Backup database
    mysqldump -h mariadb -P 3306 -u "$MYSQL_USER" -p"$MYSQL_PASS" "$MYSQL_DATABASE" > /home/backup/database/db_backup.sql
)
