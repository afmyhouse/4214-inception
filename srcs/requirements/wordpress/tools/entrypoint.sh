#!/bin/bash

# Read secrets from bind-mounted files with error handling
if [ -f /run/secrets/db_password ]; then
    export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
else
    echo "Error: /run/secrets/db_password not found" >&2
    exit 1
fi

if [ -f /run/secrets/db_name ]; then
    export MYSQL_DATABASE=$(cat /run/secrets/db_name)
else
    echo "Error: /run/secrets/db_name not found" >&2
    exit 1
fi

if [ -f /run/secrets/db_host ]; then
    export MYSQL_HOST=$(cat /run/secrets/db_host)
else
    echo "Error: /run/secrets/db_host not found" >&2
    exit 1
fi

if [ -f /run/secrets/wp_user_password ]; then
    export WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
else
    echo "Error: /run/secrets/wp_user_password not found" >&2
    exit 1
fi

if [ -f /run/secrets/wp_admin_password ]; then
    export WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
else
    echo "Error: /run/secrets/wp_admin_password not found" >&2
    exit 1
fi

# Modify PHP-FPM configuration
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = wordpress:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Create the directory for PHP if not present
mkdir -p /run/php/

# Check if wp-config.php exists
if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    echo "Setting up WordPress..."

    # Install WP-CLI
    echo "Installing WP-CLI..."
    wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && \
    chmod 777 /usr/local/bin/wp

    # Prepare WordPress directory
    mkdir -p /var/www/html/wordpress
    cd /var/www/html/wordpress

    # Download WordPress
    wp core download --allow-root
    sleep 3

    # Configure WordPress
    wp config create --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="${MYSQL_HOST}" --allow-root

    # Install WordPress
    wp core install \
        --url="${WP_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email --allow-root

    wp user create "${WP_USER}" "${WP_USER_EMAIL}" --role=author --user_pass="${WP_USER_PASSWORD}" --allow-root
else
    echo "WordPress already installed and configured"
fi

echo "Access WordPress site here: https://antoda-s.42.fr"

# Start PHP-FPM
exec php-fpm7.4 -F
