

COMPOSE=./srcs/docker-compose.yml



ifeq ($(shell uname -s),Darwin)
	ENV_FILE=./srcs/.env
else
	ENV_FILE=/home/pstrohal/setup/.env
	$(shell cp $(ENV_FILE) ./srcs/.env)
endif

include $(ENV_FILE)
export $(shell sed 's/=.*//' $(ENV_FILE))

WPVOLUME=$(VOLUME_PATH)/wordpress_volume
DBVOLUME=$(VOLUME_PATH)/mariaDB_volume
VOLUMES= $(WPVOLUME) $(DBVOLUME)
SECRETS=./secrets

all: build up

up: 
	$(SUDO) docker compose -f $(COMPOSE) up

build:
	if [ ! -f ./srcs/.env ] ;then echo "NO ENVIRONMENT PROVIDED!!";exit 1;fi
	if [ ! -d $(SECRETS) ] ;then mkdir -p $(SECRETS); cp $(SETUP_SECRETS)/* $(SECRETS);fi
	if [ ! "$(shell ls $(SECRETS))" ] ;then echo "NO SECRETS PROVIDED!";exit 1;fi
	mkdir -p $(VOLUME_PATH) $(VOLUMES)
	$(SUDO) docker compose -f $(COMPOSE) build 

down:
	$(SUDO) docker compose -f $(COMPOSE) down 

stop:
	$(SUDO) docker compose -f $(COMPOSE) stop

start:
	$(SUDO) docker compose -f $(COMPOSE) start

fclean: stop down
	@if [ -n "$$(docker ps -qa)" ]; then $(SUDO) docker stop $$(docker ps -qa); fi
	@if [ -n "$$(docker ps -qa)" ]; then $(SUDO) docker rm $$(docker ps -qa); fi
	@if [ -n "$$(docker images -qa)" ]; then $(SUDO) docker rmi -f $$(docker images -qa); fi
	@if [ -n "$$(docker volume ls -q)" ]; then $(SUDO) docker volume rm $$(docker volume ls -q); fi
	@if [ -n "$$(docker network ls -q)" ]; then $(SUDO) docker network rm $$(docker network ls -q) 2>/dev/null || true; fi

prune:
		rm -rf ./srcs/volumes/mariaDB_volume/* 
		rm -rf ./srcs/volumes/wordpress_volume/* 

re: down prune up

again: stop down all
