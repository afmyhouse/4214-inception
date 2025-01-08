# mariadb docker file
# Step 1: define OS for the docker iamge
FROM debian:bullseye

# Install redis server and other necessary tools
RUN apt-get -y update && apt install redis-server -y && echo "maxmemory 256mb" >> /etc/redis/redis.conf

# Create the necessary directories
RUN echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf
RUN sed -i -r "s/bind 127.0.0.1/#bind 127.0.0.0/" /etc/redis/redis.conf


# By default, the container will run in the foreground
CMD ["redis-server",  "--protected-mode", "no"]
