FROM debian:bullseye
RUN apt update && apt upgrade -y
RUN	apt-get install -y mariadb-server
# RUN	apt-get install -y net-tools mariadb-server

COPY ./tools/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]