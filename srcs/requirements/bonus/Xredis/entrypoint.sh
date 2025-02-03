#!/bin/bash

# Check if the Redis data directory exists, and if not, create it
if [ ! -d "/data" ]; then
  echo "Data directory not found, creating it..."
  mkdir -p /data
fi

# Ensure that the Redis user has the correct permissions to write to the data directory
chown -R redis:redis /data

# Create a log file for Redis if it doesn't exist
if [ ! -f "/var/log/redis/redis.log" ]; then
  touch /var/log/redis/redis.log
fi

# Ensure that the Redis user has the correct permissions to write to the log file
chown redis:redis /var/log/redis/redis.log
find /data -type d -exec chmod 775 {} \;
find /data -type f -exec chmod 775 {} \;
# Start Redis server with the provided configuration file
exec redis-server /usr/local/etc/redis/redis.conf
