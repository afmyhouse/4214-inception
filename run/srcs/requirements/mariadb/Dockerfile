FROM debian:bullseye

# Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean

COPY ./tools/entrypoint.sh /tools/entrypoint.sh

RUN chmod +x /tools/entrypoint.sh

# Set the entrypoint script as the default command
ENTRYPOINT ["/tools/entrypoint.sh"]
