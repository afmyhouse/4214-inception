FROM debian:bullseye

# install nginx and openssl (package for creating and managing SSL/TLS certificates and keys)
RUN apt-get update && apt-get install -y nginx openssl

# generate a new self-signed certificate and key (for a secure connection (HTTPS))
# req: This subcommand specifies that we want to use X.509 certificate signing request (CSR) management.
# -x509: This option outputs a self-signed certificate instead of a certificate request.
# -nodes: This option tells OpenSSL to skip the option to secure our certificate with a passphrase.
RUN openssl req -x509 -nodes -days 365 -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
    -out /etc/ssl/certs/ssl-cert-snakeoil.pem \
    -subj "/CN=antoda-s/O=42/OU=42Porto/C=PT/L=Porto"

# This directory is meant to contain configuration files for all possible sites that could be served by Nginx.
COPY ./conf/nginx.conf /etc/nginx/sites-available/

# To enable a site, create a symbolic link to the configuration file in the /etc/nginx/sites-enabled/ directory.
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

CMD ["nginx", "-g", "daemon off;"]
