NAME = Inception
DOCKER_PATH = ./srcs/docker-compose.yml

all: up

check_host:
	@ if ! grep -q "127.0.0.1 nmoreira.42.fr" /etc/hosts; then \
		echo "Creating host entry..."; \
		echo "127.0.0.1 nmoreira.42.fr" | sudo tee -a /etc/hosts; \
	else \
		echo "Host entry already exists."; \
	fi

check_volume_folder:
	@ if [ ! -d "/home/nmoreira/data/db" ] || [ ! -d "/home/nmoreira/data/wp" ]; then \
	mkdir -p /home/nmoreira/data/db /home/nmoreira/data/wp; \
	fi # need to change for my login

build: check_host check_volume_folder
	@docker compose -f $(DOCKER_PATH) build

# posso colocar ou não o -d - funcionar no background daemon e libertar o terminal docker compose -f ./srcs/docker-compose.yml  start
up:	build
	@docker compose -f $(DOCKER_PATH) up

#up: check_host check_volume_folder
#	@ echo "Starting docker containers"
#	@ docker compose -f $(DOCKER_PATH) up --build

start:
	@docker compose -f $(DOCKER_PATH) start

stop:
	@docker compose -f $(DOCKER_PATH) stop

rm:	stop
	@docker compose -f $(DOCKER_PATH) rm

down:
	@ docker compose -f $(DOCKER_PATH) down 

rmi:		
	@docker compose -f $(DOCKER_PATH) down --rmi all

rmv:		
	@docker compose -f $(DOCKER_PATH) down --volumes

clean:		
	@docker compose -f $(DOCKER_PATH) down --rmi all --volumes

fclean: clean
	@sudo rm -rf /home/nmoreira/data;

re: fclean all

.PHONY: all up down build start stop rm rmi rmv clean fclean re