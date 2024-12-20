FROM debian:bullseye
RUN apt update && apt upgrade -y
RUN	apt-get install -y mariadb-server
# RUN	apt-get install -y net-tools mariadb-server

COPY ./tools/SetupMariaDB.sh /
RUN chmod +x /SetupMariaDB.sh
ENTRYPOINT ["sh", "/SetupMariaDB.sh"]