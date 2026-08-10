Master Checklist — Docker Fundamentals + Inception
Tick items off as you go. Don't skip ahead in a section — each box assumes the ones above it are actually done, not just skimmed.

PART A — Docker Fundamentals (do this first)
Exercise 1 — Run something and watch what happens
[ ] Ran docker run hello-world
[ ] Checked docker images and understand what got pulled
[ ] Checked docker ps -a and understand why the stopped container still shows up
Exercise 2 — Get inside a container
[ ] Ran docker run -it alpine sh, created a test file, exited
[ ] Ran it again fresh and confirmed the file was gone
[ ] Used docker start -ai <name> on the original container and confirmed the file was still there
[ ] Can explain the difference between docker run and docker start
Exercise 3 — Write your own Dockerfile
[ ] Wrote a scratch Dockerfile with FROM + RUN + CMD
[ ] Built it with docker build -t practice-image .
[ ] Ran it with docker run practice-image
[ ] Changed a line, rebuilt, and noticed the cache behavior
[ ] Can explain build-time (RUN) vs run-time (CMD) in your own words
[ ] Can explain why layer order affects build cache
Exercise 4 — Two containers talking to each other
[ ] Created a custom network with docker network create
[ ] Ran two containers on it and pinged one from the other by name
[ ] Ran a third container without --network and confirmed it could NOT reach the others
[ ] Can explain why containers on the same custom network resolve each other by name
[ ] Cleaned up containers and network
Exercise 5 — Data that survives a container's death
[ ] Created a named volume
[ ] Wrote a file into it from a --rm container
[ ] Started a new container with the same volume and confirmed the file was still there
[ ] Looked up named volume vs bind mount and can explain the difference
Exercise 6 — Why your container can't just "sleep forever"
[ ] Ran sleep 30 and watched the container stop on its own
[ ] Ran the infinite-loop version and saw it stay "Up" forever doing nothing
[ ] Can explain why PID 1 dying stops the container
[ ] Can explain why an infinite loop is a banned "fake keep-alive" hack
[ ] Looked up ENTRYPOINT vs CMD
[ ] Looked up how to run a real daemon (nginx/mysqld/php-fpm) in the foreground instead of backgrounding it
Exercise 7 — Docker Compose, minimally
[ ] Wrote a 2-service throwaway compose-practice.yml
[ ] Ran docker compose up -d and confirmed both services started
[ ] Used docker compose exec to ping one service from the other by service name
[ ] Can explain what problem Compose solves vs plain docker run
[ ] Ran docker compose down to clean up
Self-check gate (must pass before Part B)
[ ] Can explain image vs container in your own words
[ ] Can explain what docker build takes as input and produces as output
[ ] Can explain why same-network containers reach each other by name
[ ] Can explain why volume data outlives a removed container
[ ] Can explain why infinite-sleep is wrong and what the correct pattern is
[ ] Can explain what Compose solves that raw docker run doesn't
PART B — Inception Project
Phase 0 — Know the rules
[ ] Re-read the subject PDF fully
[ ] Wrote out the hard-constraints checklist from memory (base image version, one Dockerfile per service, no pre-built core images, foreground PID 1, auto-restart, no hardcoded passwords, secrets vs .env, NGINX-only entrypoint on 443 with TLS 1.2/1.3, WordPress has no NGINX, MariaDB has no NGINX and isn't public, two persistent host-backed volumes, one custom bridge network, <login>.42.fr resolves locally)
[ ] Can recite all of the above without looking
Phase 1 — Environment
[ ] Docker + Compose installed on your VM
[ ] Your user added to the docker group
[ ] <login>.42.fr added to /etc/hosts
[ ] Verified with docker run hello-world on the VM
Phase 2 — Skeleton
[ ] Sketched your own directory layout on paper
[ ] Created matching folders/files
[ ] Wrote .gitignore before adding anything sensitive
Phase 3 — MariaDB container
[ ] Understand mariadb-install-db / datadir initialization
[ ] Understand mysqld_safe vs running mysqld directly
[ ] Understand idempotency: detecting an already-initialized volume vs a fresh one
[ ] Understand how a container reads a Docker secret file
[ ] Dockerfile written (mariadb-server only, nothing extra)
[ ] Entrypoint script written (init-if-needed → create DB/user/passwords from secrets → exec mysqld in foreground)
[ ] Built and ran standalone with docker run, confirmed data survives a restart
[ ] Confirmed reachable from another container on the same custom network
Phase 4 — WordPress + php-fpm container
[ ] Understand what php-fpm is and that it doesn't serve HTTP itself
[ ] Understand why the pool's listen needs to be a TCP address, not a socket
[ ] Understand what wp-cli does and why it beats hand-editing wp-config.php
[ ] Understand the wait/retry pattern for "DB not ready yet"
[ ] Understand wp core install vs wp user create
[ ] Dockerfile written (php-fpm, php-mysql, wp-cli)
[ ] php-fpm pool config adjusted to listen on TCP
[ ] Entrypoint written (wait for DB → install/configure WP if not already → exec php-fpm in foreground)
[ ] Tested standalone against the working MariaDB container
Phase 5 — NGINX container
[ ] Understand openssl req self-signed cert generation and the -subj "/CN=..." field
[ ] Understand listen 443 ssl, ssl_protocols, server_name
[ ] Understand fastcgi_pass and how PHP requests get handed off
[ ] Dockerfile written (nginx, openssl, cert generated)
[ ] Server config written (TLS-only, proxies PHP to WordPress, serves static files)
[ ] Tested standalone once WordPress was reachable
Phase 6 — Wire it together with Compose
[ ] Understand why depends_on controls start order only, not readiness
[ ] Understand driver_opts bind-mounting a volume onto a host path
[ ] Understand top-level secrets: vs environment: and which values go where
[ ] docker-compose.yml written from scratch, tested service by service
[ ] Verified with docker network inspect that only your 3 containers share the network
[ ] Verified with docker compose ps that only NGINX has a published port
Phase 7 — Makefile
[ ] build, up, down, stop, clean, fclean, re targets written
[ ] Confirmed clean vs fclean do exactly what they should (data kept vs data wiped)
Phase 8 — Secrets & hygiene pass
[ ] Checked git history for leaked passwords
[ ] Checked docker inspect output for leaked secrets in environment
[ ] Confirmed entrypoints read secrets from mounted files, not plaintext env vars
Phase 9 — Test like an evaluator will
[ ] docker compose ps — all 3 containers Up, 0 restarts
[ ] docker compose logs clean for each service, no crash loops
[ ] curl -vk https://<login>.42.fr works
[ ] http://<login>.42.fr does NOT serve the site
[ ] Killed a container manually, confirmed it auto-restarted
[ ] make down then make up — confirmed WP content + DB data persisted
[ ] docker volume inspect confirms volumes point at your host data path
[ ] Logged into /wp-admin with admin account
[ ] Confirmed the second WordPress user exists
Phase 10 — Polish
[ ] README written (setup + run instructions)
[ ] Short write-up in your own words: VM vs container, volume vs bind mount, secrets vs env vars
[ ] (Optional) picked and built one bonus service following the same pattern
Done when every box above is checked and you can walk through the whole stack out loud — what each container does, why it's built that way, and what would break if you removed any one constraint — without notes.