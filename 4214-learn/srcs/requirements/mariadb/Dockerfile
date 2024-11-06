FROM debian:10.11

RUN apt-get update && apt-get install mariadb-server mariadb-client gettext-base -y

RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld

COPY ./conf/init.sql /tmp/init.sql
COPY ./conf/my.cnf /etc/mysql/my.cnf
COPY ./tools/init.sh /tmp/init.sh

RUN if [ ! -d "/var/lib/mysql/mysql" ]; then mysql_install_db --basedir=/usr --datadir="/var/lib/mysql" --user=mysql --skip-grant-tables ; fi

ENTRYPOINT [ "sh", "/tmp/init.sh" ]
#ENTRYPOINT [ "mysqld", "--user=mysql", "--basedir=/usr", "--datadir=/var/lib/mysql", "--init-file=/tmp/init.sql"]