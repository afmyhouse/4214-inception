#!/bin/sh

# Chama o script de configuração do MariaDB
#./start2.sh &

# Aguarda um momento para garantir que o MariaDB esteja pronto para aceitar conexões
#sleep 10

sed -i '/listen = /c\listen = 9000' /etc/php/7.4/fpm/pool.d/www.conf

# Cria o diretório para o PHP
mkdir -p /run/php/

mkdir -p /var/www/html/wordpress

cd /var/www/html/wordpress
if [ ! -f "wp-config.php" ]; then
	# download && install wp-cli
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp
	# ver os documentos do worpress cli
	#chmod +x wp-cli.phar
	#mv wp-cli.phar /usr/local/bin/wp
	chmod +x /usr/local/bin/wp
	# download and configure wp to connect to database
	wp core download --allow-root
	# time for db to be up
	sleep 5
	cp wp-config-sample.php wp-config.php
	sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php
	sed -i "s/localhost/$DB_HOST/g" wp-config.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
	# install wp with following config
	wp core install --url="https://nmoreira.42.fr" --title="Inception" --admin_user=$WP_ADMIN --admin_password=$WP_PASSWORD --admin_email=nmoreira@student.42porto.com --skip-email --allow-root
	# create user
	wp user create $WP_USER nfmt2017@gmail.com --role=author --user_pass=$WP_USER_PASSWORD --allow-root --path=/var/www/html/wordpress
fi

# Executa o PHP-FPM
exec php-fpm7.4 -F
