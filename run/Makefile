NAME = Inception
DOCKER_PATH = ./srcs/docker-compose.yml


all: up

check_host:
	@ if ! grep -Fxq "127.0.0.1 anton.42.fr" /etc/hosts; then \
		echo "Creating host entry..."; \
		echo "127.0.0.1 anton.42.fr" | sudo tee -a /etc/hosts; \
	else \
		echo "Host entry already exists."; \
	fi

check_volume_folder:
	@ if [ ! -d "/home/anton/data/db" ] || [ ! -d "/home/anton/data/wp" ]; then \
		mkdir -p /home/anton/data/db /home/anton/data/wp; \
	else \
		echo "Volume entry already exists."; \
	fi

up: check_host check_volume_folder
	@ echo "Starting docker containers"
	@ docker compose -f $(DOCKER_PATH) up --build -d && \
	trap "make stop" EXIT

down:
	@ echo "Downing docker containers and remove images"
	@ docker compose -f $(DOCKER_PATH) down --rmi all -v

start:
	@ echo "Starting docker containers"
	@ docker compose -f $(DOCKER_PATH) start

stop:
	@ echo "Stopping docker containers"
	@ docker compose -f $(DOCKER_PATH) stop

clean:
	@ echo "Removing all docker stuff"
	@ docker system prune --all
	@ sudo rm -rf /home/anton/data

.PHONY: all up down start stop clean
