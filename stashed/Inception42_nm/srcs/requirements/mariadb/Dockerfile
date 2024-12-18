FROM debian:bullseye
RUN apt update && apt upgrade -y
RUN	apt-get install -y mariadb-server

COPY ./tools/setup2.sh /
RUN chmod +x /setup2.sh
ENTRYPOINT ["sh", "/setup2.sh"]