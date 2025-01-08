# Use a base image that contains vsftpd or install vsftpd manually
FROM ubuntu:20.04

# Install vsftpd and other necessary tools
RUN apt-get update && \
    apt-get install -y vsftpd && \
    apt-get clean

# Create the necessary directories
RUN mkdir -p /var/ftp/users /var/run/vsftpd/empty
# Set up configuration files and entrypoint
COPY ./conf/vsftpd.conf /etc/vsftpd.conf
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the FTP ports
EXPOSE 21
EXPOSE 10000-10100

# Set entrypoint and make the script executable
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

# By default, the container will run in the foreground
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
