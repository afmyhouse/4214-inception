#docker file
FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y wget php php-mysqli && rm -rf /var/lib/apt/lists/*

# Copy entrypoint script
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]


FROM debian:bullseye

# Install dependencies
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y wget php php-mysqli

# Copy the entrypoint script
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the working directory
WORKDIR /var/www/html

# Run the entrypoint script when the container starts
ENTRYPOINT ["/entrypoint.sh"]

# Start the PHP server
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]



#entrypoint
#!/bin/sh

# Ensure /var/www/html exists and has correct permissions
mkdir -p /var/www/html
chmod -R 755 /var/www/html
chown -R www-data:www-data /var/www/html

# # Download Adminer
wget -q -O /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

# # Start PHP's built-in web server
exec php -S 0.0.0.0:8080 -t /var/www/html
trap 'echo "Gracefully stopping Adminer..." && exit 0' SIGTERM