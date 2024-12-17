FROM alpine:3.19

EXPOSE 9000
EXPOSE 3306

LABEL Name=af_wordpress Version=0.0.1

RUN apk add wget php82 php82-phar php82-fpm php82-iconv fcgi php82-cgi php82-mysqli \
    && adduser -D -g 'www' www \
    && mkdir /var/www/html

# Download and extract WordPress
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && rm latest.tar.gz && \
    mv wordpress/* . && rmdir wordpress

COPY conf/wp-config.php /var/www/html/wp-config.php


CMD ["php-fpm7", "-F"]
