NAME = Inception
DOCKER_PATH = ./srcs/docker-compose.yml


all: build up

check_host:
	@ if ! grep -Fxq "127.0.0.1 antoda-s.42.fr" /etc/hosts; then \
		echo "Creating host entry..."; \
		echo "127.0.0.1 antoda-s.42.fr" | sudo tee -a /etc/hosts; \
	else \
		echo "Host entry already exists."; \
	fi

check_volume_folder:
	@ if [ ! -d "/home/antoda-s/data/db" ] || [ ! -d "/home/antoda-s/data/wp" ]; then \
		mkdir -p /home/antoda-s/data/db /home/antoda-s/data/wp; \
	else \
		echo "Volume entry already exists."; \
	fi

build:
	@ echo "Building docker containers"
	@ docker compose -f $(DOCKER_PATH) build

up: check_host check_volume_folder
	@ echo "Starting docker containers"
	@ docker compose -f $(DOCKER_PATH) up

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
	@ sudo rm -rf /home/antoda-s/data

.PHONY: all build up down start stop clean
