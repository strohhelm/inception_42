

COMPOSE=./srcs/docker-compose.yml

ifeq ($(shell uname -s),Darwin)
	ENV_FILE=./srcs/.env
	VOLUME_PATH=./srcs/volumes
else
	ENV_FILE=/home/pstrohal/setup/.env
	VOLUME_PATH=/home/pstrohal/data
endif

include $(ENV_FILE)
export $(shell sed 's/=.*//' $(ENV_FILE))

WPVOLUME=$(VOLUME_PATH)/wordpress_volume
DBVOLUME=$(VOLUME_PATH)/mariaDB_volume
# FTPVOLUME=$(VOLUME_PATH)/ftp_volume
PORTAINERVOLUME=$(VOLUME_PATH)/portainer_volume
VOLUMES= $(WPVOLUME) $(DBVOLUME)  $(PORTAINERVOLUME) #ew$(FTPVOLUME)
SECRETS=./secrets
ENV=./srcs/.env

all: build up

up: 
	docker compose -f $(COMPOSE) up

build:
	@if [ ! -f ./srcs/.env ] ;then echo "COPYING ENV_FILE.."; cp $(ENV_FILE) $(ENV);fi
	@if [ ! -f ./srcs/.env ] ;then echo "NO ENVIRONMENT PROVIDED!!";exit 1;fi
	@if [ ! -d $(SECRETS) ] ;then echo "CREATiNG DIRECTORY \"$(SECRETS)\"" &&  mkdir -p $(SECRETS) &&  echo "COPYING SECRETS.." && cp $(SETUP_SECRETS)/* $(SECRETS);fi
	@if [ ! "(ls $(SECRETS))" ];then echo "NO SECRETS PROVIDED!";exit 1;fi
	@mkdir -p $(VOLUME_PATH) $(VOLUMES)
	docker compose -f $(COMPOSE) build

down: stop
	docker compose -f $(COMPOSE) down 

stop:
	docker compose -f $(COMPOSE) stop

start:
	docker compose -f $(COMPOSE) start

fclean: stop down
	@if [ -n "$$(docker ps -qa)" ]; then docker stop $$(docker ps -qa); fi
	@if [ -n "$$(docker ps -qa)" ]; then docker rm $$(docker ps -qa); fi
	@if [ -n "$$(docker images -qa)" ]; then docker rmi -f $$(docker images -qa); fi
	@if [ -n "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
	@if [ -n "$$(docker network ls -q)" ]; then docker network rm $$(docker network ls -q) 2>/dev/null || true; fi

re: fclean all

again: stop down all

killall: fclean
	@if [ -d $(VOLUME_PATH) ] ;then echo "DELETING VOLUMES.."; rm -rf $(VOLUME_PATH);fi
	@if [ -d $(SECRETS) ] ;then echo "DELETING SECRETS.."; rm -rf $(SECRETS);fi
	@if [ -f ./srcs/.env ] ;then echo "DELETING ENV FILE.."; rm -rf ./srcs/.env;fi
