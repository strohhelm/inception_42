

COMPOSE=./srcs/docker-compose.yml
VOLUMES=/home/pstrohal/data/mariaDB_volume \
		/home/pstrohal/data/wordpress_volume
DFOLDER=/home/pstrohal/data/
SFOLDER=$(DFOLDER)/secrets
SECRET1=$(SFOLDER)/db_root_password.txt

all: build up

up: 
	sudo docker compose -f $(COMPOSE) up 

build:
	mkdir -p $(DFOLDER) $(VOLUMES)
	@if [ ! -f $(SECRET1) ];then echo "no secrets provided!";exit 1;fi
	@if [ ! -f ./srcs/.env ];then echo "noe environment provided!!!";exit 1;fi
	sudo docker compose -f $(COMPOSE) build 

down:
	sudo docker compose -f $(COMPOSE) down 

stop:
	sudo docker compose -f $(COMPOSE) stop

start:
	sudo docker compose -f $(COMPOSE) start



fclean: stop down
	@if [ -n "$$(docker ps -qa)" ]; then sudo docker stop $$(docker ps -qa); fi
	@if [ -n "$$(docker ps -qa)" ]; then sudo docker rm $$(docker ps -qa); fi
	@if [ -n "$$(docker images -qa)" ]; then sudo docker rmi -f $$(docker images -qa); fi
	@if [ -n "$$(docker volume ls -q)" ]; then sudo docker volume rm $$(docker volume ls -q); fi
	@if [ -n "$$(docker network ls -q)" ]; then sudo docker network rm $$(docker network ls -q) 2>/dev/null || true; fi

prune:
		rm -rf ./srcs/volumes/mariaDB_volume/* 
		rm -rf ./srcs/volumes/wordpress_volume/* 

re: down prune up

again: stop down all
