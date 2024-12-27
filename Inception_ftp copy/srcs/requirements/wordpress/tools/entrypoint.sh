#!/bin/sh

# entrypoint.sh for 'wordpress' docker image

# Change 'listen' param at file www.conf
sed -i '/listen = /c\listen = 9000' /etc/php/7.4/fpm/pool.d/www.conf

# Creates folder for PHP
mkdir -p /run/php/

# Creates folder for wordpress and go there
mkdir -p /var/www/html/wordpress
cd /var/www/html/wordpress

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
	# Set DB access vars from decrypted secrets file
	# MYSQL_DATABASE=$(grep 'db_name=' /run/secrets/secrets.txt | cut -d '=' -f2)
	# MYSQL_USER=$(grep 'db_user=' /run/secrets/secrets.txt | cut -d '=' -f2)
	MYSQL_PASSWORD=$(grep 'db_password=' /run/secrets/secrets.txt | cut -d '=' -f2)
	# MYSQL_HOST=$(grep 'db_host=' /run/secrets/secrets.txt | cut -d '=' -f2)
	# WP_ADMIN=$(grep 'wp_admin=' /run/secrets/secrets.txt | cut -d '=' -f2)
	WP_ADMIN_PASSWORD=$(grep 'wp_admin_password=' /run/secrets/secrets.txt | cut -d '=' -f2)
	WP_ADMIN_EMAIL=$(grep 'wp_admin_email=' /run/secrets/secrets.txt | cut -d '=' -f2)
	# WP_USER=$(grep 'wp_user=' /run/secrets/secrets.txt | cut -d '=' -f2)
	WP_USER_PASSWORD=$(grep 'wp_user_password=' /run/secrets/secrets.txt | cut -d '=' -f2)
	WP_USER_EMAIL=$(grep 'wp_user_email=' /run/secrets/secrets.txt | cut -d '=' -f2)

	echo ""
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	echo "MYSQL_DATABASE: $MYSQL_DATABASE"
	echo "MYSQL_USER: $MYSQL_USER"
	echo "MYSQL_PASSWORD: $MYSQL_PASSWORD"
	echo "MYSQL_HOST: $MYSQL_HOST"
	echo "WP_ADMIN: $WP_ADMIN"
	echo "WP_ADMIN_PASSWORD: $WP_ADMIN_PASSWORD"
	echo "WP_ADMIN_EMAIL: $WP_ADMIN_EMAIL"
	echo "WP_USER: $WP_USER"
	echo "WP_USER_PASSWORD: $WP_USER_PASSWORD"
	echo "WP_USER_EMAIL: $WP_USER_EMAIL"
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	echo ""

	rm /run/secrets/secrets.txt
    echo "Secrets 'temporary file' deleted..."

	# Dowload and Configure wordpress
	if [ ! -f "wp-config.php" ]; then
		# Download && install wp-cli
		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
		# Change mode for wp to be executable
		chmod +x /usr/local/bin/wp
		# Download and configure wp to connect to database
		wp core download --allow-root

		# Wait for MariaDB to be ready
		echo "Waiting for MariaDB to be ready..."
		until mysql -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1;" > /dev/null 2>&1; do
			echo "MariaDB is not ready. Retrying..."
			sleep 1
		done
		echo "MariaDB is up and running!"

		# Setup wp-config.php file
		cp wp-config-sample.php wp-config.php
		sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
		sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php
		sed -i "s/localhost/$MYSQL_HOST/g" wp-config.php
		sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
		sed -i "s/define( 'WP_DEBUG', false )/define( 'WP_DEBUG', true )/g" wp-config.php
		
		# Install wp with following config
		wp core install --url="https://antoda-s.42.fr" --title="Inception" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
		
		# Create user 2
		wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root --path=/var/www/html/wordpress
		# Create user 2 : DONE!
	fi
	    # Set correct permissions
    echo "Setting  permissions for WordPress directory..."
    find /var/www/html/wordpress -type d -exec chmod 777 {} \;
    find /var/www/html/wordpress -type f -exec chmod 777 {} \;
    echo "All done!"
)
# Executa o PHP-FPM
exec php-fpm7.4 -F
