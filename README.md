*This project has been created as part of the 42 curriculum by melkess.*

# Description

Inception is a Docker-based infrastructure project. It runs a small WordPress
website through three dedicated services:

- NGINX terminates HTTPS and forwards PHP requests to WordPress.
- WordPress runs PHP-FPM and WP-CLI.
- MariaDB stores the WordPress database.

The services are built from local Dockerfiles based on Debian Bookworm and are
connected through the `inception` Docker network. WordPress files and MariaDB
data persist in named Docker volumes backed by `/home/melkess/data` on the
host. NGINX is the only published entry point and exposes port 443.

## Project Structure

- `Makefile`: build, start, stop, clean, and status commands.
- `srcs/docker-compose.yml`: services, network, volumes, and secrets.
- `srcs/requirements/`: one Dockerfile and service configuration per service.
- `secrets/`: local password files used by Docker Compose secrets.

## Main Design Choices

### Docker and virtual machines

A virtual machine includes a complete guest operating system and its own
kernel. Docker containers share the host kernel and isolate processes using
Linux kernel features. Containers are therefore lighter and start faster,
while virtual machines provide stronger operating-system-level separation.

### Secrets and environment variables

Environment variables are appropriate for non-sensitive configuration such as
the domain, database name, and WordPress usernames. Passwords are supplied as
Docker secrets and read from `/run/secrets`, so they are not written directly
in Dockerfiles or Compose environment values.

### Docker network and host network

The `inception` bridge network gives the containers private service-to-service
DNS and connectivity. The containers can use names such as `mariadb` without
publishing their internal ports. Host networking would remove this isolation
and make a container share the host network namespace.

### Docker volumes and bind mounts

Docker volumes are managed by Docker and are convenient for persistent
container data. A bind mount maps an explicit host path. This project uses
named volumes with local driver options so Docker manages the volume names
while the data is stored at the required host paths under
`/home/melkess/data`.

## Instructions

### Prerequisites

- A Linux virtual machine with Docker Engine and the Docker Compose plugin.
- A user allowed to run Docker commands.
- The local password files in `secrets/`.
- A hosts entry mapping `melkess.42.fr` to the VM IP address.

Create `srcs/.env` locally with the non-secret configuration expected by the
Compose file and WordPress entrypoint:

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

The administrator username must not contain `admin` or `administrator`.
Keep `.env` and all files under `secrets/` local.

### Build and run

From the repository root:

```sh
make
```

Open `https://melkess.42.fr` in a browser. The certificate is self-signed,
so a browser warning is expected in a local evaluation environment.

Useful commands:

```sh
make ps       # Show service status
make stop     # Stop containers without removing them
make start    # Start existing containers
make down     # Stop and remove the Compose containers and network
make restart  # Recreate the stack
make fclean   # Remove Docker resources and local project data
```

## Resources

- [Docker architecture](https://dev.to/srinivasamcjf/inside-docker-the-complete-architecture-explained-from-cli-to-kernel-4mf1)
- [Container runtime shims](https://iximiuz.com/en/posts/implementing-container-runtime-shim/)
- [PHP-FPM with NGINX](https://www.digitalocean.com/community/tutorials/php-fpm-nginx)
- [HTTP requests](https://http.dev/request)
- [URLs](https://http.dev/url)
- [Diffie-Hellman key exchange](https://dti-techs.gitbook.io/practical-foundations-in-cybersecurity/5.-cryptography-and-wireless-security/the-ssl-tls-handshake/the-diffie-hellman-key-exchange)
- [Diffie-Hellman implementation details](https://crackingwalnuts.com/cryptography-internals/diffie-hellman-key-exchange)
- [Akrou's Inception notes](https://docs.google.com/document/d/1yMpVQlpnKgkOwC7c1HRZM56knKZXjkQt5qs3MsHAmZ8/edit?pli=1&tab=t.a3yxzcapnwen)
- [OverlayFS and Docker](https://dev.to/hrrydgls/overlayfs-the-magic-behind-docker-52c6)
- [Docker networking](https://spacelift.io/blog/docker-networking#how-docker-networking-works)
- [Docker Engine networking documentation](https://docs.docker.com/engine/network/)
- [Docker network types](https://www.aidenwebb.com/posts/dockers-seven-network-types-and-when-to-use-them/)

AI was used as a study and writing aid: to organize documentation, clarify
Docker and networking terminology, and review the instructions against the
project files. The implementation, configuration, and commands remain tied to
the local repository and were checked against the actual Compose file,
Makefile, Dockerfiles, and entrypoint scripts.