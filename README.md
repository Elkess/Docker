*This project has been created as part of the 42 curriculum by melkess.*

# Inception

## Description
Inception is a Docker-based system administration project whose goal is to build a small but complete web infrastructure from scratch. The stack is composed of three independent services: NGINX as the only public HTTPS entrypoint, WordPress with PHP-FPM, and MariaDB as the database backend.

The purpose of the project is to practice container orchestration, Docker networking, persistent storage, TLS configuration, and secure secret management. It also demonstrates the difference between a virtual machine and a lightweight containerized architecture, while reinforcing the need for a clean project layout and production-oriented environment variables.

## Instructions
1. Make sure Docker and Docker Compose are installed on your machine.
2. Configure your local domain so `melkess.42.fr` resolves to your machine's IP address.
3. Create or update the environment file in `srcs/.env` and the credentials in the `secrets/` directory.
4. From the repository root, run:
   ```bash
   make
   ```
5. Open `https://melkess.42.fr` in a browser.

Useful make targets:
- `make` or `make up`: build the images and start the stack.
- `make down`: stop the containers.
- `make stop`: stop the services without removing the created resources.
- `make clean`: remove the stack and prune unused Docker cache.
- `make fclean`: remove the stack, volumes, and host data directory.
- `make re`: rebuild the full environment from scratch.

## Project Description
The stack is composed of three custom-built services:
- NGINX terminates TLS and forwards requests to the WordPress container.
- WordPress runs with PHP-FPM only and stores its files on a persistent named volume.
- MariaDB stores the database data on a dedicated volume and remains isolated from the public network.

Main design choices:
- One container per service so each component can be managed independently.
- Named Docker volumes to keep data persistent under `/home/melkess/data`.
- A dedicated Docker network so containers can communicate without exposing internal ports.
- TLS-only access on port 443 to keep the public interface narrow and secure.
- Environment variables and Docker secrets rather than hardcoded credentials in Dockerfiles.

Comparison of key concepts:
- Virtual Machines vs Docker: a VM emulates an entire operating system, while Docker shares the host kernel and isolates processes in lightweight containers. Docker is faster and more resource-friendly, but a VM offers a broader system boundary.
- Secrets vs Environment Variables: environment variables are appropriate for non-sensitive configuration, while secrets should contain passwords and other confidential values. This project keeps secret data out of the Dockerfiles and repository.
- Docker Network vs Host Network: Docker networks isolate service communication and allow internal discovery without exposing all ports to the host. Host networking is forbidden here and would break the required architecture.
- Docker Volumes vs Bind Mounts: Docker volumes are managed by Docker and are ideal for persistent service state, while bind mounts expose arbitrary host paths directly. The project uses named volumes and stores their data in `/home/melkess/data`.

## Resources
Classic references used during the project:
- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- NGINX documentation: https://nginx.org/en/docs/
- WordPress documentation: https://wordpress.org/documentation/
- MariaDB knowledge base: https://mariadb.com/kb/en/
- PHP-FPM documentation: https://www.php.net/manual/en/install.fpm.php

AI was used to help draft the service layout, verify the correct Docker Compose structure, and debug configuration issues related to networking, TLS, and startup scripts. The final result was then validated manually with Docker Compose, container logs, and direct HTTPS checks in the browser.
