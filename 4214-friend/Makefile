all: 
	@echo "127.0.0.1       hmaciel-.42.fr" >> /etc/hosts
	@docker-compose -f ./srcs/docker-compose.yml up

down:
	@docker-compose -f ./srcs/docker-compose.yml down

re:
	@docker-compose -f srcs/docker-compose.yml up --build

clean: down
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q) >> dev/null ; \
	docker network rm $$(docker network ls -q) >> /dev/null ; \

.PHONY: all re down clean