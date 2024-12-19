#!/bin/sh


mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -new -keyout /etc/nginx/ssl/antoda-s.key -out /etc/nginx/ssl/antoda-s.crt -subj "/CN=antoda-s.42.fr/O=42/OU=42Porto/C=PT/ST=Porto/L=Porto"

exec nginx -g "daemon off;"
