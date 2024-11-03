FROM debian:10.11

RUN apt-get update -y && \
    apt-get install -y \
    curl \
    tar \
    mariadb-client \
    php7.3-cli \
    php7.3-fpm \
    php7.3-mysql \ 
    php7.3-json \
    php7.3-opcache \
    php7.3-mbstring \
    php7.3-xml \
    php7.3-cgi \
    php-pear \
    php7.3-zip \
    php-net-socket \
    php7.3-common \
    php7.3-gd php7.3-curl \
    php-xml-util \
    php7.3-gettext \
    php7.3-bcmath

#WORKDIR /var/www/html
#RUN curl -O https://wordpress.org/latest.tar.gz
#RUN tar -xvzf latest.tar.gz

# Download and install wp-cli, this allow us configure users to wordpress by command line.

COPY conf/php-fpm.conf /etc/php7/php-fpm.conf

# solve bad gateway problem
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/
COPY conf/wp-cli.phar /tmp
COPY tools/run.sh /tmp/run.sh
RUN mkdir -p /var/www/html/wordpress
COPY conf/wp-config.php /var/www/html/wordpress
WORKDIR /tmp

RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN chown -R www-data:www-data /var/www/html/wordpress


EXPOSE 9000

ENTRYPOINT [ "sh", "/tmp/run.sh" ]