#!/bin/bash

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
    FTP_USER=$(grep 'ftp_user=' /run/secrets/secrets.txt | cut -d '=' -f2)
    FTP_PASSWORD=$(grep 'ftp_password=' /run/secrets/secrets.txt | cut -d '=' -f2)

    echo "FTP_USER: $FTP_USER"
    echo "FTP_PASSWORD: $FTP_PASSWORD"

    rm /run/secrets/secrets.txt
    echo "Secrets 'temporary file' deleted..."
# Create the FTP user if it doesn't exist
if [ ! -d "/var/ftp/users/${FTP_USER}" ]; then
    echo "Creating FTP user ${FTP_USER}..."
    useradd -m ${FTP_USER}
    echo -e "${FTP_PASSWORD}\n${FTP_PASSWORD}" | passwd ${FTP_USER}
    mkdir -p /var/ftp/users/${FTP_USER}/uploads
    chown -R ${FTP_USER}:${FTP_USER} /var/ftp/users/${FTP_USER}
fi
)
# Start vsftpd in the foreground
vsftpd /etc/vsftpd.conf
