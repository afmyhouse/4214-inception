# Use Debian Bullseye as the base image
FROM debian:bullseye

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    php-fpm \
    php-mysqli \
 && rm -rf /var/lib/apt/lists/*

# Copy the entrypoint script
COPY ./tools/entrypoint.sh /tools/entrypoint.sh

# Make the script executable
RUN chmod +x /tools/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/tools/entrypoint.sh"]
