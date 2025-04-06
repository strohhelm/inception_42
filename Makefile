

COMPOSE=./srcs/docker-compose.yml



ifeq ($(shell uname -s),Darwin)
	ENV_FILE=./srcs/.env
else
	ENV_FILE=/home/pstrohal/setup/.env
endif

include $(ENV_FILE)
export $(shell sed 's/=.*//' $(ENV_FILE))

WPVOLUME=$(VOLUME_PATH)/wordpress_volume
DBVOLUME=$(VOLUME_PATH)/mariaDB_volume
FTPVOLUME=$(VOLUME_PATH)/ftp_volume
PORTAINERVOLUME=$(VOLUME_PATH)/portainer_volume
VOLUMES= $(WPVOLUME) $(DBVOLUME) $(FTPVOLUME) $(PORTAINERVOLUME)
SECRETS=./secrets
ENV=./srcs/.env

all: build up

up: 
	$(SUDO) docker compose -f $(COMPOSE) up

build:
	@if [ ! -f ./srcs/.env ] ;then echo "COPYING ENV_FILE.."; cp $(ENV_FILE) $(ENV);fi
	@if [ ! -f ./srcs/.env ] ;then echo "NO ENVIRONMENT PROVIDED!!";exit 1;fi
	@if [ ! -d $(SECRETS) ] ;then echo "CREATiNG DIRECTORY \"$(SECRETS)\"" &&  mkdir -p $(SECRETS) &&  echo "COPYING SECRETS.." && cp $(SETUP_SECRETS)/* $(SECRETS);fi
	@if [ ! "(ls $(SECRETS))" ];then echo "NO SECRETS PROVIDED!";exit 1;fi
	@mkdir -p $(VOLUME_PATH) $(VOLUMES)
	$(SUDO) docker compose -f $(COMPOSE) build

down: stop
	$(SUDO) docker compose -f $(COMPOSE) down 

stop:
	$(SUDO) docker compose -f $(COMPOSE) stop

start:
	$(SUDO) docker compose -f $(COMPOSE) start

fclean: stop down
	@if [ -n "$$(docker ps -qa)" ]; then $(SUDO) docker stop $$($(SUDO) docker ps -qa); fi
	@if [ -n "$$(docker ps -qa)" ]; then $(SUDO) docker rm $$($(SUDO) docker ps -qa); fi
	@if [ -n "$$(docker images -qa)" ]; then $(SUDO) docker rmi -f $$($(SUDO) docker images -qa); fi
	@if [ -n "$$(docker volume ls -q)" ]; then $(SUDO) docker volume rm $$($(SUDO) docker volume ls -q); fi
	@if [ -n "$$(docker network ls -q)" ]; then $(SUDO) docker network rm $$($(SUDO) docker network ls -q) 2>/dev/null || true; fi

re: fclean all

again: stop down all
