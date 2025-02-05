FROM debian:bullseye

# Install required packages
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y cron rsync mariadb-client openssl

# Copy scripts
COPY ./tools/entrypoint.sh /entrypoint.sh
COPY ./tools/backup.sh /backup.sh

# Set permissions
RUN chmod +x /entrypoint.sh /backup.sh

# Run entrypoint script at startup
ENTRYPOINT ["/entrypoint.sh"]
