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

# Protect temporary secrets file
chmod 600 /run/secrets/secrets.txt

# Open script scope for secrets safety
(
    # Extract secrets into environment variables
    # FTP_USER=$(grep 'ftp_user=' /run/secrets/secrets.txt | cut -d '=' -f2)
    FTP_PASSWORD=$(grep 'ftp_password=' /run/secrets/secrets.txt | cut -d '=' -f2)

    echo "FTP_USER: $FTP_USER"
    echo "FTP_PASSWORD: [HIDDEN]"

    # Cleanup temporary secrets file
    rm /run/secrets/secrets.txt
    echo "Secrets 'temporary file' deleted..."



# replace this .....
    # Create the FTP user if it doesn't exist
    # if ! id -u ${FTP_USER} &>/dev/null; then
    #     echo "Creating FTP user ${FTP_USER}..."
    #     useradd -m ${FTP_USER}
    #     echo -e "${FTP_PASSWORD}\n${FTP_PASSWORD}" | passwd ${FTP_USER}
    #     mkdir -p /var/ftp/users/${FTP_USER}/uploads
    # fi
    # Ensure WordPress directory exists and set ownership and permissions
    # if [ ! -d "/var/ftp/wordpress" ]; then
    #     echo "Creating WordPress directory..."
    #     mkdir -p /var/ftp/wordpress
    # fi

# with this ...
    # Create the FTP user if it doesn't exist
    if ! id -u ${FTP_USER} &>/dev/null; then
        echo "Creating FTP user ${FTP_USER}..."
        useradd -m ${FTP_USER}
        echo -e "${FTP_PASSWORD}\n${FTP_PASSWORD}" | passwd ${FTP_USER}
        mkdir -p /var/ftp/users/${FTP_USER}/uploads
        mkdir -p /var/ftp/users/${FTP_USER}/wordpress
    fi

    echo "Ensure FTP user has access to WordPress directory"
    ln -s /var/ftp/users/${FTP_USER}/wordpress
    # chown -h ${FTP_USER}:${FTP_USER} /var/ftp/wordpress
    chown -R ${FTP_USER}:${FTP_USER} /var/ftp/users/${FTP_USER}/wordpress
    chmod -R 775 /var/ftp/users/${FTP_USER}/wordpress

# END of replace




    # Set correct ownership and permissions

    # echo "Setting ownership and permissions for WordPress directory..."
    # chown -R ${FTP_USER}:${FTP_USER} /var/ftp/wordpress
    # find /var/ftp/wordpress -type d -exec chmod 755 {} \;
    # find /var/ftp/wordpress -type f -exec chmod 644 {} \;

    # Ensure FTP user has access to WordPress directory
    # ln -s /var/ftp/wordpress /var/ftp/users/${FTP_USER}/wordpress
    # chown -h ${FTP_USER}:${FTP_USER} /var/ftp/users/${FTP_USER}/wordpress

    # Set write permissions for FTP user on WordPress directory
    # chmod -R 775 /var/ftp/wordpress
    # echo "WordPress directory linked to FTP user's home directory."
)

# Start vsftpd in the foreground
echo "Starting vsftpd..."
exec vsftpd /etc/vsftpd.conf
