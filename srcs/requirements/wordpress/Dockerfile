FROM alpine:3.18

LABEL Name=af_wordpress Version=0.0.1

RUN apk update && apk add php7 php7-fpm php7-mysqli php7-json

# Download and extract WordPress
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzvf latest.tar.gz && rm latest.tar.gz && \
    mv wordpress/* . && rmdir wordpress

COPY conf/wp-config.php /var/www/html/wp-config.php

EXPOSE 9000

CMD ["php-fpm7", "-F"]
