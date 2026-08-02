# Developer Documentation

## Prerequisites
- Docker Engine
- Docker Compose
- A local domain entry that points `<login>.42.fr` to your machine IP
- A Linux machine or virtual machine, as required by the subject

## Configuration Files
The project uses:
- `srcs/.env` for shared configuration values such as the domain name and database settings.
- `secrets/credentials.txt` for WordPress account passwords.
- `secrets/db_password.txt` for the MariaDB application password.
- `secrets/db_root_password.txt` for the MariaDB root password.

The Dockerfiles are located under `srcs/requirements/` and are one per service.

## Build and Launch
Use the Makefile from the repository root:
```bash
make
```
This creates the persistent host folders, builds the images, and starts the stack.

Other targets:
- `make build` to build the images only.
- `make up` to build and start the stack.
- `make stop` to stop the containers without removing them.
- `make down` to stop and remove the containers.
- `make clean` to remove the containers, network, and volumes.
- `make fclean` to remove the stack state and the host data directory.
- `make re` to reset and relaunch everything.

## Docker Compose Operations
The stack is defined in `srcs/docker-compose.yml`.

Useful commands:
```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs
```

## Data Persistence
Persistent data is stored in named Docker volumes:
- `mariadb_data` for the database
- `wordpress_data` for the WordPress files

Both volumes are backed by host directories under `/home/<login>/data`.

If you need to reset the persistent state, use:
```bash
make clean
```
If you need to remove the host-side data directory as well, use:
```bash
make fclean
```

## Notes for Maintenance
- NGINX is the only public service and should stay on port 443.
- WordPress runs with php-fpm only and must not contain nginx.
- MariaDB must remain isolated from the public interface.
- Avoid hardcoded credentials in Dockerfiles; keep them in the secret files and environment configuration.
