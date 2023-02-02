#!/bin/bash
# Certificates last for 90 days so day need to be renewed

COMPOSE="/usr/local/bin/docker-compose --no-ansi"
DOCKER="/usr/bin/docker"

# full route from root to this directory
cd /home/[your-user-name]/wordpress/
$COMPOSE run certbot renew && $COMPOSE kill -s SIGHUP webserver
$DOCKER system prune -af