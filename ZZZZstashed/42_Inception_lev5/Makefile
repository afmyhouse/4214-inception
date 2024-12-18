NAME = Inception
DOCKER_PATH = ./srcs/docker-compose.yml


all: up

check_host:
	@ if ! grep -Fxq "127.0.0.1 nsoares-.42.fr" /etc/hosts; then \
		echo "Creating host entry..."; \
		echo "127.0.0.1 nsoares-.42.fr" | sudo tee -a /etc/hosts; \
	else \
		echo "Host entry already exists."; \
	fi

check_volume_folder:
	@ if [ ! -d "/home/nsoares-/data/db" ] || [ ! -d "/home/nsoares-/data/wp" ]; then \
		mkdir -p /home/nsoares-/data/db /home/nsoares-/data/wp; \
	fi

up: check_host check_volume_folder
	@ echo "Starting docker containers"
	@ docker compose -f $(DOCKER_PATH) up --build && \
	trap "make stop" EXIT

down:
	@ echo "Stopping/Remove docker containers"
	@ docker compose -f $(DOCKER_PATH) down --rmi all -v
	@ sudo rm -rf /home/nsoares-/data

start:
	@ echo "Starting docker containers"
	@ docker compose -f $(DOCKER_PATH) start

stop:
	@ echo "Stopping docker containers"
	@ docker compose -f $(DOCKER_PATH) stop

clean:
	@ echo "Removing all docker stuff"
	@ docker system prune --all

.PHONY: all up down start stop clean
