FROM debian:10.11

RUN apt-get update && apt-get install openssl nginx -y
#RUN mkdir /etc/nginx/ssl
# request ssl certificate
# https://www.openssl.org/docs/manmaster/man1/openssl-req.html
# https://www.ibm.com/docs/en/ibm-mq/7.5?topic=certificates-distinguished-names
#RUN openssl req -new -x509 -days 365 -nodes \
#        -out /etc/nginx/ssl/hmp.pem \
#        -keyout /etc/nginx/ssl/hmp.key \
#        -subj "/C=PO/ST=Porto/L=Porto/O=42Porto/OU=42Porto/CN=hmaciel-.42.fr"

RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/ssl/hmaciel-.42.fr.pem -keyout /etc/ssl/hmaciel-.42.fr.key -subj "/C=PT/ST=Porto/L=Porto/O=42 School/OU=hmaciel-/CN=hmaciel-.42.fr"
RUN chmod 600 /etc/ssl/hmaciel-.42.fr*
COPY ./conf/my-nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]