#!/bin/sh


# # Ensure /var/www/html exists and has correct permissions
mkdir -p /var/www/html
chmod -R 755 /var/www/html
chown -R www-data:www-data /var/www/html

# # Download Adminer
wget -q -O /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

# # Start PHP's built-in web server
exec php -S 0.0.0.0:8080 -t /var/www/html
trap 'echo "Gracefully stopping Adminer..." && exit 0' SIGTERM


# # Create the web directory and set permissions
# mkdir -p /var/www/html
# chown -R www-data:www-data /var/www/html

# # Download Adminer
# wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O /var/www/html/index.php

# # Start PHP server in the background
# php -S 0.0.0.0:8080 -t /var/www/html &

# # Capture the PID of the PHP server
# PHP_PID=$!

# # Trap SIGTERM and gracefully stop the PHP server
# trap "echo 'Stopping PHP server...'; kill -TERM $PHP_PID" SIGTERM

# # Wait for the PHP server to exit
# wait $PHP_PID