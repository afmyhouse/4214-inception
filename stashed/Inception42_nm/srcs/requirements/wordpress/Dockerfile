FROM debian:bullseye

RUN apt-get update && apt upgrade -y
RUN	apt-get install -y wget php-mysqli php-fpm

COPY ./tools/setup3.sh /run.sh
RUN chmod +x /run.sh
ENTRYPOINT ["sh", "run.sh"]