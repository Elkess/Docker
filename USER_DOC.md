# User Documentation

## Services Provided
This stack provides:
- NGINX as the public HTTPS entrypoint.
- WordPress as the website and administration frontend.
- MariaDB as the database backend.

The public website is available at `https://<login>.42.fr`.

## Start and Stop the Project
From the repository root, use:
```bash
make
```
or:
```bash
make up
```

To stop the stack:
```bash
make down
```

To stop the stack and remove the persistent volumes:
```bash
make clean
```

## Access the Website and Administration Panel
- Open `https://<login>.42.fr` in your browser.
- The WordPress administration area is available at `https://<login>.42.fr/wp-admin`.
- If your browser warns about the certificate, accept the self-signed certificate for local development.

## Credentials
Credentials are stored in the `secrets/` folder:
- `secrets/credentials.txt` for the WordPress administrator and user passwords.
- `secrets/db_password.txt` for the WordPress database user password.
- `secrets/db_root_password.txt` for the MariaDB root password.

If you change them, keep the same keys and update the project environment consistently.

## Check That Services Are Running
Useful checks:
- `docker compose -f srcs/docker-compose.yml ps` to see the containers.
- `docker volume ls` to list the persistent volumes.
- `docker volume inspect mariadb_data` and `docker volume inspect wordpress_data` to confirm persistence.
- Open the website in a browser and verify that the WordPress homepage loads over HTTPS.
- Confirm that `http://<login>.42.fr` does not serve the site.
