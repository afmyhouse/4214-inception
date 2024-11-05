FROM alpine:3.8

# Copy custom configuration and initialization files if needed
# Optional if you have custom configurations
COPY ./conf/mariadb.cnf /etc/mysql/mariadb.cnf
# Optional if you have SQL to initialize
COPY ./conf/init.sql /docker-entrypoint-initdb.d/  

# Expose the default MariaDB port
EXPOSE 3306
