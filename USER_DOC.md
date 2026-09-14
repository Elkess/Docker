# User Documentation

## Services

The stack provides a WordPress website. NGINX handles HTTPS on port 443,
WordPress runs PHP-FPM, and MariaDB stores the website database. The services
communicate over the private `inception` Docker network.

## Start and Stop

From the repository root, after creating `srcs/.env` and the local secret
files:

```sh
make          # Create data directories, build images, and start the stack
make ps       # Check service status
make stop     # Stop containers
make start    # Start existing containers
make down     # Stop and remove the Compose containers
```

To remove Docker resources and the persisted project data, use `make fclean`.
This is destructive for the WordPress site and database.

## Access

Add the following mapping to the VM's hosts file, replacing the IP address with
the VM address:

```text
<vm-ip> melkess.42.fr
```

Then visit:

- Website: `https://melkess.42.fr`
- Administration panel: `https://melkess.42.fr/wp-admin`

The HTTPS certificate is self-signed, so the browser may display a warning.
There is no published HTTP entry point.

## Credentials

Passwords are kept in the local files under `secrets/`:

- `db_password.txt`: WordPress database user's password.
- `wp_admin_password.txt`: WordPress administrator password.
- `wp_user_password.txt`: WordPress author's password.

The usernames, email addresses, domain, and database name are configured in
the local `srcs/.env` file. Do not commit either the secrets or `.env` file.

## Health Checks

```sh
make ps
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
docker volume ls
```

All three containers should be running. The website should show the installed
WordPress site rather than the WordPress installation screen. Persistent data
is stored in `/home/melkess/data/mariadb` and `/home/melkess/data/wordpress`.