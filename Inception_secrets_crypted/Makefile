NAME = Inception
DOCKER_PATH = ./srcs/docker-compose.yml

all: up

check_host:
	@ if ! grep -q "127.0.0.1 antoda-s.42.fr" /etc/hosts; then \
		echo "Creating host entry..."; \
		echo "127.0.0.1 antoda-s.42.fr" | sudo tee -a /etc/hosts; \
	else \
		echo "Host entry already exists."; \
	fi

check_volume_folder:
	@ if [ ! -d "/home/antoda-s/data/db" ] || [ ! -d "/home/antoda-s/data/wp" ]; then \
	mkdir -p /home/antoda-s/data/db /home/antoda-s/data/wp; \
	fi # need to change for my login

# build: check_host check_volume_folder
# 	@docker compose -f $(DOCKER_PATH) build 

# posso colocar ou não o -d - funcionar no background daemon e libertar o terminal docker compose -f ./srcs/docker-compose.yml  start
# up: build
# 	@docker compose -f $(DOCKER_PATH) up

up: check_host check_volume_folder
	@ echo "docker containers UP"
	@ docker compose -f $(DOCKER_PATH) up -d
# @ docker compose -f $(DOCKER_PATH) up --build  && \
# trap "make stop" EXIT

start:
	@ echo "docker containers START"
	@docker compose -f $(DOCKER_PATH) start

stop:
	@ echo "docker containers STOP"
	@docker compose -f $(DOCKER_PATH) stop

rm:	stop
	@ echo "docker containers REMOVE"
	@docker compose -f $(DOCKER_PATH) rm

down:
	@ echo "docker containers DOWN"
	@ docker compose -f $(DOCKER_PATH) down 

rmi:		
	@ echo "docker containers images REMOVE"
	@docker compose -f $(DOCKER_PATH) down --rmi all

rmv:		
	@ echo "docker containers volumes REMOVE"
	@docker compose -f $(DOCKER_PATH) down --volumes

clean:		
	@ echo "docker containers all REMOVE"
	@docker compose -f $(DOCKER_PATH) down --rmi all --volumes

fclean: clean
	@ echo "all REMOVE"
	@sudo rm -rf /home/antoda-s/data;

re: fclean all

.PHONY: all up down build start stop rm rmi rmv clean fclean re