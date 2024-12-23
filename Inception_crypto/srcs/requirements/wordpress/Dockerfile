# wordpress docker file
# Step 1: define OS for the docker iamge
FROM debian:bullseye

# Step 2: Install dependencies
RUN apt-get update && apt upgrade -y
RUN	apt-get install -y wget php-mysqli php-fpm

# Step 3: Install MySQL client tools required to query if DB is up and running
RUN apt-get update && apt-get install -y default-mysql-client

# Step 4: Copy custom entrypoint script
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Step 6: Set entrypoint
ENTRYPOINT ["sh", "entrypoint.sh"]