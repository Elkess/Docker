# Developer Documentation

## Prerequisites

- Linux virtual machine.
- Docker Engine and the Docker Compose plugin.
- Permission to run Docker commands.
- A local DNS or `/etc/hosts` entry for `melkess.42.fr`.

## Local Configuration

Create `srcs/.env` with the non-sensitive values consumed by Compose and the
WordPress entrypoint:

```dotenv
DOMAIN_NAME=melkess.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
WP_TITLE=Inception
WP_ADMIN_USER=siteowner
WP_ADMIN_EMAIL=siteowner@example.com
WP_USER=editor
WP_USER_EMAIL=editor@example.com
```

Create or verify these local files before the first build:

```text
secrets/db_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

The `.gitignore` excludes both `.env` files and the `secrets/` directory.

## Build and Launch

Run all commands from the repository root:

```sh
make data-dirs
make up
make ps
```

`make up` creates the host data directories, builds the three local images,
and starts the Compose project in detached mode. The service definitions are
in `srcs/docker-compose.yml` and the Dockerfiles are in
`srcs/requirements/{mariadb,wordpress,nginx}`.

The images are built locally from Debian Bookworm. No ready-made application
image is used. NGINX publishes only `443:443`; MariaDB and PHP-FPM remain
internal to the Docker network.

## Container Management

```sh
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs -f nginx
docker compose -f srcs/docker-compose.yml exec wordpress sh
docker compose -f srcs/docker-compose.yml exec mariadb mariadb -u root
make stop
make start
make down
```

Use `make clean` to remove unused Docker resources. `make fclean` additionally
removes images, volumes, networks, and `/home/melkess/data`; use it only when
resetting the project completely.

## Persistence

The Compose file declares two named volumes:

- `mariadb_data` maps to `/home/melkess/data/mariadb` and contains MariaDB data.
- `wordpress_data` maps to `/home/melkess/data/wordpress` and contains the
  WordPress files shared by the WordPress and NGINX services.

Inspect the mappings with:

```sh
docker volume ls
docker volume inspect mariadb_data
docker volume inspect wordpress_data
```

The local driver options use the required host paths while keeping the storage
declared as named Docker volumes. Do not delete these directories when testing
restarts or persistence.

## Troubleshooting

```sh
docker compose -f srcs/docker-compose.yml logs mariadb
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs nginx
docker network inspect inception
```

If WordPress starts before MariaDB is ready, the WordPress entrypoint retries
the database check. If the site is reinitialized, verify that the secret files,
`.env` values, and the persistent volume contents are consistent.