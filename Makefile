

COMPOSE= ./srcs/docker-compose.yml
VOLUMES= ./srcs/volumes/mariaDB_volume ./srcs/volumes/wordpress_volume

all: build up

up: 
	docker compose -f $(COMPOSE) up

build:
	mkdir -p ./srcs/volumes
	mkdir -p $(VOLUMES)
	docker compose -f $(COMPOSE) build --no-cache

down:
	docker compose -f $(COMPOSE) down

stop:
	docker compose -f $(COMPOSE) stop

start:
	docker compose -f $(COMPOSE) start



fclean:
	rm -rf ./srcs/volumes
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa); fi
	@if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa); fi
	@if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa); fi
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
	@if [ -n "$$(docker network ls -q)" ]; then docker network rm $$(docker network ls -q) 2>/dev/null || true; fi

end: stop down fclean

re: down fclean all

again: stop down all