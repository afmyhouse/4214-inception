#!/bin/sh

# entrypoint.sh nginx image

# Create folder for certificates
mkdir -p /etc/nginx/ssl

# create certificates
openssl req -x509 -nodes -days 365 -new -keyout /etc/nginx/ssl/antoda-s.key -out /etc/nginx/ssl/antoda-s.crt -subj "/CN=$DOMAIN_NAME/O=42/OU=42Porto/C=PT/ST=Porto/L=Porto"

# command to start nginx server
exec nginx -g "daemon off;"
