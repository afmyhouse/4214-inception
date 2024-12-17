FROM alpine:3.19

LABEL Name=nginx Version=0.0.1

EXPOSE 443
EXPOSE 9000

RUN apk update && apk add nginx openssl

# SSL/TLS Certificate Generation
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt -subj "/CN=${DOMAIN_NAME}"

# Copy NGINX config
COPY conf/nginx.conf /etc/nginx/nginx.conf


CMD ["nginx", "-g", "daemon off;"]