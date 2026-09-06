COMPOSE		= docker compose -f srcs/docker-compose.yml
DATA_PATH	= /home/melkess/data

all: up

up: data-dirs
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

restart: down up

ps:
	$(COMPOSE) ps

data-dirs:
	mkdir -p $(DATA_PATH)/mariadb
	mkdir -p $(DATA_PATH)/wordpress

clean: down
	docker system prune -f

fclean: clean
	docker rmi -f $$(docker images -qa) 2>/dev/null || true
	docker volume rm -f $$(docker volume ls -q) 2>/dev/null || true
	docker network rm $$(docker network ls -q) 2>/dev/null || true
	sudo rm -rf $(DATA_PATH)

re: fclean up

.PHONY: all up down stop start restart ps data-dirs clean fclean re

