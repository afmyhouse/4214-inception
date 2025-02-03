# Use Debian Bullseye as the base image
FROM debian:bullseye

# Install dependencies for building Redis
RUN apt-get update && apt-get install -y \
    build-essential \
    tcl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download and install Redis
RUN wget http://download.redis.io/releases/redis-7.0.15.tar.gz \
    && tar xzf redis-7.0.15.tar.gz \
    && cd redis-7.0.15 \
    && make && make install \
    && cd .. \
    && rm -rf redis-7.0.15 redis-7.0.15.tar.gz

# Create Redis user and ensure ownership of data directory
RUN groupadd -r redis && useradd -r -g redis redis \
    && mkdir -p /data /var/log/redis \
    && chown -R redis:redis /data /var/log/redis

# Copy custom Redis configuration file
COPY redis.conf /usr/local/etc/redis/redis.conf

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the working directory
WORKDIR /data

# Expose Redis port
EXPOSE 6379

# Set the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Start Redis with the custom configuration
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]