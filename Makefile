COMPOSE_FILE := srcs/docker-compose.yml
COMPOSE := docker compose -f $(COMPOSE_FILE)
HOST_DATA := /home/$(shell whoami)/data

.PHONY: all build up down stop clean fclean re dirs

all: up

dirs:
	mkdir -p $(HOST_DATA)/mariadb $(HOST_DATA)/wordpress

build: dirs
	HOST_DATA=$(HOST_DATA) $(COMPOSE) build

up: build
	HOST_DATA=$(HOST_DATA) $(COMPOSE) up -d

down:
	HOST_DATA=$(HOST_DATA) $(COMPOSE) down

stop:
	HOST_DATA=$(HOST_DATA) $(COMPOSE) stop

clean:
	HOST_DATA=$(HOST_DATA) $(COMPOSE) down -v --remove-orphans

fclean: clean
	rm -rf $(HOST_DATA)

re: fclean up
