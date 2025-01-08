# mariadb docker file
# Step 1: define OS for the docker iamge
FROM debian:bullseye

# Step 2: Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    libaio1 && \
    rm -rf /var/lib/apt/lists/*

# Step 3: Add MariaDB repository and install
RUN wget https://downloads.mariadb.com/MariaDB/mariadb_repo_setup && \
    bash mariadb_repo_setup --mariadb-server-version=10.5 && \
    apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Step 4: Copy custom entrypoint script
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Step 5: Expose ports and volumes
EXPOSE 3306
VOLUME ["/var/lib/mysql"]

# Step 6: Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
