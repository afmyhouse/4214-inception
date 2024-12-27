#!/bin/sh

# Change 'listen' param at file www.conf
sed -i '/listen = /c\listen = 9000' /etc/php/7.4/fpm/pool.d/www.conf

# Creates folder for PHP
mkdir -p /run/php/

# Creates folder for wordpress and go there
mkdir -p /var/www/html/wordpress
cd /var/www/html/wordpress

# Set DB vars from secrets
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_HOST=$(cat /run/secrets/db_host)
MYSQL_DATABASE=$(cat /run/secrets/db_name)
WP_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

if [ ! -f "wp-config.php" ]; then
	# Download && install wp-cli
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
	# Change mode for wp to be executable
	chmod +x /usr/local/bin/wp
	# Download and configure wp to connect to database
	wp core download --allow-root
	# Waiting time for db to be up
	echo "Waiting for db to be up & running"
	sleep 5
	cp wp-config-sample.php wp-config.php
	sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php
	sed -i "s/localhost/$MYSQL_HOST/g" wp-config.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
	sed -i "s/define( 'WP_DEBUG', false )/define( 'WP_DEBUG', true )/g" wp-config.php
	# Install wp with following config
	wp core install --url="https://antoda-s.42.fr" --title="Inception" --admin_user=$WP_ADMIN --admin_password=$WP_PASSWORD --admin_email=antoda-s@student.42porto.com --skip-email --allow-root
	# Create user 2
	wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root --path=/var/www/html/wordpress
fi

# Executa o PHP-FPM
exec php-fpm7.4 -F
