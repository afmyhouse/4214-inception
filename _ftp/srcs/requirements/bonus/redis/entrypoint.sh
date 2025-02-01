#!/bin/sh
# Custom entrypoint script for Redis

# Set environment variables (if needed)
# export REDIS_PASSWORD=${REDIS_PASSWORD:-"your_redis_password"}

# Ensure the log directory exists
mkdir -p /var/log/redis
chown redis:redis /var/log/redis

# Ensure the data directory exists
mkdir -p  /var/www/html/wordpress

chown redis:redis /var/www/html/wordpress

# Start Redis with the custom configuration
exec redis-server /usr/local/etc/redis/redis.conf