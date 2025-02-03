# FROM debian:bullseye
# RUN apt-get update -y && apt-get upgrade -y
# RUN apt-get install -y wget php php-mysqli
# COPY ./tools/entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh && /entrypoint.sh
# ENTRYPOINT [ "php", "-S", "0.0.0.0:8080", "-t", "/var/www/html" ]


FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y wget php php-mysqli && rm -rf /var/lib/apt/lists/*

# Copy entrypoint script
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]


FROM debian:bullseye

# Install dependencies
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y wget php php-mysqli

# Copy the entrypoint script
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the working directory
WORKDIR /var/www/html

# Run the entrypoint script when the container starts
ENTRYPOINT ["/entrypoint.sh"]

# Start the PHP server
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
