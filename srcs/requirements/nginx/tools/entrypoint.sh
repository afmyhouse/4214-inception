#!/bin/sh

# entrypoint.sh nginx image

# Create folder for certificates
mkdir -p /etc/nginx/ssl
export DOMAIN_NAME_PT=antoda-s.42.pt
# create certificates
openssl req -x509 -nodes -days 365 -new -keyout /etc/nginx/ssl/antoda-s-fr.key -out /etc/nginx/ssl/antoda-s-fr.crt -subj "/CN=$DOMAIN_NAME/O=42/OU=42Porto/C=PT/ST=Porto/L=Porto"
openssl req -x509 -nodes -days 365 -new -keyout /etc/nginx/ssl/antoda-s-pt.key -out /etc/nginx/ssl/antoda-s-pt.crt -subj "/CN=$DOMAIN_NAME_PT/O=42/OU=42Porto/C=PT/ST=Porto/L=Porto"

# command to start nginx server
exec nginx -g "daemon off;"
