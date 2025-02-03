FROM debian:bullseye
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y redis-server
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && /entrypoint.sh
ENTRYPOINT [ "redis-server", "--protected-mode", "no" ]