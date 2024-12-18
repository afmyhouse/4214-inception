FROM debian:10.11

RUN apt-get update && apt-get install openssl nginx -y
#RUN mkdir /etc/nginx/ssl
# request ssl certificate
# https://www.openssl.org/docs/manmaster/man1/openssl-req.html
# https://www.ibm.com/docs/en/ibm-mq/7.5?topic=certificates-distinguished-names
#RUN openssl req -new -x509 -days 365 -nodes \
#        -out /etc/nginx/ssl/anton.pem \
#        -keyout /etc/nginx/ssl/anton.key \
#        -subj "/C=PO/ST=Porto/L=Porto/O=42Porto/OU=42Porto/CN=anton.42.fr"

RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/ssl/anton.42.fr.pem -keyout /etc/ssl/anton.42.fr.key -subj "/C=PT/ST=Porto/L=Porto/O=42 School/OU=anton/CN=anton.42.fr"
RUN chmod 600 /etc/ssl/anton.42.fr*
COPY ./conf/my-nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]