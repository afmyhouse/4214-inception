#!/bin/sh

#while ! --host=mariadb --user=$MARIADB_USER --password=$MARIADB_USER_PASSWORD wordpress; do
#     sleep 3
#done

cd /var/www/html/wordpress
echo Instalando database
if [ ! -f "/var/www/html/wordpress/index.php" ]; then
    wp core download --allow-root
    wp config create --dbname=$WP_DATABASE_NAME --dbuser=$MARIADB_USER --dbpass=$MARIADB_USER_PASSWORD --dbhost=$MARIADB_HOST --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
    # wp core install --url=${DOMAIN_NAME}/wordpress --title=${WP_TITLE} --admin_user=${WP_DATABASE_USER} --admin_password=${WP_DATABASE_PASSWORD} --admin_email=${WP_EMAIL} --skip-email --allow-root
    # wp user create ${WP_USER_LOGIN} ${WP_USER_EMAIL} --role=author --user_pass=${WP_USER_PASSWORD} --allow-root
    wp core install --allow-root \
	--url=https://$DOMAIN_NAME \
	--title=$WP_TITLE \
	--admin_user=$WP_DATABASE_USER \
	--admin_password=$WP_DATABASE_PASSWORD \
	--admin_email=$WP_EMAIL \
	#create user
	wp user create --allow-root \
		$WP_USER_LOGIN \
		$WP_USER_EMAIL \
		--role=author \
		--user_pass=$WP_USER_PASSWORD
fi
# Config php.ini
sed -i "s/memory_limit = .*/memory_limit = 256M/" /etc/php/7.3/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 128M/" /etc/php/7.3/fpm/php.ini
sed -i "s/zlib.output_compression = .*/zlib.output_compression = on/" /etc/php/7.3/fpm/php.ini
sed -i "s/max_execution_time = .*/max_execution_time = 18000/" /etc/php/7.3/fpm/php.ini

echo heitor > index.html

echo "Starting Wordpress on :9000"
service php7.3-fpm start
service php7.3-fpm stop
/usr/sbin/php-fpm7.3 -F -R