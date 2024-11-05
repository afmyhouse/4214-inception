FROM alpine:3.8

RUN apk update && apk add mariadb mariadb-client openrc
RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld

# Copy custom configuration and initialization files if needed
# Optional if you have custom configurations
COPY ./conf/mariadb.cnf /etc/mysql/mariadb.cnf
# Optional if you have SQL to initialize
# COPY ./conf/init.sql /docker-entrypoint-initdb.d/
COPY ./conf/init.sh /tmp/

# Expose the default MariaDB port
EXPOSE 3306


ENTRYPOINT [ "sh", "/tmp/init.sh" ]
