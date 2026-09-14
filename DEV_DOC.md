# Developer Documentation

## Prerequisites
- Docker Engine and Docker Compose installed on a Linux VM or host.
- A valid local DNS mapping such as `melkess.42.fr` -> machine IP.
- The repository checked out at the project root.
- Permission to create files under `/home/melkess/data`.

## Environment Setup
The stack uses a shared environment file at `srcs/.env` and local secret files under `secrets/`.

Typical values include:
- `DOMAIN_NAME`
- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`

Sensitive credentials must stay out of the repository. The project expects files such as:
- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/wp_admin_password.txt`
- `secrets/wp_user_password.txt`

## Build and Launch
From the repository root, the project can be started with:
```bash
make
```
This target creates the host data directories, builds the images, and starts the stack with Docker Compose.

Useful Makefile targets:
```bash
make up        # build and start the project
make down      # stop the running services
make stop      # stop services without removing them
make clean     # stop and remove the stack
make fclean    # remove volumes and host data directory
make re        # restart everything from scratch
```

## Docker Compose Commands
The compose file is located at `srcs/docker-compose.yml`.

Useful commands:
```bash
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs -f
docker compose -f srcs/docker-compose.yml down
docker compose -f srcs/docker-compose.yml up --build -d
```

## Data Persistence
The project uses named Docker volumes:
- `mariadb_data` for the MariaDB state.
- `wordpress_data` for the WordPress files and plugins.

The host-side storage is created under `/home/melkess/data` and corresponds to the paths used by the Docker volume configuration. This ensures that the database and WordPress content persist across restarts.

To reset the data safely:
```bash
make clean
```

To remove the host data entirely:
```bash
make fclean
```

## Maintenance Notes
- NGINX must stay as the only public service and should remain bound to port 443.
- WordPress runs with PHP-FPM only; it must not embed NGINX.
- MariaDB must not be exposed publicly and must communicate through the Docker network.
- Keep all credentials in `secrets/` or in the `.env` file, never as hardcoded values inside Dockerfiles.
- Do not use `tail -f`, shell loops, or background daemons as a workaround for the container entrypoints.
