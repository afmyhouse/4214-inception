NAME = my_docker_project

all: build up

build:
	docker compose -f ./srcs/docker-compose.yml build

up:
	docker compose -f ./srcs/docker-compose.yml up -d

log:
	docker compose -f ./srcs/docker-compose.yml logs

down:
	docker compose -f ./srcs/docker-compose.yml down

clean: down
	docker system prune -af
	rm -rf ./data/*

re: clean all
