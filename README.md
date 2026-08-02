*This project has been created as part of the 42 curriculum by melkess.*

# Inception

## Description
Inception is a Docker-based system administration project that builds a small but complete web infrastructure from scratch. The stack contains NGINX as the only public entrypoint over HTTPS, WordPress with php-fpm, and MariaDB as a separate database service.

The goal is to understand how Docker images, containers, networks, volumes, and environment-based configuration work together to provide a persistent web service. The project also highlights the difference between using Docker as a packaging/runtime tool and using a virtual machine as a full system sandbox.

## Instructions
1. Make sure Docker and Docker Compose are installed on your machine.
2. Configure your local domain so `<login>.42.fr` resolves to your machine IP address.
3. Fill the `.env` file and the files in `secrets/` with your own values.
4. Run:
   ```bash
   make
   ```
5. Open `https://<login>.42.fr` in your browser.

Useful targets:
- `make` or `make up` to build and start the stack.
- `make down` to stop the stack.
- `make clean` to stop the stack and remove volumes.
- `make fclean` to remove the stack and the host data directory.
- `make re` to rebuild everything from scratch.

## Project Description
The stack is composed of three custom-built services:
- NGINX terminates TLS and proxies requests to WordPress.
- WordPress runs with php-fpm only and stores its application files on a persistent volume.
- MariaDB stores the database on a persistent volume and is isolated from the public network.

Main design choices:
- One container per service, so each component can be managed independently.
- Named volumes for persistence, with host-backed storage under `/home/<login>/data`.
- A dedicated Docker network so the services talk to each other without exposing internal ports publicly.
- TLS-only access on port 443 to keep the public interface narrow.
- Environment variables and secret files instead of hardcoded credentials.

Comparison of key concepts:
- Virtual Machines vs Docker: VMs virtualize the whole operating system, while Docker shares the host kernel and isolates services at the process/container level. Docker is lighter and faster to start, but a VM offers a stronger system boundary.
- Secrets vs Environment Variables: environment variables are convenient for non-sensitive configuration, while secrets are better for passwords and credentials. This project uses both so the sensitive values stay out of Dockerfiles.
- Docker Network vs Host Network: a Docker network gives service isolation and controlled service discovery, while host networking exposes containers directly to the host stack. The project uses a dedicated bridge network because host networking is forbidden and unnecessary.
- Docker Volumes vs Bind Mounts: volumes are managed by Docker and are better suited for persistent service data, while bind mounts map arbitrary host paths directly into a container. This project uses named volumes for persistence and keeps their backing data under `/home/<login>/data`.

## Resources
Classic references that helped while building the project:
- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- NGINX documentation: https://nginx.org/en/docs/
- WordPress documentation: https://wordpress.org/documentation/
- MariaDB knowledge base: https://mariadb.com/kb/en/
- PHP-FPM documentation: https://www.php.net/manual/en/install.fpm.php

AI was used to speed up repetitive work such as drafting the initial service wiring, checking configuration shape against the subject, and debugging startup problems in the MariaDB and WordPress entrypoints. The final implementation was verified manually with Docker Compose, container logs, and HTTPS access checks.
