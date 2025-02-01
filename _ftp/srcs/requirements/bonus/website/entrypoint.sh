#!/bin/sh
# Custom entrypoint script for the website service

# Ensure the HTML directory has the correct permissions
chown -R www-data:www-data /var/www/html

# Start Nginx
exec "$@"