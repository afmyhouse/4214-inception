FROM alpine:3.18

LABEL Name=mariadb Version=0.0.1

RUN apk update && apk add mariadb mariadb-client

# Configure MariaDB
COPY conf/mariadb.cnf /etc/my.cnf.d/
COPY conf/init.sql /tmp/init.sql
COPY tools/init.sh /docker-entrypoint-initdb.d/

EXPOSE 3306

CMD ["mysqld"]
