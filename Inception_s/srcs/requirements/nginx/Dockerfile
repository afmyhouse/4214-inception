FROM debian:bullseye
RUN apt update && apt upgrade -y
RUN apt install nginx -y && apt install openssl -y

COPY ./conf/antoda-s42fr.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/antoda-s42fr.conf /etc/nginx/sites-enabled/


COPY ./tools/setup.sh /
RUN chmod +x /setup.sh
ENTRYPOINT ["sh", "/setup.sh"]