# nginx docker file
# Step 1: define OS for the docker iamge
FROM debian:bullseye

# Step 2: Install dependencies
RUN apt update && apt upgrade -y
RUN apt install nginx -y && apt install openssl -y
RUN apt update && apt install -y curl
# Step 3: Add nginx site
COPY ./conf/antoda-s42fr.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/antoda-s42fr.conf /etc/nginx/sites-enabled/


# Step 4: Copy custom entrypoint script
COPY ./tools/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Step 6: Set entrypoint
ENTRYPOINT ["sh", "/entrypoint.sh"]