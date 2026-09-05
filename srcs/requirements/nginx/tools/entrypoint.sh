#!/bin/sh
set -eu

export DOMAIN_NAME="${DOMAIN_NAME:-localhost}"

envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

exec nginx -g 'daemon off;'
