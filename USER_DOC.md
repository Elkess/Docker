# User Documentation

## Services Provided
This stack provides three main services:
- NGINX as the only public HTTPS entrypoint on port 443.
- WordPress with PHP-FPM as the website and administrative dashboard.
- MariaDB as the database backend that stores the site data.

The public website is available at `https://melkess.42.fr`.

## Start and Stop the Project
From the repository root, launch the project with:
```bash
make
```
You can also use:
```bash
make up
```

To stop the stack without deleting data:
```bash
make down
```

To stop the stack and remove persistent volumes:
```bash
make clean
```

## Access the Website and Administration Panel
- Open `https://melkess.42.fr` in your browser.
- The WordPress administration area is available at `https://melkess.42.fr/wp-admin`.
- If the browser warns about the self-signed certificate, accept the warning for this local project setup.
- Plain HTTP access should not work because the stack is configured to expose only HTTPS on port 443.

## Credentials and Secret Files
The sensitive values are stored locally in the `secrets/` directory:
- `secrets/wp_admin_password.txt` contains the WordPress administrator password.
- `secrets/wp_user_password.txt` contains the WordPress normal user password.
- `secrets/db_password.txt` contains the database user password.
- `secrets/db_root_password.txt` contains the MariaDB root password.

Do not commit these files to Git. Use the same values in the environment configuration when updating credentials.

## Check That the Services Are Running Correctly
Useful checks:
```bash
docker compose -f srcs/docker-compose.yml ps
```

To verify persistence:
```bash
docker volume ls
docker volume inspect mariadb_data
docker volume inspect wordpress_data
```

The volume inspection output should include the host data path under `/home/melkess/data`.

You can also confirm the installation is working by:
- opening the homepage over HTTPS,
- verifying that the WordPress dashboard loads,
- confirming that the stack does not expose HTTP on port 80.
