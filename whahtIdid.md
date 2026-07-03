# https://docs.docker.com/engine/install/debian/
sudo apt update
        │
        ▼
Refresh Debian package lists

        │
        ▼
Install curl and CA certificates

        │
        ▼
Create /etc/apt/keyrings/

        │
        ▼
Download Docker's public GPG key

        │
        ▼
Allow APT to read the key

        │
        ▼
Create a new repository definition (docker.sources)

        │
        ▼
Run apt update again

        │
        ▼
APT now knows about Docker's packages and trusts them

        │
        ▼
Ready to install Docker

# ============================================================
# Step 1: Install curl (if it isn't already installed)
# curl is a command-line program used to download files
# from the Internet using protocols like HTTP and HTTPS.
# ============================================================
sudo apt install curl


# ============================================================
# Step 2: Refresh APT's package index.
# This DOES NOT upgrade software.
# It simply downloads the latest list of available packages
# from every repository APT currently knows about.
# ============================================================
sudo apt update


# ============================================================
# Step 3: Install required packages.
#
# ca-certificates
#   Contains trusted Certificate Authorities (CAs) used to
#   verify HTTPS websites (like download.docker.com).
#
# curl
#   Downloads files from the Internet.
# ============================================================
sudo apt install ca-certificates curl


# ============================================================
# Step 4: Create the directory that will store repository
# signing keys.
#
# install
#   Normally copies files, but here it's used to create
#   a directory.
#
# -d
#   Create a directory.
#
# -m 0755
#   Set permissions:
#     Owner  -> rwx
#     Group  -> r-x
#     Others -> r-x
# ============================================================
sudo install -m 0755 -d /etc/apt/keyrings


# ============================================================
# Step 5: Download Docker's public GPG key.
#
# curl options:
#   -f  Fail on HTTP errors.
#   -s  Silent mode (hide progress bar).
#   -S  Show error messages if something fails.
#   -L  Follow redirects.
#
# -o
#   Save the downloaded file to the given location instead
#   of printing it on the terminal.
#
# The downloaded key will later be used by APT to verify
# that Docker packages really come from Docker.
# ============================================================
sudo curl -fsSL https://download.docker.com/linux/debian/gpg \
-o /etc/apt/keyrings/docker.asc


# ============================================================
# Step 6: Allow everyone to read Docker's public key.
#
# chmod
#   Change file permissions.
#
# a+r
#   a = all users
#   +r = add read permission
#
# APT must be able to read this key when verifying packages.
# ============================================================
sudo chmod a+r /etc/apt/keyrings/docker.asc


# ============================================================
# Step 7: Create a new APT repository definition.
#
# tee writes everything between <<EOF and EOF into
# /etc/apt/sources.list.d/docker.sources
#
# This tells APT where Docker packages are located and
# which key should be used to verify them.
# ============================================================
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF

# Repository type.
# "deb" means Debian binary packages.
Types: deb

# The URL of Docker's package repository.
URIs: https://download.docker.com/linux/debian

# Your Debian release codename.
#
# $(...)
#   Execute the command and replace it with its output.
#
# . /etc/os-release
#   Load operating system information into the shell.
#
# echo "$VERSION_CODENAME"
#   Print your Debian codename (for example: bookworm).
#
# Final result might become:
# Suites: bookworm
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")

# Use Docker's stable release channel.
Components: stable

# Your CPU architecture.
#
# dpkg --print-architecture
#
# Examples:
#   amd64
#   arm64
#
# This ensures APT downloads packages built for
# your processor.
Architectures: $(dpkg --print-architecture)

# Tell APT to verify packages from this repository
# using Docker's public GPG key.
Signed-By: /etc/apt/keyrings/docker.asc
EOF


# ============================================================
# Step 8: Refresh the package index again.
#
# Earlier, APT only knew about Debian's repositories.
#
# Now that Docker's repository has been added,
# APT downloads Docker's package list too.
#
# After this, packages like:
#   docker-ce
#   docker-ce-cli
#   containerd.io
#
# become available for installation.
# ============================================================
sudo apt update

# add my user to docker group so I can run docker without sudo 
https://docs.docker.com/engine/install/linux-postinstall

# show containers their images and their status
docker ps -a
# do into the container
docker exec -it {container} bash
# stop a container
docker stop {container}
# delete a container
docker rm {container}
# Docker instructions
https://docs.docker.com/reference/dockerfile