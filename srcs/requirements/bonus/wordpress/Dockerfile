# wordpress docker file
# Step 1: define OS for the docker iamge
FROM debian:bullseye

# Step 2: Install dependencies
RUN apt-get update && apt upgrade -y \
    && apt-get install -y wget php-mysqli php-fpm \
    && apt-get install -y redis-server php-redis
    # Step 3: Install MySQL client tools required to query if DB is up and running
    #issue 23 RUN apt-get update && apt-get install -y default-mysql-client
RUN apt-get install -y default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Step 4: Copy custom entrypoint script
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Try fix issue REDIS filesystem not writable : Ensure WordPress has correct ownership before starting
#WORKDIR /var/www/html/wordpress
#USER www-data

# Step 6: Set entrypoint
ENTRYPOINT ["sh", "entrypoint.sh"]