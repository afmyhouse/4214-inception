FROM debian:bullseye
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y cron rsync mariadb-client
COPY ./tools/entrypoint.sh /entrypoint.sh
COPY ./tools/backup.sh /backup.sh
RUN chmod +x /entrypoint.sh && chmod +x /backup.sh && /entrypoint.sh
ENTRYPOINT [ "cron", "-f" ]