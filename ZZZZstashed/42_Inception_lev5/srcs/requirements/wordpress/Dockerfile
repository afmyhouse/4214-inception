FROM debian:bullseye

# Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    php-fpm \
    php-mysqli

COPY /tools/entrypoint.sh /tools/entrypoint.sh

RUN chmod +x /tools/entrypoint.sh

ENTRYPOINT [ "/tools/entrypoint.sh" ]
